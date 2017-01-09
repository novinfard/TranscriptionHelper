//
//  FileManagerViewController.h
//  transcriptionhelper
//
//  Created by Soheil on 10/5/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileManagerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)donePressed:(id)sender;
- (IBAction)submitDownloadNewPressed:(id)sender;
- (IBAction)closeDownloadNewPressed:(id)sender;
- (IBAction)openDownloadNewPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *downloadNewOneView;
@property (weak, nonatomic) IBOutlet UITextField *downloadNewField;
@property (weak, nonatomic) IBOutlet UITableView *filesTable;

@property (strong, nonatomic) NSMutableArray *filesList;

@end
