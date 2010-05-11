//
//  PBCameraCaptureController.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/7/10.
//  Copyright 2010. All rights reserved.
//

#import "FFAVCaptureSessionReader.h"

#import "FFPlayerView.h"
#import "FFAVCaptureSessionReader.h"

@interface PBCameraCaptureController : UIViewController {
  FFPlayerView *_playerView;
  FFAVCaptureSessionReader *_reader;
  
  id<FFFilter> _filter;
}

@property (retain, nonatomic) id<FFFilter> filter;

@end
