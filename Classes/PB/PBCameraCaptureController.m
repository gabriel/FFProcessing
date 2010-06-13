//
//  PBCameraCaptureController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBCameraCaptureController.h"
#import "FFUtils.h"
#import "FFAVCaptureSessionReader.h"
#import "FFGLDrawable.h"

@implementation PBCameraCaptureController

- (void)dealloc {
  [_playerView release];
  [super dealloc];
}

- (void)loadView {
  if (!_playerView)
    _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];  
  self.view = _playerView;
}

- (void)setFilter:(id<FFFilter>)filter {
  NSAssert(![_playerView isAnimating], @"Can't set filter while animating");
  self.view;
  FFAVCaptureSessionReader *reader = [[FFAVCaptureSessionReader alloc] init];
  FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithReader:reader filter:filter];
  _playerView.drawable = drawable;
  [drawable release];
  [reader release];  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_playerView startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_playerView stopAnimation];
}

@end
