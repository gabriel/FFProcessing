//
//  PBCameraCaptureController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBCameraCaptureController.h"
#import "FFUtils.h"
#import "FFCannyEdgeFilter.h"

@implementation PBCameraCaptureController

- (void)dealloc {
  [_reader release];
  [_playerView release];
  [super dealloc];
}

- (void)loadView {
  _reader = [[FFAVCaptureSessionReader alloc] init];
  id<FFFilter> filter = [[[FFCannyEdgeFilter alloc] init] autorelease];
  _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) reader:_reader filter:filter];
  self.view = _playerView;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_playerView start];
  [_reader start:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_reader stop];
  [_playerView stop];
}

@end
