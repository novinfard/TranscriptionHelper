//
//  PageContentViewController.h
//  mohtera
//
//  Created by Soheil Novinfard on 7/28/15.
//  Copyright (c) 2015 Ima inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *textDesc;

@property NSUInteger pageIndex;

@end
