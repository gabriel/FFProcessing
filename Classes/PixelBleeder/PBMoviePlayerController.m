//
//  PBMoviePlayerController.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/31/10.
//  Copyright 2010. All rights reserved.
//

#import "PBMoviePlayerController.h"


@implementation PBMoviePlayerController

- (id)initWithContentURL:(NSURL *)URL {
  if ((self = [self init])) {
    _moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:URL];
    _moviePlayerController.scalingMode = MPMovieScalingModeAspectFill;
    //_moviePlayerController.movieControlMode = MPMovieControlModeHidden;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackDidFinishNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_moviePlayerController release];
  [super dealloc];
}

- (void)moviePlayerPlaybackDidFinishNotification:(NSNotification *)notification {
  
}

- (void)play {
  [_moviePlayerController play];
}

@end
