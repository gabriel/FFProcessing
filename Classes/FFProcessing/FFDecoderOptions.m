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

@synthesize avFormat=_avFormat, videoFrameRate=_videoFrameRate, videoTimeBase=_videoTimeBase,
sampleAspectRatio=_sampleAspectRatio;

- (id)initWithAVFormat:(FFAVFormat)avFormat videoFrameRate:(AVRational)videoFrameRate 
              videoTimeBase:(AVRational)videoTimeBase {
  
  if ((self = [super init])) {
    _avFormat = avFormat;
    _videoFrameRate = videoFrameRate;
    _videoTimeBase = videoTimeBase;
    _sampleAspectRatio = FFFindRationalApproximation((float)_avFormat.width/(float)_avFormat.height, 255);
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"width=%d, height=%d, pixelFormat=%d, videoFrameRate=%d/%d, videoTimeBase=%d/%d, sampleAspectRatio=%d/%d",
          _avFormat.width, _avFormat.height, _avFormat.pixelFormat, 
          _videoFrameRate.num, _videoFrameRate.den, _videoTimeBase.num, _videoTimeBase.den,
          _sampleAspectRatio.num, _sampleAspectRatio.den];
}

@end



