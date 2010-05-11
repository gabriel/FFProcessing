//
//  PBCameraCaptureController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBCameraCaptureController.h"
#import "FFUtils.h"

@implementation PBCameraCaptureController

@synthesize filter=_filter;

- (void)dealloc {
  [_reader release];
  [_playerView release];
  [_filter release];
  [super dealloc];
}

- (void)loadView {
  _reader = [[FFAVCaptureSessionReader alloc] init];
  _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) reader:_reader filter:_filter];
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
