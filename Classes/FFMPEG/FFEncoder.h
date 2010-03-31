//
//  FFEncoder.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
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
  int _videoBitRate;
  
  uint8_t *_videoBuffer;
  NSInteger _videoBufferSize;
  
  NSUInteger _currentVideoFrameIndex;
  
}

@property (readonly, nonatomic) NSUInteger currentVideoFrameIndex;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat videoBitRate:(int)videoBitRate;

- (AVCodecContext *)videoCodecContext;

- (BOOL)open:(NSString *)path error:(NSError **)error;

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
