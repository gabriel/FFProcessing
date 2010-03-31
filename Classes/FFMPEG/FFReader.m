//
//  FFReader.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReader.h"
#import "FFDefines.h"
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
    _converter = [[FFConverter alloc] initWithSourceWidth:[_readThread.decoder width]
                                             sourceHeight:[_readThread.decoder height]
                                        sourcePixelFormat:[_readThread.decoder pixelFormat]
                                                destWidth:256
                                               destHeight:256
                                          destPixelFormat:PIX_FMT_RGB24
                                                    error:nil]; // TODO(gabe): Handle error

  }

  return [_converter scalePicture:_picture error:error];
}

@end
