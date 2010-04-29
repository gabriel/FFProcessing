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

@synthesize path=_path, format=_format, codecName=_codecName, presets=_presets,
width=_width, height=_height, pixelFormat=_pixelFormat, videoTimeBase=_videoTimeBase, 
sampleAspectRatio=_sampleAspectRatio;

- (id)initWithPath:(NSString *)path format:(NSString *)format codecName:(NSString *)codecName
             width:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat 
     videoTimeBase:(AVRational)videoTimeBase {
  
  if ((self = [self init])) {
    _path = [path retain];
    _format = [format retain];
    _codecName = [codecName retain];
    if (_codecName)
      _presets = [[FFPresets alloc] initWithCodeName:_codecName];
    _width = width;
    _height = height;
    _pixelFormat = pixelFormat;
    _videoTimeBase = videoTimeBase;
    if (_height > 0)
      _sampleAspectRatio = FFFindRationalApproximation((float)_width/(float)_height, 255);
  }
  return self;
}  

- (void)dealloc {
  [_presets release];
  [_path release];
  [_format release];
  [_codecName release];
  [super dealloc];
}

- (void)apply:(AVCodecContext *)codecContext {  
  [_presets apply:codecContext];
  codecContext->width = _width;
  codecContext->height = _height;
  codecContext->pix_fmt = _pixelFormat;
  codecContext->time_base = _videoTimeBase;    
  codecContext->sample_aspect_ratio = _sampleAspectRatio;
}

@end