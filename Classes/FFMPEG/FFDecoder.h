//
//  FFDecoder.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

@interface FFDecoder : NSObject {
  AVFormatContext *_formatContext;

  AVStream *_videoStream;
  
  BOOL _open;
}

@property (readonly, nonatomic, getter=isOpen) BOOL open;

- (int)videoWidth;
- (int)videoHeight;
- (enum PixelFormat)videoPixelFormat;

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error;

- (BOOL)readFrame:(AVFrame *)frame error:(NSError **)error;

- (void)close;

@end
