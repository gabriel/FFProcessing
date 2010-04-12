//
//  FFOptions.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFOptions.h"
#import "FFUtils.h"

@implementation FFOptions

@synthesize width=_width, height=_height, pixelFormat=_pixelFormat, videoFrameRate=_videoFrameRate, videoTimeBase=_videoTimeBase,
sampleAspectRatio=_sampleAspectRatio;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat {
  if ((self = [super init])) {
    _width = width;
    _height = height;
    _pixelFormat = pixelFormat;
    _videoFrameRate = (AVRational){0, 0};
    _videoTimeBase = (AVRational){0, 0};
    _sampleAspectRatio = FFFindRationalApproximation((float)_width/(float)_height, 255);
  }
  return self;
}

+ (FFOptions *)optionsWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat {
  return [[[self alloc] initWithWidth:width height:height pixelFormat:pixelFormat] autorelease];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"width=%d, height=%d, pixelFormat=%d, videoFrameRate=%d/%d, videoTimeBase=%d/%d, sampleAspectRatio=%d/%d",
          _width, _height, _pixelFormat, _videoFrameRate.num, _videoFrameRate.den, _videoTimeBase.num, _videoTimeBase.den,
          _sampleAspectRatio.num, _sampleAspectRatio.den];
}

- (void)apply:(AVCodecContext *)codecContext {  
  codecContext->width = _width;
  codecContext->height = _height;
  codecContext->pix_fmt = _pixelFormat;
  codecContext->time_base = _videoTimeBase;    
  codecContext->sample_aspect_ratio = _sampleAspectRatio;
}

@end
