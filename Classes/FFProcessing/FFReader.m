//
//  FFReader.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReader.h"

#import "FFUtils.h"
#import "FFEncoderOptions.h"

@implementation FFReader

- (id)initWithURL:(NSURL *)URL format:(NSString *)format {
  if ((self = [self init])) {
    _readThread = [[FFReadThread alloc] initWithURL:URL format:format];
  }
  return self;
}

- (void)dealloc {
  [self close];
  [super dealloc];
}

- (void)close {
  [_readThread close];
  [_readThread release];
  _readThread = nil;
  [_converter release];
  _converter = nil;
  FFAVFrameRelease(_avFrame);  
  _avFrame = FFAVFrameNone;
}

- (FFAVFrame)nextFrame:(NSError **)error {  
  if (!_started) {
    _started = YES;    
    [_readThread start];
  }
    
  if (_avFrame.frame == NULL) {
    _avFrame = [_readThread createPictureFrame];
    if (_avFrame.frame == NULL) return _avFrame;
  }
  
  if (![_readThread readPicture:_avFrame.frame]) return _avFrame;
  
  if (!_converter)
    _converter = [[FFConverter alloc] initWithAVFormat:FFAVFormatMake(256, 256, PIX_FMT_RGB24)];

  return [_converter scalePicture:_avFrame error:error];
}

@end
