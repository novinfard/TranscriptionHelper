//
//  PageContentViewController.m
//  mohtera
//
//  Created by Soheil Novinfard on 7/28/15.
//  Copyright (c) 2015 Ima inc. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()

@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.textLabel.font = [self.textLabel.font fontWithSize:45];
        self.textDesc.font = [self.textDesc.font fontWithSize:25];
    }

}

@end
