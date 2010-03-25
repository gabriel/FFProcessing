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

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error;

- (int)videoWidth;
- (int)videoHeight;
- (enum PixelFormat)videoPixelFormat;

/*!
 Read packet.
 @param packet If read, packet is set
 @param error Out error
 @result YES if read
 */
- (BOOL)readFrame:(AVPacket *)packet error:(NSError **)error;

/*!
 Decode packet into frame.
 @param frame If decoded, frame is set
 @param packet Packet to decode
 @param error Out error
 @result YES if decoded
 */
- (BOOL)decodeFrame:(AVFrame *)frame packet:(AVPacket *)packet error:(NSError **)error;

/*!
 Read packet and decode into frame.
 @param frame If decoded, frame is set
 @param error Out error
 @result YES if decoded
 */
- (BOOL)decodeFrame:(AVFrame *)frame error:(NSError **)error;

/*!
 Close decoder.
 */
- (void)close;

@end
