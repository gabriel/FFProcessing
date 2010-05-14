//
//  FFEncoderOptions.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/17/10.
//  Copyright 2010. All rights reserved.
//

#import "FFEncoderOptions.h"
#import "FFUtils.h"

@implementation FFEncoderOptions

@synthesize path=_path, formatName=_formatName, codecName=_codecName, presets=_presets, format=_format,
videoTimeBase=_videoTimeBase, sampleAspectRatio=_sampleAspectRatio;

- (id)initWithPath:(NSString *)path formatName:(NSString *)formatName codecName:(NSString *)codecName
            format:(FFVFormat)format videoTimeBase:(AVRational)videoTimeBase {
  
  if ((self = [self init])) {
    _path = [path retain];
    _formatName = [formatName retain];
    _codecName = [codecName retain];
    if (_codecName)
      _presets = [[FFPresets alloc] initWithCodeName:_codecName];
    _format = format;
    _videoTimeBase = videoTimeBase;
    if (_format.height > 0)
      _sampleAspectRatio = FFFindRationalApproximation((float)_format.width/(float)_format.height, 255);
  }
  return self;
}  

- (void)dealloc {
  [_presets release];
  [_path release];
  [_formatName release];
  [_codecName release];
  [super dealloc];
}

- (void)apply:(AVCodecContext *)codecContext {  
  [_presets apply:codecContext];
  codecContext->width = _format.width;
  codecContext->height = _format.height;
  codecContext->pix_fmt = _format.pixelFormat;
  codecContext->time_base = _videoTimeBase;    
  codecContext->sample_aspect_ratio = _sampleAspectRatio;
}

@end