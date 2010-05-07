//
//  PBCameraPickerCaptureController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/6/10.
//  Copyright 2010. All rights reserved.
//

#import "PBImagePickerController.h"

@class PBCameraOverlayView;

@interface PBCameraPickerCaptureController : PBImagePickerController {
  NSTimer *_processingTimer;
  
  PBCameraOverlayView *_overlayView;
  CGImageRef _image;
}

@end

@interface PBCameraOverlayView : UIView {
  CGImageRef _image;
}

@property (assign, nonatomic) CGImageRef image;

@end
