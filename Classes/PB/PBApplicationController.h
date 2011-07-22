//
//  PBApplicationController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/21/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIMultiViewController.h"
#import "PBCameraCaptureController.h"
#import "PBUIModeNavigationView.h"

@interface PBApplicationController : YKUIMultiViewController <PBOptionsDelegate, PBCameraCaptureControllerDelegate> {
  PBCameraCaptureController *_cameraCaptureController;
  
  PBUIModeNavigationView *_modeNavigationView;
}

@end
