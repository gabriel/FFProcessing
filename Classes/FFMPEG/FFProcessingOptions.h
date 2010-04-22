//
//  FFProcessingOptions.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/17/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncoderOptions.h"

@interface FFProcessingOptions : NSObject {
  
  FFEncoderOptions *_encoderOptions;
  
  NSInteger _skipEveryIFrameInterval;
  NSInteger _smoothFrameInterval;
  NSInteger _smoothFrameRepeat;  
}

@property (retain, nonatomic) FFEncoderOptions *encoderOptions;
@property (assign, nonatomic) NSInteger skipEveryIFrameInterval; // How often to skip I-frames: 0=off, 1=every, 2=every other, 3=every third, ...
@property (assign, nonatomic) NSInteger smoothFrameInterval; // How often to duplicate P-frames: 0=off, 1=every, 2=every other, ...
@property (assign, nonatomic) NSInteger smoothFrameRepeat; // When smoothing a frame, how many frames to repeat

@end
