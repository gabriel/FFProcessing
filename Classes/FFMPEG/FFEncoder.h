//
//  FFEncoder.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

#import "FFOptions.h"
#import "FFConverter.h"
#import "FFPresets.h"

@interface FFEncoder : NSObject {

  AVFormatContext *_formatContext;
  AVStream *_videoStream;
  AVStream *_audioStream;
  
  FFOptions *_options;
  FFPresets *_presets;
  FFConverter *_converter;
  NSString *_path;
  NSString *_format;
  NSString *_codecName;
  
  uint8_t *_videoBuffer;
  int _videoBufferSize;
  int _frameBytesEncoded;
  
  int64_t _currentPTS;
}

- (id)initWithOptions:(FFOptions *)options presets:(FFPresets *)presets path:(NSString *)path format:(NSString *)format codecName:(NSString *)codecName;

- (BOOL)open:(NSError **)error;

- (BOOL)writeHeader:(NSError **)error;

- (BOOL)writeTrailer:(NSError **)error;

/*!
 Encode frame to video buffer.
 */
- (int)encodeVideoFrame:(AVFrame *)picture error:(NSError **)error;

- (AVFrame *)codedFrame;

/*!
 Write current video buffer.
 */
- (BOOL)writeVideoBuffer:(NSError **)error;

- (void)close;

@end
