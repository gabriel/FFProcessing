//
//  FFEncoder.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

#import "FFEncoderOptions.h"
#import "FFConverter.h"
#import "FFPresets.h"

@interface FFEncoder : NSObject {

  AVFormatContext *_formatContext;
  AVStream *_videoStream;
  AVStream *_audioStream;
  
  FFEncoderOptions *_options;
  
  uint8_t *_videoBuffer;
  int _videoBufferSize;
  int _frameBytesEncoded;
  
  int64_t _currentPTS;
}

- (id)initWithOptions:(FFEncoderOptions *)options;

- (BOOL)open:(NSError **)error;

- (BOOL)writeHeader:(NSError **)error;

- (BOOL)writeTrailer:(NSError **)error;

/*!
 Encode frame to video buffer.
 */
- (int)encodeAVFrame:(AVFrame *)picture error:(NSError **)error;

- (AVFrame *)codedFrame;

/*!
 Write current video buffer.
 */
- (BOOL)writeVideoBuffer:(NSError **)error;

- (BOOL)writeVideoFrame:(AVFrame *)picture error:(NSError **)error;

- (void)close;

@end
