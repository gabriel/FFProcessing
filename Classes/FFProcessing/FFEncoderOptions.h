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
  NSString *_format;
  NSString *_codecName;  
  
  FFAVFormat _avFormat;
  AVRational _videoTimeBase;
  AVRational _sampleAspectRatio;
}

@property (readonly, nonatomic) FFPresets *presets;
@property (readonly, nonatomic) NSString *path;
@property (readonly, nonatomic) NSString *format;
@property (readonly, nonatomic) NSString *codecName;  
@property (readonly, nonatomic) FFAVFormat avFormat;
@property (readonly, nonatomic) AVRational videoTimeBase;
@property (readonly, nonatomic) AVRational sampleAspectRatio;


- (id)initWithPath:(NSString *)path format:(NSString *)format codecName:(NSString *)codecName
     avFormat:(FFAVFormat)avFormat videoTimeBase:(AVRational)videoTimeBase;

- (void)apply:(AVCodecContext *)codecContext;

@end