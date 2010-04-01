//
//  PBApplicationController.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBVideoController.h"
#import "PBMoviePlayerController.h"
#import "PBProcessing.h"

@interface PBApplicationController : UITableViewController <PBVideoControllerDelegate> {
  PBVideoController *_videoController;
  PBMoviePlayerController *_moviePlayerController;  
  PBProcessing *_processing;
  
  NSURL *_sourceURL;
  NSString *_path;  
}

@property (retain, nonatomic) NSURL *sourceURL;
@property (retain, nonatomic) NSString *path;  


@end
