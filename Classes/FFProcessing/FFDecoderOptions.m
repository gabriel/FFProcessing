//
//  FFDecoderOptions.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoderOptions.h"
#import "FFUtils.h"

@implementation FFDecoderOptions

@synthesize width=_width, height=_height, pixelFormat=_pixelFormat, videoFrameRate=_videoFrameRate, videoTimeBase=_videoTimeBase,
sampleAspectRatio=_sampleAspectRatio;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat videoFrameRate:(AVRational)videoFrameRate
      videoTimeBase:(AVRational)videoTimeBase {
  if ((self = [super init])) {
    _width = width;
    _height = height;
    _pixelFormat = pixelFormat;
    _videoFrameRate = videoFrameRate;
    _videoTimeBase = videoTimeBase;
    _sampleAspectRatio = FFFindRationalApproximation((float)_width/(float)_height, 255);
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"width=%d, height=%d, pixelFormat=%d, videoFrameRate=%d/%d, videoTimeBase=%d/%d, sampleAspectRatio=%d/%d",
          _width, _height, _pixelFormat, _videoFrameRate.num, _videoFrameRate.den, _videoTimeBase.num, _videoTimeBase.den,
          _sampleAspectRatio.num, _sampleAspectRatio.den];
}

@end



