//
//  FilesTableViewCell.h
//  transcriptionhelper
//
//  Created by Soheil on 10/7/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileTitle;
@property (weak, nonatomic) IBOutlet UILabel *fileAlbum;
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;

@end
