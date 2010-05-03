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
  FFPictureFrameRelease(_pictureFrame);
  [super dealloc];
}

- (FFPictureFrame)nextFrame:(NSError **)error {  
  if (!_started) {
    _started = YES;    
    [_readThread start];
  }
    
  if (_pictureFrame.frame == NULL) {
    _pictureFrame = [_readThread createPictureFrame];
    if (_pictureFrame.frame == NULL) return _pictureFrame;
  }
  
  if (![_readThread readPicture:_pictureFrame.frame]) return _pictureFrame;
  
  if (!_converter) {    
    FFEncoderOptions *encoderOptions = [[[FFEncoderOptions alloc] initWithPath:nil format:nil codecName:nil
                                                                 pictureFormat:FFPictureFormatMake(256, 256, PIX_FMT_RGB24)
                                                                 videoTimeBase:(AVRational){0, 1}] autorelease];
    
    _converter = [[FFConverter alloc] initWithPictureFormat:encoderOptions.pictureFormat];    
  }

  return [_converter scalePicture:_pictureFrame error:error];
}

@end
