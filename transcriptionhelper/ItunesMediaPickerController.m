//
//  ItunesMediaPickerController.m
//  transcriptionhelper
//
//  Created by Soheil on 10/5/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import "ItunesMediaPickerController.h"
#import "PlayerViewController.h"

@interface ItunesMediaPickerController ()

@end

@implementation ItunesMediaPickerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allowsPickingMultipleItems = NO;
    }
    return self;
}


- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSLog(@"didPickMediaItems own");
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"playerStory"];
    pvc.ItunesMediaPickerController = self;
    [pvc configMediaItem:[mediaItemCollection representativeItem]];
    [pvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:pvc animated:YES completion:nil];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    NSLog(@"here mediaPickerDidCancel own");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
}


@end
