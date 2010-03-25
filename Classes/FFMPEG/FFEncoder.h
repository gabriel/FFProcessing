//
//  FFEncoder.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

@interface FFEncoder : NSObject {

  AVFormatContext *_formatContext;
  AVStream *_videoStream;
  AVStream *_audioStream;
  
  int _width;
  int _height;
  enum PixelFormat _pixelFormat;
  
  AVFrame *_picture;
  
  uint8_t *_videoBuffer;
  NSInteger _videoBufferSize;
  
  NSUInteger _currentVideoFrameIndex;
  
}

- (BOOL)open:(NSString *)path error:(NSError **)error;

- (void)writeFrames:(NSError **)error;

- (void)close;

@end
