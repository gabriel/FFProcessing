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
  FFVFrameRelease(_frame);  
}

- (FFVFrameRef)nextFrame:(NSError **)error {  
  if (!_started) {
    _started = YES;    
    [_readThread start];
  }
    
  if (_frame == NULL) {
    _frame = FFVFrameCreate([_readThread format]);
    if (_frame == NULL) return NULL;
  }
  
  if (![_readThread readFrame:_frame]) return _frame;
  
  return _frame;
}

@end
