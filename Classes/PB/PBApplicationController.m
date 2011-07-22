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
  _modeNavigationView = [[PBUIModeNavigationView alloc] initWithFrame:CGRectMake(0, 200, 320, 200)];
  _modeNavigationView.optionsDelegate = self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  _modeNavigationView.optionsDelegate = nil;
  [_modeNavigationView release];
  _modeNavigationView = nil;  
}

- (void)updateImagingOptions:(FFGLImagingOptions)imagingOptions {
  [_cameraCaptureController setImagingOptions:imagingOptions];
}

- (void)updateFilter:(id<FFFilter>)filter {
  [_cameraCaptureController setFilter:filter];
}

- (void)cameraCaptureControllerDidTouch:(PBCameraCaptureController *)cameraCaptureController {
  if ([_modeNavigationView superview]) {    
    [_modeNavigationView popToRootViewAnimated:NO];
    [_modeNavigationView removeFromSuperview];    
  } else {
    [self.view addSubview:_modeNavigationView];
  }
}

@end
