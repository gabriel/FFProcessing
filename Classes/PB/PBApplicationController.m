//
//  PBApplicationController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/21/10.
//  Copyright 2010. All rights reserved.
//

#import "PBApplicationController.h"

@implementation PBApplicationController

- (id)init {
  if ((self = [super init])) {
    _cameraCaptureController = [[PBCameraCaptureController alloc] init];    
    _cameraCaptureController.delegate = self;
    [self setViewController:_cameraCaptureController animated:NO cache:NO];
  }
  return self;
}

- (void)dealloc {
  [self viewDidUnload];
  _cameraCaptureController.delegate = nil;
  [_cameraCaptureController release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _optionsView = [[PBUIOptionsView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
  _optionsView.optionsDelegate = self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  _optionsView.optionsDelegate = nil;
  [_optionsView release];
  _optionsView = nil;  
}

- (void)updateImagingOptions:(FFGLImagingOptions)imagingOptions {
  [_cameraCaptureController setImagingOptions:imagingOptions];
}

- (void)updateFilter:(id<FFFilter>)filter {
  [_cameraCaptureController setFilter:filter];
}

- (void)cameraCaptureControllerDidTouch:(PBCameraCaptureController *)cameraCaptureController {
  if ([_optionsView superview]) {    
    [_optionsView popToRootViewAnimated:NO];
    [_optionsView removeFromSuperview];    
  } else {
    [self.view addSubview:_optionsView];
  }
}

@end
