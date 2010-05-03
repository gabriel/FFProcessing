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

@synthesize path=_path, format=_format, codecName=_codecName, presets=_presets, pictureFormat=_pictureFormat,
videoTimeBase=_videoTimeBase, sampleAspectRatio=_sampleAspectRatio;

- (id)initWithPath:(NSString *)path format:(NSString *)format codecName:(NSString *)codecName
     pictureFormat:(FFPictureFormat)pictureFormat videoTimeBase:(AVRational)videoTimeBase {
  
  if ((self = [self init])) {
    _path = [path retain];
    _format = [format retain];
    _codecName = [codecName retain];
    if (_codecName)
      _presets = [[FFPresets alloc] initWithCodeName:_codecName];
    _pictureFormat = pictureFormat;
    _videoTimeBase = videoTimeBase;
    if (_pictureFormat.height > 0)
      _sampleAspectRatio = FFFindRationalApproximation((float)_pictureFormat.width/(float)_pictureFormat.height, 255);
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
  codecContext->width = _pictureFormat.width;
  codecContext->height = _pictureFormat.height;
  codecContext->pix_fmt = _pictureFormat.pixelFormat;
  codecContext->time_base = _videoTimeBase;    
  codecContext->sample_aspect_ratio = _sampleAspectRatio;
}

@end