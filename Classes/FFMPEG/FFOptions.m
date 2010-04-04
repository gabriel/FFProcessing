//
//  FFOptions.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFOptions.h"


@implementation FFOptions

@synthesize width=_width, height=_height, pixelFormat=_pixelFormat, videoFrameRate=_videoFrameRate, presets=_presets;

- (id)init {
  return [self initWithWidth:480 height:360 pixelFormat:PIX_FMT_YUV420P];
}

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat {
  if ((self = [super init])) {
    _width = width;
    _height = height;
    _pixelFormat = pixelFormat;
    _videoFrameRate = (AVRational){0, 0};
  }
  return self;
}

- (void)dealloc {
  [_presets release];
  [super dealloc];
}

+ (FFOptions *)optionsWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat {
  return [[[self alloc] initWithWidth:width height:height pixelFormat:pixelFormat] autorelease];
}

// iPod options
- (void)apply:(AVCodecContext *)codecContext {
  
  [_presets apply:codecContext];
  
  codecContext->width = _width;
  codecContext->height = _height;
  codecContext->pix_fmt = _pixelFormat;
  
  if (_videoFrameRate.num != 0 && _videoFrameRate.den != 0) {
    codecContext->time_base.den = _videoFrameRate.num;
    codecContext->time_base.num = _videoFrameRate.den;
  }
}

@end
