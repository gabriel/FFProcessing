//
//  PBCameraPickerCaptureController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/6/10.
//  Copyright 2010. All rights reserved.
//

#import "PBCameraPickerCaptureController.h"

// Now a public method
CGImageRef UIGetScreenImage();

@implementation PBCameraPickerCaptureController

- (id)init {
  if ((self = [super initWithSourceType:UIImagePickerControllerSourceTypeCamera
                             mediaTypes:nil])) {
    
    self.imageController.showsCameraControls = NO;
    self.imageController.allowsEditing = NO;
  }
  return self;
}

- (void)dealloc {
  [_processingTimer invalidate];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  /*!
  [_overlayView release];
  _overlayView = [[PBCameraOverlayView alloc] initWithFrame:CGRectMake(40, 40, 100, 100)];
  self.imageController.cameraOverlayView = _overlayView;
   */
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  _processingTimer = [NSTimer scheduledTimerWithTimeInterval:1/5.0f target:self selector:@selector(_processImage) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_processingTimer invalidate];
}

- (void)_processImage {
  if (_image != NULL) CGImageRelease(_image);
  _image = UIGetScreenImage();
  _overlayView.image = _image;
  [_overlayView setNeedsDisplay];
}


@end

@implementation PBCameraOverlayView 

@synthesize image=_image;

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();

	//CGContextSetInterpolationQuality(drawContext, kCGInterpolationNone);
	//CGContextSetShouldAntialias(drawContext, NO);
  if (_image != NULL)
    CGContextDrawImage(context, self.bounds, _image);

}

@end
                   

