//
//  FFOptions.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFOptions.h"


@implementation FFOptions

@synthesize width=_width, height=_height, pixelFormat=_pixelFormat, videoFrameRate=_videoFrameRate, videoTimeBase=_videoTimeBase;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat {
  if ((self = [super init])) {
    _width = width;
    _height = height;
    _pixelFormat = pixelFormat;
    _videoFrameRate = (AVRational){0, 0};
    _videoTimeBase = (AVRational){0, 0};
  }
  return self;
}

+ (FFOptions *)optionsWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat {
  return [[[self alloc] initWithWidth:width height:height pixelFormat:pixelFormat] autorelease];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"width=%d, height=%d, pixelFormat=%d, videoFrameRate=%d/%d, videoTimeBase=%d/%d",
          _width, _height, _pixelFormat, _videoFrameRate.num, _videoFrameRate.den, _videoTimeBase.num, _videoTimeBase.den];
}

- (void)apply:(AVCodecContext *)codecContext {
  
  codecContext->width = _width;
  codecContext->height = _height;
  codecContext->pix_fmt = _pixelFormat;
  
  /*!
  if (_videoFrameRate.num != 0 && _videoFrameRate.den != 0) {
    codecContext->time_base.den = _videoFrameRate.num;
    codecContext->time_base.num = _videoFrameRate.den;
  }
   */
  codecContext->time_base = _videoTimeBase;
}

@end
