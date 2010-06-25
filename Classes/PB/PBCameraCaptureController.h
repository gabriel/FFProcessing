//
//  PBCameraCaptureController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerView.h"
#import "FFFilter.h"
#import "YKUIViewController.h"
#import "FFGLImaging.h"

@class PBCameraCaptureController;

@protocol PBCameraCaptureControllerDelegate <NSObject>
- (void)cameraCaptureControllerDidTouch:(PBCameraCaptureController *)cameraCaptureController;
@end

@interface PBCameraCaptureController : YKUIViewController <FFPlayerViewDelegate> {
  FFPlayerView *_playerView;
  id<FFFilter> _filter;
  
  id<PBCameraCaptureControllerDelegate> _delegate;
}

@property (assign, nonatomic) id<PBCameraCaptureControllerDelegate> delegate;

- (void)setFilter:(id<FFFilter>)filter;

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions;

@end
