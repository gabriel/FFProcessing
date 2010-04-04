//
//  FFReader.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReader.h"

#import "FFUtils.h"

@implementation FFReader

@synthesize converter=_converter;

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
  FFPictureRelease(_picture);
  [super dealloc];
}

- (AVFrame *)nextFrame:(NSError **)error {  
  if (!_started) {
    _started = YES;    
    [_readThread start];
  }
    
  if (_picture == NULL) {
    _picture = [_readThread createPicture];
    if (_picture == NULL) return NULL;
  }
  
  if (![_readThread readPicture:_picture]) return NULL;
  
  if (!_converter) {
    _converter = [[FFConverter alloc] initWithInputOptions:[_readThread.decoder options]
                                             outputOptions:[FFOptions optionsWithWidth:256 height:256 pixelFormat:PIX_FMT_RGB24]];    
  }

  return [_converter scalePicture:_picture error:error];
}

@end
