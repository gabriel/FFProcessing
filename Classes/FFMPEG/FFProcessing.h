//
//  FFProcessing.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"
#import "FFEncoder.h"

@interface FFProcessing : NSObject {
  
  NSString *_outputPath;
  NSString *_outputFormat;
  NSString *_outputCodecName;
  
  FFDecoder *_decoder;
  AVFrame *_decoderFrame;
  
  FFEncoder *_encoder;
  
  int64_t _previousPTS;
  int64_t _previousEndPTS;

  NSInteger _IFrameIndex;
  NSInteger _PFrameIndex;
  NSInteger _GOPIndex;

  
  // Processing options
  NSInteger _skipEveryIFrameInterval;
  NSInteger _smoothFrameInterval;
  NSInteger _smoothFrameRepeat;
}

@property (assign, nonatomic) NSInteger skipEveryIFrameInterval; // How often to skip I-frames: 0=off, 1=every, 2=every other, 3=every third, ...
@property (assign, nonatomic) NSInteger smoothFrameInterval; // How often to duplicate P-frames: 0=off, 1=every, 2=every other, ...
@property (assign, nonatomic) NSInteger smoothFrameRepeat; // When smoothing a frame, how many frames to repeat

@property (readonly, nonatomic) NSString *outputPath;

- (id)initWithOutputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat 
         outputCodecName:(NSString *)outputCodecName;

- (BOOL)processURL:(NSURL *)URL format:(NSString *)format index:(NSInteger)index count:(NSInteger)count error:(NSError **)error;

- (void)close;

@end
