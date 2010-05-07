//
//  PBImagePickerController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "PBImagePickerController.h"

#import "FFUtils.h"
#import "FFProcessing.h"

#import <MobileCoreServices/UTCoreTypes.h>


@implementation PBImagePickerController

@synthesize delegate=_delegate, mediaTypes=_mediaTypes, imageController=_imageController;

- (id)initWithSourceType:(UIImagePickerControllerSourceType)sourceType mediaTypes:(NSArray *)mediaTypes {
  if ((self = [super init])) {
    _sourceType = sourceType;
    _mediaTypes = [mediaTypes retain];
  }
  return self;
}

- (void)dealloc {
  [_imageController release];
  [_mediaTypes release];
  [super dealloc];
}

- (UIImagePickerController *)imageController {
  if (!_imageController) {
    _imageController = [[UIImagePickerController alloc] init];
    _imageController.navigationBarHidden = YES;
    _imageController.sourceType = _sourceType;    
    _imageController.allowsEditing = YES;
    if (_mediaTypes)
      _imageController.mediaTypes = _mediaTypes;
    _imageController.delegate = self;
  }
  return _imageController;
}

- (void)loadView {    
  self.view = [self imageController].view;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[self imageController] viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[self imageController] viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[self imageController] viewWillDisappear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[self imageController] viewDidDisappear:animated];
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSURL *URL = [info objectForKey:UIImagePickerControllerMediaURL];
  if (URL) [_delegate imageController:self didSelectURL:URL];  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { 
  [self.navigationController popViewControllerAnimated:YES];
}

@end
