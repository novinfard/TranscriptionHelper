//
//  AppDelegate.m
//  Transcribe Helper
//
//  Created by Soheil on 9/18/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[[Crashlytics class]]];
    
    NSString *storyBoardName = @"splashStory";
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
//        NSString *currentBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        
        NSString *firstLaunch = @"YES";
        if([standardUserDefaults objectForKey:@"firstLaunch"])
        {
            firstLaunch = [standardUserDefaults objectForKey:@"firstLaunch"];
            
        }
        if(![firstLaunch isEqualToString:@"YES"]) {
            storyBoardName = @"startStory";
        } else {
            [standardUserDefaults setObject:@"NO" forKey:@"firstLaunch"];
            [standardUserDefaults synchronize];
        }
    }

    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:storyBoardName];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if ([self isMultitaskingSupported] == NO)
    {
        return;
    }
//    self.myTimer =[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerMethod:) userInfo:nil
//                                                  repeats:YES];
    
    UIViewController *visibleGeneral = [self visibleViewController:[UIApplication sharedApplication].keyWindow.rootViewController];

    if([visibleGeneral isKindOfClass:[PlayerViewController class]]) {
        PlayerViewController *vc = (PlayerViewController *)visibleGeneral;
//        NSLog(@"PlayerViewController on background Initial");
        if(vc.playScheduleTimer) {
            self.myTimer = vc.playScheduleTimer;


            self.backgroundTaskIdentifier =[application beginBackgroundTaskWithExpirationHandler:^(void) {
                [self endBackgroundTask];
            }];
        }
    }
}

- (UIViewController *)visibleViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil)
    {
        return rootViewController;
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [self visibleViewController:lastViewController];
    }
    if ([rootViewController.presentedViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController.presentedViewController;
        UIViewController *selectedViewController = tabBarController.selectedViewController;
        
        return [self visibleViewController:selectedViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    
    return [self visibleViewController:presentedViewController];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL) isMultitaskingSupported
{
    BOOL result = NO;
    if ([[UIDevice currentDevice]
         respondsToSelector:@selector(isMultitaskingSupported)]){ result = [[UIDevice currentDevice] isMultitaskingSupported];
    }
    return result;
}


//- (void) timerMethod:(NSTimer *)paramSender{
//    
//    NSTimeInterval backgroundTimeRemaining =
//    [[UIApplication sharedApplication] backgroundTimeRemaining];
//    if (backgroundTimeRemaining == DBL_MAX)
//    {
//        NSLog(@"Background Time Remaining = Undetermined");
//    }
//    else
//    {
//        NSLog(@"Background Time Remaining = %.02f Seconds",backgroundTimeRemaining);
//    }
//}

- (void) endBackgroundTask
{
    dispatch_queue_t mainQueue = dispatch_get_main_queue(); __weak AppDelegate *weakSelf = self;
    dispatch_async(mainQueue, ^(void) { AppDelegate *strongSelf = weakSelf; if (strongSelf != nil){
        [strongSelf.myTimer invalidate];
        [[UIApplication sharedApplication]
         endBackgroundTask:self.backgroundTaskIdentifier];
        strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    } });
}

@end
