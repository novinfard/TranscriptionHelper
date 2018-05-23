//
//  FilesTableViewCell.m
//  transcriptionhelper
//
//  Created by Soheil on 10/7/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import "FilesTableViewCell.h"

@implementation FilesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {
	[super prepareForReuse];
    self.fileImage.image = nil;
    self.fileTitle.text = @"";
    self.fileAlbum.text = @"";
}

@end
