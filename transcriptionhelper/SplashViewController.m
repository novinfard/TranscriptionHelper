//
//  SplashController.m
//  mohtera
//
//  Created by Soheil Novinfard on 7/28/15.
//  Copyright (c) 2015 Ima inc. All rights reserved.
//

#import "SplashViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SplashViewController () {
    MPMoviePlayerController *moviePlayerController;
}

@end

@implementation SplashViewController

# pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"";
    }
    return self;
}

# pragma mark - View Events

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [Answers
//     logCustomEventWithName:@"Register & Login"
//     customAttributes:@{@"Section": @"Splash"}
//     ];

    // add Observer to notification center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appplicationIsActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self playMovie];
    [self pageControl];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [moviePlayerController play];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [moviePlayerController pause];
}

# pragma mark - General Tasks

- (void)appplicationIsActive:(NSNotification *)notification {
    [moviePlayerController play];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

# pragma mark

- (void)playMovie {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"splash2" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:moviePath];
    
    moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    // screen's size
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	NSLog(@"%f", screenHeight);
    
    CGFloat width, height, origX, origY;
    width = height = MAX(screenHeight, screenWidth);
    origX = origY = 0;
    
//    moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
    moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
    [moviePlayerController.view setFrame:CGRectMake(origX, origY, screenWidth, screenHeight)];

    [self.movieView addSubview:moviePlayerController.view];
    
    // Configure the movie player controller
    moviePlayerController.controlStyle = MPMovieControlStyleNone;
    moviePlayerController.repeatMode = YES;
    moviePlayerController.shouldAutoplay = YES;
    [moviePlayerController prepareToPlay];
}

- (void) pageControl {
    // Create the data model
    _pageTitles = @[@"Transcription Helper",
                    @"Use Music App",
//                    @"Download the Audio"
                    ];
    
    _pageDescriptions = @[@"It's an assistant for people who want to work out a piece of audio, in order to write it out.",
                          @"You can use your own music library to choose the audio.",
//                          @"You can also download mp3 files directly and transcribe it."
                          ];
    
    // Create page view controller
    self.pageViewController = [[[NSBundle mainBundle] loadNibNamed:@"IntroSlider" owner:self options:nil] firstObject];
    self.pageViewController.dataSource = self;
//    self.pageViewController.view.hidden = NO;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - Page View Controller Data Source

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [[[NSBundle mainBundle] loadNibNamed:@"IntroSliderContent" owner:self options:nil] firstObject];
    pageContentViewController.textLabel.text = self.pageTitles[index];
    pageContentViewController.textDesc.text = self.pageDescriptions[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
        
    if (index == NSNotFound) {
        return nil;
    }
    else if (index == 0) {
        index = [self.pageTitles count];
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        index = 0;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


@end
