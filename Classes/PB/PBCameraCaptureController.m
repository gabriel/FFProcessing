//
//  PBCameraCaptureController.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "PBCameraCaptureController.h"
#import "FFUtils.h"
#import "FFGLDrawable.h"
#import "FFAVCaptureSessionReader.h"

@interface PBCameraCaptureController ()
- (void)_reload;
@end

@implementation PBCameraCaptureController

@synthesize delegate=_delegate;

- (void)dealloc {
  [_playerView release];
  [_filter release];
  [super dealloc];
}

- (void)loadView {
  if (!_playerView) {
    _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];  
    _playerView.delegate = self;
  }
  FFDebug(@"Setting player view");
  self.view = _playerView;
  [self _reload];
}

- (void)_reload {
  FFAVCaptureSessionReader *reader = [[FFAVCaptureSessionReader alloc] init];
  reader.sessionPreset = AVCaptureSessionPresetLow;
  FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithReader:reader filter:_filter];
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

- (void)setFilter:(id<FFFilter>)filter {
  [self view];  
  [(FFGLDrawable *)_playerView.drawable setFilter:filter];
}

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions {
  [self view];
  [(FFGLDrawable *)_playerView.drawable setImagingOptions:imagingOptions];
}

- (void)playerViewDidTouch:(FFPlayerView *)playerView {
  [_delegate cameraCaptureControllerDidTouch:self];
}

@end
