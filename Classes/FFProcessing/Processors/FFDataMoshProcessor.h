//
//  FFDataMoshProcessor.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncodeProcessor.h"


@interface FFDataMoshProcessor : FFEncodeProcessor {
  
  NSInteger _skipEveryIFrameInterval;
  NSInteger _smoothFrameInterval;
  NSInteger _smoothFrameRepeat; 
  
  // Stats
  NSInteger _IFrameIndex;
  NSInteger _PFrameIndex;
  NSInteger _GOPIndex;
  int64_t _previousPTS;

}

@property (assign, nonatomic) NSInteger skipEveryIFrameInterval; // How often to skip I-frames: 0=off, 1=every, 2=every other, 3=every third, ...
@property (assign, nonatomic) NSInteger smoothFrameInterval; // How often to duplicate P-frames: 0=off, 1=every, 2=every other, ...
@property (assign, nonatomic) NSInteger smoothFrameRepeat; // When smoothing a frame, how many frames to repeat

@end
