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

  int _smoothInterval;
  int _smoothIterations;
  
  int64_t _IFrameIndex;
  int64_t _PFrameIndex;

}

@property (assign, nonatomic) int smoothInterval;
@property (assign, nonatomic) int smoothIterations;

@property (readonly, nonatomic) NSString *outputPath;

- (id)initWithOutputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat 
         outputCodecName:(NSString *)outputCodecName;

- (BOOL)processURL:(NSURL *)URL format:(NSString *)format index:(NSInteger)index count:(NSInteger)count error:(NSError **)error;

- (void)close;

@end
