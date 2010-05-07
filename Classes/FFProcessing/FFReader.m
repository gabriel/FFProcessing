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
  [_readThread close];
  [_readThread release];
  [_converter release];
  FFAVFrameRelease(_avFrame);
  [super dealloc];
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
  
  if (!_converter) {    
    FFEncoderOptions *encoderOptions = [[[FFEncoderOptions alloc] initWithPath:nil format:nil codecName:nil
                                                                 avFormat:FFAVFormatMake(256, 256, PIX_FMT_RGB24)
                                                                 videoTimeBase:(AVRational){0, 1}] autorelease];
    
    _converter = [[FFConverter alloc] initWithAVFormat:encoderOptions.avFormat];    
  }

  return [_converter scalePicture:_avFrame error:error];
}

@end
