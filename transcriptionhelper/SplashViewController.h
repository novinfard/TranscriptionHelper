//
//  SplashController.h
//  mohtera
//
//  Created by Soheil Novinfard on 7/28/15.
//  Copyright (c) 2015 Ima inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface SplashViewController : UIViewController <UIPageViewControllerDataSource>


@property (weak, nonatomic) IBOutlet UIView *movieView;

-(void)playMovie;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageDescriptions;

@end
