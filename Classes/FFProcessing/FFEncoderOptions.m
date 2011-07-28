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

@synthesize path=_path, formatName=_formatName, codecName=_codecName, format=_format,
videoTimeBase=_videoTimeBase, sampleAspectRatio=_sampleAspectRatio;

- (id)initWithPath:(NSString *)path formatName:(NSString *)formatName codecName:(NSString *)codecName
            format:(FFVFormat)format videoTimeBase:(FFRational)videoTimeBase {
  
  if ((self = [self init])) {
    _path = [path retain];
    _formatName = [formatName retain];
    _codecName = [codecName retain];
    _format = format;
    _videoTimeBase = videoTimeBase;
    if (_format.height > 0)
      _sampleAspectRatio = FFFindRationalApproximation((float)_format.width/(float)_format.height, 255);
  }
  return self;
}  

- (void)dealloc {
  [_path release];
  [_formatName release];
  [_codecName release];
  [super dealloc];
}

@end