//
//  FFDecoderOptions.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoderOptions.h"
#import "FFUtils.h"
#import "FFMPUtils.h"

@implementation FFDecoderOptions

@synthesize format=_format, videoFrameRate=_videoFrameRate, videoTimeBase=_videoTimeBase,
sampleAspectRatio=_sampleAspectRatio;

- (id)initWithFormat:(FFVFormat)format videoFrameRate:(FFRational)videoFrameRate 
       videoTimeBase:(FFRational)videoTimeBase {
  
  if ((self = [super init])) {
    _format = format;
    _videoFrameRate = videoFrameRate;
    _videoTimeBase = videoTimeBase;
    _sampleAspectRatio = FFFindRationalApproximation((float)_format.width/(float)_format.height, 255);
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"width=%d, height=%d, pixelFormat=%d, videoFrameRate=%d/%d, videoTimeBase=%d/%d, sampleAspectRatio=%d/%d",
          _format.width, _format.height, _format.pixelFormat, 
          _videoFrameRate.num, _videoFrameRate.den, _videoTimeBase.num, _videoTimeBase.den,
          _sampleAspectRatio.num, _sampleAspectRatio.den];
}

@end



