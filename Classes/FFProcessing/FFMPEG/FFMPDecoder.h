//
//  FFMPDecoder.h
//  FFMP
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

#import "FFDecoder.h"
#import "FFDecoderOptions.h"

@interface FFMPDecoder : NSObject <FFDecoder> {
  AVFormatContext *_formatContext;

  AVStream *_videoStream;
  
  AVFrame *_avFrame; // Decoded AVFrame
  
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
- (BOOL)readAVPacket:(AVPacket *)packet error:(NSError **)error;

/*!
 Decode packet into AVFrame.
 @param frame If decoded, picture is set
 @param packet Packet to decode
 @param error Out error
 @result YES if decoded
 */
- (BOOL)decodeAVFrame:(AVFrame *)frame packet:(AVPacket *)packet error:(NSError **)error;

/*!
 Read packet and decode into AVFrame.
 @param frame If decoded, picture is set
 @param error Out error
 @result YES if decoded
 */
- (BOOL)decodeAVFrame:(AVFrame *)frame error:(NSError **)error;

/*!
 Decode frame.
 @param frame
 @param error
 */
- (BOOL)decodeFrame:(FFVFrameRef)frame error:(NSError **)error;

//! Duration of video stream
- (int64_t)videoDuration;

/*!
 Close decoder.
 */
- (void)close;

@end
