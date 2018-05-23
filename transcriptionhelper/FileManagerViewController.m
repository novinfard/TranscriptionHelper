//
//  FileManagerViewController.m
//  transcriptionhelper
//
//  Created by Soheil on 10/5/16.
//  Copyright © 2016 Ima inc. All rights reserved.
//

#import "FileManagerViewController.h"
#import "AFNetworking.h"
#import "FilesTableViewCell.h"
#import "PlayerViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface FileManagerViewController ()

@end

@implementation FileManagerViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.filesList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filesTable.delegate = self;
    self.filesTable.dataSource = self;
	
//	NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString  *documentsDirectory = [paths objectAtIndex:0];
//	NSLog(@"%@", documentsDirectory);

    
    UINib *nibFilesCell = [UINib nibWithNibName:@"FilesTableViewCell" bundle:nil];
    [self.filesTable registerNib:nibFilesCell forCellReuseIdentifier:@"files"];
    
    [self putFilesList];
    
}

- (void) putFilesList {
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"dir %@", documentsDirectory);
    
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSArray * dirContents =
//    [fm contentsOfDirectoryAtURL:[NSURL URLWithString:documentsDirectory]
//      includingPropertiesForKeys:@[]
//                         options:NSDirectoryEnumerationSkipsHiddenFiles
//                           error:nil];
//    NSPredicate * fltr = [NSPredicate predicateWithFormat:@"pathExtension='mp3'"];
//    NSArray * mediaFiles = [dirContents filteredArrayUsingPredicate:fltr];
    NSArray *mediaFiles = [self getSortedFilesFromFolder:documentsDirectory];
    
    //    [self.filesList arrayByAddingObjectsFromArray:mediaFiles];
    self.filesList = [mediaFiles mutableCopy];
    
//    NSLog(@"filesList %@", self.filesList);
}

//This is reusable method which takes folder path and returns sorted file list
-(NSArray*)getSortedFilesFromFolder: (NSString*)folderPath
{
    NSError *error = nil;
    NSArray* filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF EndsWith '.mp3'"];//Take only pdf file
    filesArray =  [filesArray filteredArrayUsingPredicate:predicate];
    
    // sort by creation date
    NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[filesArray count]];
    
    for(NSString* file in filesArray) {
        
        if (![file isEqualToString:@".DS_Store"]) {
            NSString* filePath = [folderPath stringByAppendingPathComponent:file];
            NSDictionary* properties = [[NSFileManager defaultManager]
                                        attributesOfItemAtPath:filePath
                                        error:&error];
            NSDate* modDate = [properties objectForKey:NSFileModificationDate];
            
            [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           filePath, @"path",
                                           modDate, @"lastModDate",
                                           nil]];
            
        }
    }
    
    // Sort using a block - order inverted as we want latest date first
    NSArray* sortedFiles = [filesAndProperties sortedArrayUsingComparator:
                            ^(id path1, id path2)
                            {
                                // compare
                                NSComparisonResult comp = [[path1 objectForKey:@"lastModDate"] compare:
                                                           [path2 objectForKey:@"lastModDate"]];
                                // invert ordering
                                if (comp == NSOrderedDescending) {
                                    comp = NSOrderedAscending;
                                }
                                else if(comp == NSOrderedAscending){
                                    comp = NSOrderedDescending;
                                }
                                return comp;
                            }];
    
    return sortedFiles;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeDownloadNewPressed:(id)sender {
    [self.view endEditing:YES];
    self.downloadNewOneView.hidden = YES;
}

- (IBAction)openDownloadNewPressed:(id)sender {
    self.downloadNewOneView.hidden = NO;
    [self.downloadNewField becomeFirstResponder];
}

-(void)submitDownloadNewPressed:(id)sender {
    // Step 1: create NSURL with full path to downloading file
    // And create NSURLRequest object with our URL
    
    NSURL *URL;
    if([self.downloadNewField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"No URL"
                                  message:@"Enter the URL of the MP3 file."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;
    } else {
//        if([[self.downloadNewField.text pathExtension] isEqualToString:@"mp3"]) {
            URL = [NSURL URLWithString:self.downloadNewField.text];
        [self.view endEditing:YES];
        self.downloadNewOneView.hidden = YES;
        self.downloadNewField.text = @"";
        
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"Error: MP3 File"
//                                      message:@"It is not an mp3 file"
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
//            return;
//        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Downloading ...";
    
    UIColor *color = [UIColor blackColor];
    color = [color colorWithAlphaComponent:0.5f];
    hud.backgroundColor = color;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
		
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		
		NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
			
			dispatch_async(dispatch_get_main_queue(), ^{
				//Update the progress view
//				[_myProgressView setProgress:downloadProgress.fractionCompleted];
				hud.progress = downloadProgress.fractionCompleted;
			});
			
			
			
		}
												  
		destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
			NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
			
			// Step 2: save downloading file's name
			// For example our fileName string is equal to 'jrqzn4q29vwy4mors75s_400x400.png'
//			NSString *fileName = [URL lastPathComponent];

//			NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//			NSString  *documentsDirectory = [paths objectAtIndex:0];
//
//			NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,fileName];
//
//			//        NSLog(@"successful %@" , filePath);

			
			return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
		} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
			NSLog(@"File downloaded to: %@", filePath);
			
			if([[filePath pathExtension] isEqualToString:@"mp3"]) {
				
				[self putFilesList];
				[self.filesTable reloadData];
				dispatch_async(dispatch_get_main_queue(), ^{
					[MBProgressHUD hideHUDForView:self.view animated:YES];
				});
			} else {
				dispatch_async(dispatch_get_main_queue(), ^{
					[MBProgressHUD hideHUDForView:self.view animated:YES];
				});
				UIAlertView *alertView = [[UIAlertView alloc]
										  initWithTitle:@"Error: MP3 File"
										  message:@"It is not an mp3 file"
										  delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
				[alertView show];
			}

		}];
		[downloadTask resume];
        
    });

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"files";
    FilesTableViewCell *cell = (FilesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[FilesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.fileTitle.text = @"";

//    NSLog(@"type: %@", [[[self.filesList objectAtIndex:indexPath.row] objectForKey:@"path"] class] );
    
    NSURL *itemURL = [NSURL fileURLWithPath:[[self.filesList objectAtIndex:indexPath.row] objectForKey:@"path"]];
    
    AVAsset *asset = [AVURLAsset URLAssetWithURL:itemURL options:nil];
    
    NSArray *metadata = [asset commonMetadata];
    NSString *artist;
//    NSString *albumName;
//    UIImageView *imageView;
    for (AVMetadataItem *item in metadata) {
        if ([[item commonKey] isEqualToString:@"title"]) {
            cell.fileTitle.text = (NSString *)[item value];
        }
        
        if ([[item commonKey] isEqualToString:@"artist"]) {
            artist = (NSString *)[item value];
        }
        
        if ([[item commonKey] isEqualToString:@"albumName"]) {
            cell.fileAlbum.text = (NSString *)[item value];
        }
        
//        if ([[item commonKey] isEqualToString:@"artwork"]) {
//            NSData *data = [(NSDictionary *)[item value] objectForKey:@"data"];
//            UIImage *img = [UIImage imageWithData:data] ;
//            cell.fileImage.image = img;
//            continue;
//        }
        
        NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                               withKey:AVMetadataCommonKeyArtwork
                                                              keySpace:AVMetadataKeySpaceCommon];
            
            for (AVMetadataItem *item in artworks) {
                if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                    //                    NSDictionary *dict = [item.value copyWithZone:nil];
                    //                    if([dict objectForKey:@"data"]) {
                    cell.fileImage.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
                    //                    }
                } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                    cell.fileImage.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
                }
            }
        }];
    }
    
    if([cell.fileTitle.text isEqualToString:@""])
        cell.fileTitle.text = [itemURL lastPathComponent];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"numberOfRowsInSection %ld", (long)[self.filesList count]);
    return [self.filesList count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didSelectRowAtIndexPath");
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSURL *itemURL = [NSURL fileURLWithPath:[[self.filesList objectAtIndex:indexPath.row] objectForKey:@"path"]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PlayerViewController *pvc = [storyboard instantiateViewControllerWithIdentifier:@"playerStory"];
    pvc.FileManagerViewController = self;
    [pvc configFileItem:itemURL];
    [pvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:pvc animated:YES completion:nil];
}

@end
