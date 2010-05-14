//
//  FFEncoderOptions.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/17/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPresets.h"
#import "FFTypes.h"

@interface FFEncoderOptions : NSObject {
  FFPresets *_presets;
  NSString *_path;
  NSString *_formatName;
  NSString *_codecName;  
  
  FFVFormat _format;
  AVRational _videoTimeBase;
  AVRational _sampleAspectRatio;
}

@property (readonly, nonatomic) FFPresets *presets;
@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSString *formatName;
@property (readonly, nonatomic) NSString *codecName;  
@property (readonly, nonatomic) FFVFormat format;
@property (readonly, nonatomic) AVRational videoTimeBase;
@property (readonly, nonatomic) AVRational sampleAspectRatio;


- (id)initWithPath:(NSString *)path formatName:(NSString *)formatName codecName:(NSString *)codecName
     format:(FFVFormat)format videoTimeBase:(AVRational)videoTimeBase;

- (void)apply:(AVCodecContext *)codecContext;

@end