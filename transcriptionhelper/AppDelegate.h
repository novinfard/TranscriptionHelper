//
//  AppDelegate.h
//  Transcribe Helper
//
//  Created by Soheil on 9/18/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (nonatomic, strong) NSTimer *myTimer;
- (BOOL) isMultitaskingSupported;
//- (void) timerMethod:(NSTimer *)paramSender;


@end

