//
//  PBApplicationController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/21/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIMultiViewController.h"
#import "PBCameraCaptureController.h"
#import "PBUIOptionsView.h"

@interface PBApplicationController : YKUIMultiViewController <PBOptionsDelegate, PBCameraCaptureControllerDelegate> {
  PBCameraCaptureController *_cameraCaptureController;
  
  PBUIOptionsView *_optionsView;
}

@end
