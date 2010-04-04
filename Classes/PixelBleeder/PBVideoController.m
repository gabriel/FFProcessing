//
//  PBVideoController.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "PBVideoController.h"

#import "FFUtils.h"
#import "FFProcessing.h"

#import <MobileCoreServices/UTCoreTypes.h>


@implementation PBVideoController

@synthesize delegate=_delegate;

- (void)dealloc {
  [_videoController release];
  [super dealloc];
}

- (UIImagePickerController *)videoController {
  if (!_videoController) {
    _videoController = [[UIImagePickerController alloc] init];
    _videoController.navigationBarHidden = YES;
    _videoController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; 
    _videoController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_videoController.sourceType];
    FFDebug(@"mediaTypes=%@", mediaTypes);
    
    //NSArray *mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMPEG];
    
    _videoController.allowsImageEditing = YES;
    _videoController.mediaTypes = mediaTypes;
    _videoController.delegate = self;
  }
  return _videoController;
}

- (void)loadView {    
  self.view = [self videoController].view;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[self videoController] viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[self videoController] viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[self videoController] viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[self videoController] viewDidDisappear:animated];
}

#pragma mark Delegates (UIImagePickerControllerDelegate)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSURL *URL = [info objectForKey:UIImagePickerControllerMediaURL];
  if (URL) [_delegate videoController:self didSelectURL:URL];  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { 
  [self.navigationController popViewControllerAnimated:YES];
}

@end
