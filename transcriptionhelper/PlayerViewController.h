//
//  PlayerViewController.h
//  Transcribe Helper
//
//  Created by Soheil on 9/18/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMediaPickerController.h>

#import "ItunesMediaPickerController.h"
#import "FileManagerViewController.h"

@interface PlayerViewController : UIViewController <MPMediaPickerControllerDelegate, AVAudioPlayerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate>

-(void) configMediaItem:(MPMediaItem *)item;
-(void) configFileItem:(NSURL *)url;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) NSTimer *playScheduleTimer;
@property (strong, nonatomic) ItunesMediaPickerController *ItunesMediaPickerController;
@property (strong, nonatomic) FileManagerViewController *FileManagerViewController;

@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@property (weak, nonatomic) IBOutlet UITextField *stepTextField;
@property (weak, nonatomic) IBOutlet UITextField *delayTextField;
@property (weak, nonatomic) IBOutlet UITextField *offsetTextField;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *timerSlider;
@property (weak, nonatomic) IBOutlet UILabel *audioTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *audioTotalTimeLabel;

@property (strong,nonatomic) UIPickerView *decimalPicker;
@property (strong,nonatomic) UIToolbar *decimalPickerAccessoryView;
@property (strong, nonatomic) UIPopoverController *decimalPickerPopover;


- (IBAction)playPress:(id)sender;
- (IBAction)timerChanged:(id)sender;
- (IBAction)backgroundPressed:(id)sender;
- (IBAction)selectAnotherPressed:(id)sender;


-(void)playPauseSchedule:(NSTimer *)timer;

@end

