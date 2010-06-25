//
//  PBTestApplicationController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUITableViewController.h"

#import "PBMediaListViewController.h"
#import "PBMoviePlayerController.h"
#import "PBCameraCaptureController.h"
#import "PBProcessing.h"
#import "PBSaveThread.h"

@interface PBTestApplicationController : PBUITableViewController <PBProcessingDelegate, PBSaveThreadDelegate> {

  PBMediaListViewController *_mediaListViewController;
  PBMoviePlayerController *_moviePlayerController;  
  PBProcessing *_processing;
  
  PBCameraCaptureController *_cameraCaptureController;
  
  NSURL *_sourceURL;
}

@property (retain, nonatomic) NSURL *sourceURL;



@end
