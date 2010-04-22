//
//  PBApplicationController.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBUITableViewController.h"

#import "PBMediaListViewController.h"
#import "PBMoviePlayerController.h"
#import "PBProcessing.h"

@interface PBApplicationController : PBUITableViewController <PBProcessingDelegate> {

  PBMediaListViewController *_mediaListViewController;
  PBMoviePlayerController *_moviePlayerController;  
  PBProcessing *_processing;
  
  NSURL *_sourceURL;
}

@property (retain, nonatomic) NSURL *sourceURL;



@end
