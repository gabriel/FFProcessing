//
//  FFDecoder.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

#import "FFDecoderOptions.h"

@interface FFDecoder : NSObject {
  AVFormatContext *_formatContext;

  AVStream *_videoStream;
  
  FFDecoderOptions *_options;
  
  BOOL _open;
  
  int64_t _readVideoPTS;
}

@property (readonly, nonatomic, getter=isOpen) BOOL open;
@property (readonly, nonatomic) FFDecoderOptions *options;
@property (readonly, nonatomic) int64_t readVideoPTS;

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error;

/*!
 Read packet.
 @param packet If read, packet is set
 @param error Out error
 @result YES if read
 */
- (BOOL)readFrame:(AVPacket *)packet error:(NSError **)error;

/*!
 Decode packet into picture.
 @param picture If decoded, picture is set
 @param packet Packet to decode
 @param error Out error
 @result YES if decoded
 */
- (BOOL)decodeVideoFrame:(AVFrame *)picture packet:(AVPacket *)packet error:(NSError **)error;

/*!
 Read packet and decode into picture.
 @param picture If decoded, picture is set
 @param error Out error
 @result YES if decoded
 */
- (BOOL)decodeVideoFrame:(AVFrame *)picture error:(NSError **)error;

//! Duration of video stream
- (int64_t)videoDuration;

/*!
 Close decoder.
 */
- (void)close;

@end
