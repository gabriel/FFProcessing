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

@interface FFEncoder : NSObject {

  AVFormatContext *_formatContext;
  AVStream *_videoStream;
  AVStream *_audioStream;
  
  FFOptions *_options;
  FFConverter *_converter;
  NSString *_path;
  NSString *_format;
  NSString *_codecName;
  
  uint8_t *_videoBuffer;
  int _videoBufferSize;
  int _frameBytesEncoded;
  
  NSUInteger _currentVideoFrameIndex;
  
}

@property (readonly, nonatomic) NSUInteger currentVideoFrameIndex;

- (id)initWithOptions:(FFOptions *)options path:(NSString *)path format:(NSString *)format codecName:(NSString *)codecName;

- (AVCodecContext *)videoCodecContext;

- (BOOL)open:(NSError **)error;

- (BOOL)writeHeader:(NSError **)error;

- (BOOL)writeTrailer:(NSError **)error;

/*!
 Encode frame to video buffer.
 */
- (int)encodeVideoFrame:(AVFrame *)picture error:(NSError **)error;

/*!
 Write current video buffer.
 */
- (BOOL)writeVideoBuffer:(NSError **)error;

/*!
 Write video frame.
 Encodes and writes the buffer.
 
 This is the equivalent of calling both encodeVideoFrame:error: and writeVideoBuffer:.
 */
- (BOOL)writeVideoFrame:(AVFrame *)picture error:(NSError **)error;

- (void)close;

@end
