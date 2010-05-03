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

@synthesize pictureFormat=_pictureFormat, videoFrameRate=_videoFrameRate, videoTimeBase=_videoTimeBase,
sampleAspectRatio=_sampleAspectRatio;

- (id)initWithPictureFormat:(FFPictureFormat)pictureFormat videoFrameRate:(AVRational)videoFrameRate 
              videoTimeBase:(AVRational)videoTimeBase {
  
  if ((self = [super init])) {
    _pictureFormat = pictureFormat;
    _videoFrameRate = videoFrameRate;
    _videoTimeBase = videoTimeBase;
    _sampleAspectRatio = FFFindRationalApproximation((float)_pictureFormat.width/(float)_pictureFormat.height, 255);
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"width=%d, height=%d, pixelFormat=%d, videoFrameRate=%d/%d, videoTimeBase=%d/%d, sampleAspectRatio=%d/%d",
          _pictureFormat.width, _pictureFormat.height, _pictureFormat.pixelFormat, 
          _videoFrameRate.num, _videoFrameRate.den, _videoTimeBase.num, _videoTimeBase.den,
          _sampleAspectRatio.num, _sampleAspectRatio.den];
}

@end



