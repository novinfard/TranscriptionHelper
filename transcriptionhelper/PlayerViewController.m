//
//  ViewController.m
//  Transcribe Helper
//
//  Created by Soheil on 9/18/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import "PlayerViewController.h"
#import <math.h>
#import <MBProgressHUD/MBProgressHUD.h>



@interface PlayerViewController () {
    BOOL isPlaying;
    BOOL isPlayingAll;
    double stepDuration;
    double delayDuration;
    double offsetDuration;
    double remainingPlayDuration;
    NSString* currentPicker;
    MPMediaItem* mediaItem;
    BOOL newMediaItem;
    NSURL* fileUrl;
    BOOL newFileItem;
}

@end

@implementation PlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"viewDidLoad");
    
    self.stepTextField.delegate = self;
    self.delayTextField.delegate = self;
    self.offsetTextField.delegate = self;
    
    if(newMediaItem) {
        // initial stop
        [self.playScheduleTimer invalidate];
        [self.audioPlayer stop];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        self.playButton.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
        
        self.stepTextField.enabled = YES;
        self.delayTextField.enabled = YES;
        self.offsetTextField.enabled = YES;
        self.statusLabel.text = @"";
        self.audioTimeLabel.text = @"";
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //        MPMediaItem *item = [mediaItemCollection representativeItem];
        self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] error:nil];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        self.audioPlayer.numberOfLoops = 0; //-1: Infinite
        self.audioPlayer.delegate = self;
        
        [self.audioPlayer prepareToPlay];
        self.timerSlider.maximumValue = [self.audioPlayer duration];
        self.audioTotalTimeLabel.text = [self timeFormatted:[self.audioPlayer duration] byShortStyle:YES];
        self.timerSlider.value = 0.0;
        
        remainingPlayDuration = 0.0;
        
        isPlaying = NO;
        isPlayingAll = NO;
        
        AVAsset *asset = [AVURLAsset URLAssetWithURL:[mediaItem valueForProperty:MPMediaItemPropertyAssetURL] options:nil];
        
        NSArray *metadata = [asset commonMetadata];
        for ( AVMetadataItem* item in metadata ) {
            //                    NSString *key = [item commonKey];
            //                    NSString *value = [item stringValue];
            //                    NSLog(@"key = %@, value = %@", key, value);
            
            if([[item commonKey] isEqualToString:@"title"]) {
                self.audioTitleLabel.text = [item stringValue];
            }
//            if ([[item commonKey] isEqualToString:@"artwork"]) {
//
//                UIImage *img = nil;
//                if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
//                    img = [UIImage imageWithData:[item.value copyWithZone:nil]];
//                }
//                else { // if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
//                    NSData *data = [(NSDictionary *)[item value] objectForKey:@"data"];
//                    img = [UIImage imageWithData:data]  ;
//                }
//                if(img) {
//                    NSLog(@"have artwork");
//                    self.artworkImage.image = img;
//                }
//            }
        }
        
        
        
        NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                               withKey:AVMetadataCommonKeyArtwork
                                                              keySpace:AVMetadataKeySpaceCommon];
            
            for (AVMetadataItem *item in artworks) {
                if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
//                    NSDictionary *dict = [item.value copyWithZone:nil];
//                    if([dict objectForKey:@"data"]) {
                        self.artworkImage.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
//                    }
                } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                    self.artworkImage.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
                }
            }
        }];
        
        newMediaItem = NO;
    }
    
    if(newFileItem) {
        // initial stop
        [self.playScheduleTimer invalidate];
        [self.audioPlayer stop];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        self.playButton.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
        
        self.stepTextField.enabled = YES;
        self.delayTextField.enabled = YES;
        self.offsetTextField.enabled = YES;
        self.statusLabel.text = @"";
        self.audioTimeLabel.text = @"";
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //        MPMediaItem *item = [mediaItemCollection representativeItem];
        self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        self.audioPlayer.numberOfLoops = 0; //-1: Infinite
        self.audioPlayer.delegate = self;
        
        [self.audioPlayer prepareToPlay];
        self.timerSlider.maximumValue = [self.audioPlayer duration];
        self.audioTotalTimeLabel.text = [self timeFormatted:[self.audioPlayer duration] byShortStyle:YES];
        self.timerSlider.value = 0.0;
        
        remainingPlayDuration = 0.0;
        
        isPlaying = NO;
        isPlayingAll = NO;
        
        AVAsset *asset = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
        
        NSArray *metadata = [asset commonMetadata];
        for ( AVMetadataItem* item in metadata ) {
            //                    NSString *key = [item commonKey];
            //                    NSString *value = [item stringValue];
            //                    NSLog(@"key = %@, value = %@", key, value);
            
            if([[item commonKey] isEqualToString:@"title"]) {
                self.audioTitleLabel.text = [item stringValue];
            }
            //            if ([[item commonKey] isEqualToString:@"artwork"]) {
            //
            //                UIImage *img = nil;
            //                if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
            //                    img = [UIImage imageWithData:[item.value copyWithZone:nil]];
            //                }
            //                else { // if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
            //                    NSData *data = [(NSDictionary *)[item value] objectForKey:@"data"];
            //                    img = [UIImage imageWithData:data]  ;
            //                }
            //                if(img) {
            //                    NSLog(@"have artwork");
            //                    self.artworkImage.image = img;
            //                }
            //            }
        }
        
        
        
        NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                               withKey:AVMetadataCommonKeyArtwork
                                                              keySpace:AVMetadataKeySpaceCommon];
            
            for (AVMetadataItem *item in artworks) {
                if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                    //                    NSDictionary *dict = [item.value copyWithZone:nil];
                    //                    if([dict objectForKey:@"data"]) {
                    self.artworkImage.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
                    //                    }
                } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                    self.artworkImage.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
                }
            }
        }];
        
        newFileItem = NO;
    }
    
    
    
    //    NSBundle *bundle = [NSBundle mainBundle];
    //    NSString *audioPath = [bundle pathForResource:@"sample" ofType:@"mp3"];
    //    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    //
    //    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    
}

-(void)viewWillAppear:(BOOL)animated {
//    if(self.ItunesMediaPickerController)
//        [self.ItunesMediaPickerController dismissViewControllerAnimated:NO completion:nil];
//    
//    if(self.FileManagerViewController)
//        [self.FileManagerViewController dismissViewControllerAnimated:NO completion:nil];

}

-(void) configMediaItem:(MPMediaItem *)item
{
//    NSLog(@"configMediaItem");

    mediaItem = item;
    newMediaItem = YES;

}

-(void) configFileItem:(NSURL *)url
{
//    NSLog(@"configFileItem %@",url);
    
    fileUrl = url;
    newFileItem = YES;
    
}

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
//    NSLog(@"didPickMediaItems");
    
    // initial stop
    [self.playScheduleTimer invalidate];
    [self.audioPlayer stop];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    self.stepTextField.enabled = YES;
    self.delayTextField.enabled = YES;
    self.offsetTextField.enabled = YES;
    self.statusLabel.text = @"";
    self.audioTimeLabel.text = @"";
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    MPMediaItem *item = [mediaItemCollection representativeItem];
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[item valueForProperty:MPMediaItemPropertyAssetURL] error:nil];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    //    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.audioPlayer.numberOfLoops = 0; //-1: Infinite
    self.audioPlayer.delegate = self;
    
    [self.audioPlayer prepareToPlay];
    self.timerSlider.maximumValue = [self.audioPlayer duration];
    self.audioTotalTimeLabel.text = [self timeFormatted:[self.audioPlayer duration] byShortStyle:YES];
    self.timerSlider.value = 0.0;
    
    remainingPlayDuration = 0.0;
    
    isPlaying = NO;
    isPlayingAll = NO;
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:[item     valueForProperty:MPMediaItemPropertyAssetURL] options:nil];
    
    NSArray *metadata = [asset commonMetadata];
    for ( AVMetadataItem* item in metadata ) {
        //        NSString *key = [item commonKey];
        //        NSString *value = [item stringValue];
        //        NSLog(@"key = %@, value = %@", key, value);
        
        if([[item commonKey] isEqualToString:@"title"]) {
            self.audioTitleLabel.text = [item stringValue];
        }
    }
    
}


- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
//    NSLog(@"mediaPickerDidCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)playPress:(id)sender {
    [self endDecimalPicker];

    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
    // set control values
    if(![self.stepTextField.text isEqualToString:@""])
    {
        stepDuration = [self.stepTextField.text doubleValue];
    } else {
        stepDuration = 2.5;
    }
    
    if(![self.delayTextField.text isEqualToString:@""])
    {
        delayDuration = [self.delayTextField.text doubleValue];
    } else {
        delayDuration = 10.0;
    }
    
    if(![self.offsetTextField.text isEqualToString:@""])
    {
        offsetDuration = [self.offsetTextField.text doubleValue];
    } else {
        offsetDuration = 0.4;
    }
    
    
    if(isPlayingAll) {
        [self.audioPlayer pause];
        isPlayingAll = NO;
        isPlaying = NO;

        [self.playScheduleTimer invalidate];
        
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        self.playButton.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
        
        self.stepTextField.enabled = YES;
        self.delayTextField.enabled = YES;
        self.offsetTextField.enabled = YES;
        self.statusLabel.text = @"";
        
    } else {
        [self.audioPlayer play];
        self.statusLabel.text = @"Listen carefully";
        if(self.audioPlayer.currentTime - offsetDuration > 0)
            self.audioPlayer.currentTime = self.audioPlayer.currentTime - offsetDuration;
        isPlayingAll = YES;
        isPlaying = YES;
        
        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.playButton.backgroundColor = [UIColor redColor];
        
        self.stepTextField.enabled = NO;
        self.delayTextField.enabled = NO;
        self.offsetTextField.enabled = NO;
        
        //[playScheduleTimer invalidate];
        remainingPlayDuration = stepDuration;
        self.playScheduleTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playPauseSchedule:) userInfo:nil repeats:YES];
    }
}

-(void)playPauseSchedule:(NSTimer *)timer  {
    
//    Float64 dur = CMTimeGetSeconds(self.audioPlayer.currentTime);
//    Float64 durInMiliSec = 1000*dur;
    
//    NSLog(@"%@", CMTimeGetSeconds(self.audioPlayer.currentTime));
    
//    NSLog(@"remainingPlayDuration %f", remainingPlayDuration);
    
    remainingPlayDuration = floor(10.0 * remainingPlayDuration + 0.01) * 0.1;
    
    if(remainingPlayDuration == 0) {
        if(isPlaying) {
            remainingPlayDuration = -(delayDuration-1.0);
            [self.audioPlayer pause];
            self.statusLabel.text = @"Now, you have time to transcribe";
            isPlaying = NO;
        }
        else {
            remainingPlayDuration = stepDuration + offsetDuration;
        }
        return;
    } else if(remainingPlayDuration > 0) {
        if(!isPlaying) {
            [self.audioPlayer play];
            if(self.audioPlayer.currentTime - offsetDuration > 0)
                self.audioPlayer.currentTime = self.audioPlayer.currentTime - offsetDuration;
            self.statusLabel.text = @"Listen carefully";
            isPlaying = YES;
        }
    }
    
    if(remainingPlayDuration >0 ) {
//        if(remainingPlayDuration >= 1)
            remainingPlayDuration = remainingPlayDuration - 0.1;
//        else
//            remainingPlayDuration = 0;
    }
    else if(remainingPlayDuration <0 ){
        remainingPlayDuration = remainingPlayDuration + 0.1;
    }

}

- (IBAction)timerChanged:(id)sender {
    self.audioPlayer.currentTime = self.timerSlider.value;
    remainingPlayDuration = stepDuration;
}

//- (IBAction)itunesPressed:(id)sender {
//    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
//    mediaPicker.delegate = self;
//    mediaPicker.allowsPickingMultipleItems = NO;
//    [self presentViewController:mediaPicker animated:YES completion:nil];
//}

- (IBAction)backgroundPressed:(id)sender {
    [self endDecimalPicker];
    [self.view endEditing:YES];
}

- (IBAction)selectAnotherPressed:(id)sender {
//    NSLog(@"self.navigationController.viewControllers %@", self.navigationController.viewControllers);
    
    [self.playScheduleTimer invalidate];
    [self.audioPlayer stop];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    self.stepTextField.enabled = YES;
    self.delayTextField.enabled = YES;
    self.offsetTextField.enabled = YES;
    self.statusLabel.text = @"";
    self.audioTimeLabel.text = @"";
    
    isPlaying = NO;
    isPlayingAll = NO;
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
        [self dismissViewControllerAnimated:NO completion:^(void) {
            if(self.ItunesMediaPickerController)
                [self.ItunesMediaPickerController dismissViewControllerAnimated:NO completion:nil];
            
            if(self.FileManagerViewController)
                [self.FileManagerViewController dismissViewControllerAnimated:NO completion:nil];
        }];
    
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//    });

    
//    if(self.ItunesMediaPickerController)
//        [self.ItunesMediaPickerController dismissViewControllerAnimated:NO completion:nil];
//    
//    if(self.FileManagerViewController)
//        [self.FileManagerViewController dismissViewControllerAnimated:NO completion:nil];

}

#pragma mark - UIPickerView : Datasource Protocol
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    if (pickerView.tag == 100) {
//        return [self.countries count];
//    } else if (pickerView.tag == 101) {
//        return [self.provincesForCountry count];
//    }
//    else {
//        return false;
//    }
    if(component == 1)
        return 10;
//    if(component == 1)
//        return 0;
    else
        return 1000;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (pickerView.tag == 100) {
//        id aKey = [self.countriesSortedKeys objectAtIndex:row];
//        id country = [self.countries objectForKey:aKey];
//        return country[@"name"];
//        
//    } else if (pickerView.tag == 101) {
//        return [self.provincesForCountry[row] objectForKey:@"name"];
//    }
//    else{
//        return false;
//    }

//    if(component == 1)
//        return @".";
//    else
        return [NSString stringWithFormat:@"%ld", (long)row];
    
}

#pragma mark - UIPopoverController : Delegate
//- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
//    self.countryPickerPopover = nil;
//    self.provincePickerPopover = nil;
//}

#pragma mark - UIPickerView : Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (pickerView.tag == 100) {
//        self.countrySelected = row;
//        
//        id aKey = [self.countriesSortedKeys objectAtIndex:row];
//        id country = [self.countries objectForKey:aKey];
//        
//        self.countryField.text = country[@"areaCode"];
//        self.countrySelected = row;
//        [self provincePickerConfig];
//        self.provinceField.text = @"";
//        
//        // change country's provinces
//        [self setProvincesList:country[@"code"]];
//        self.provinceSelected = 0;
//        [self.provincePicker selectRow:self.provinceSelected inComponent:0 animated:YES];
//        self.provinceField.text = self.provincesForCountry[self.provinceSelected][@"name"];
//        [self.provincePicker reloadAllComponents];
//        
//    } else if (pickerView.tag == 101) {
//        self.provinceField.text = [self.provincesForCountry[row] objectForKey:@"name"];
//        self.provinceSelected = row;
//    }
    
    NSString *newValue = [NSString stringWithFormat:@"%ld.%ld", (long)[self.decimalPicker selectedRowInComponent:0], (long)[self.decimalPicker selectedRowInComponent:1]];
    if([currentPicker isEqualToString:@"step"]) {
        self.stepTextField.text = newValue;
    }
    else if([currentPicker isEqualToString:@"delay"]) {
       self.delayTextField.text = newValue;
    }
    else if([currentPicker isEqualToString:@"offset"]) {
        self.offsetTextField.text = newValue;
    }
    
    //    NSLog(@"%ld", (long)row);
}

#pragma mark - UITextView : Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 101:
            currentPicker = @"step";
            break;
            
        case 102:
            currentPicker = @"delay";
            break;
            
        case 103:
            currentPicker = @"offset";
            break;
            
        default:
            break;
    }
    
    [self showDecimalPicker];
    return NO;
}

#pragma mark - Others
- (void)updateTimer:(NSTimer *)timer {
    self.timerSlider.value = self.audioPlayer.currentTime;
    self.audioTimeLabel.text = [self timeFormatted:self.audioPlayer.currentTime byShortStyle:NO];
}

- (NSString *)timeFormatted:(double)totalSeconds byShortStyle:(BOOL)shortStyle
{
    
    int millisecond = (totalSeconds - (int)totalSeconds)*100;
    millisecond = ((millisecond / 10) % 10)*10;
    int seconds = (int)totalSeconds % 60;
    int minutes = ((int)totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if(hours == 0)
    {
        if(shortStyle)
            return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
        else
            return [NSString stringWithFormat:@"%02d:%02d:%02d", minutes, seconds, millisecond];
    }
    else
    {
        if(shortStyle)
            return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
        else
            return [NSString stringWithFormat:@"%02d:%02d:%02d:%02d",hours, minutes, seconds, millisecond];
    }
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//    NSLog(@"audioPlayerDidFinishPlaying");
    
    [self.playScheduleTimer invalidate];
    [self.audioPlayer stop];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.backgroundColor = [UIColor colorWithRed:132.0/255.0 green:208.0/255.0 blue:55.0/255.0 alpha:1.0];
    
    self.stepTextField.enabled = YES;
    self.delayTextField.enabled = YES;
    self.offsetTextField.enabled = YES;
    self.statusLabel.text = @"";
    self.audioTimeLabel.text = @"";
    
    isPlaying = NO;
    isPlayingAll = NO;
}

-(void) showDecimalPicker {
    if (self.decimalPicker == nil) {
        UIPickerView *select = [[UIPickerView alloc] init];
        //        UIPickerView *select = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        select.delegate = self;
        select.dataSource = self;
        [select setShowsSelectionIndicator:YES];
        select.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
        
        CGSize viewSize = [[UIScreen mainScreen] bounds].size;
//        select.frame = CGRectMake(0, self.navigationController.view.frame.size.height+select.frame.size.height+44, viewSize.width, 216);
        select.frame = CGRectMake(0, viewSize.height-216, viewSize.width, 216);

        
        
        CGAffineTransformMakeTranslation (self.view.frame.size.width, self.view.frame.size.height);
        self.decimalPicker = select;
        
        self.decimalPickerAccessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, viewSize.height-216-44, viewSize.width, 44)];
        self.decimalPickerAccessoryView.translucent = YES;
        [self.decimalPickerAccessoryView setBackgroundImage:[UIImage new]
                                    forToolbarPosition:UIToolbarPositionAny
                                            barMetrics:UIBarMetricsDefault];
        self.decimalPickerAccessoryView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.decimalPickerAccessoryView.opaque = NO;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endDecimalPicker)];
        [self.decimalPickerAccessoryView setItems:[NSArray arrayWithObject:doneButton]];
        
//                self.provinceField.inputdecimalPickerAccessoryView = self.decimalPickerAccessoryView;
//        [self.decimalPickerAccessoryView setHidden:YES];
        [self.view addSubview:self.decimalPickerAccessoryView];
        
//        [self.decimalPicker setHidden:YES];
        
        [self.view addSubview:self.decimalPicker];
        [self.view bringSubviewToFront:self.decimalPicker];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((viewSize.width-36)/2, 76, 36, 36)];
        label.font = [UIFont boldSystemFontOfSize:40];
        label.layer.cornerRadius = 18.0;
        label.layer.masksToBounds = YES;
        label.text = @".";
        [label setTextColor:[UIColor darkGrayColor]];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.shadowColor = [UIColor whiteColor];
        label.shadowOffset = CGSizeMake (0,1);
    
        [select addSubview:label];
        
//        if (!self.provinceSelected) {
//            self.provinceSelected = self.provinceDefault;
//        }
        
//        self.provinceField.text = [self.provincesForCountry[self.provinceSelected] objectForKey:@"areaCode"];
        
        self.decimalPicker = select;
    }
    self.decimalPicker.hidden = NO;
    self.decimalPickerAccessoryView.hidden = NO;
    
    NSString *currentNumber;
    if([currentPicker isEqualToString:@"step"]) {
        currentNumber = self.stepTextField.text;
    }
    else if([currentPicker isEqualToString:@"delay"]) {
        currentNumber = self.delayTextField.text;
    }
    else if([currentPicker isEqualToString:@"offset"]) {
        currentNumber = self.offsetTextField.text;
    }
    NSArray *currentNumberArray = [currentNumber componentsSeparatedByString:@"."];
    [self.decimalPicker selectRow:[currentNumberArray[0] integerValue] inComponent:0 animated:YES];
    [self.decimalPicker selectRow:[currentNumberArray[1] integerValue] inComponent:1 animated:YES];

}

-(void)endDecimalPicker {
    self.decimalPicker.hidden = YES;
    self.decimalPickerAccessoryView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    NSLog(@"prepareForSegue");
}


@end
