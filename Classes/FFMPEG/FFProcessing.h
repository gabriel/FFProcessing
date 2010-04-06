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
  FFDecoder *_decoder;
  AVFrame *_decoderFrame;
  
  FFEncoder *_encoder;
  
  int64_t _previousPTS;
  
  int _IFrameInterval;
  int _smoothInterval;
  int _smoothIterations;
}

@property (assign, nonatomic) int IFrameInterval;
@property (assign, nonatomic) int smoothInterval;
@property (assign, nonatomic) int smoothIterations;


- (BOOL)openURL:(NSURL *)URL format:(NSString *)format outputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat 
outputCodecName:(NSString *)outputCodecName error:(NSError **)error;

- (BOOL)process:(NSError **)error;

- (void)close;

@end
