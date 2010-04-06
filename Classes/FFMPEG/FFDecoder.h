//
//  FFDecoder.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

#import "FFOptions.h"

@interface FFDecoder : NSObject {
  AVFormatContext *_formatContext;

  AVStream *_videoStream;
  
  FFOptions *_options;
  
  BOOL _open;
}

@property (readonly, nonatomic, getter=isOpen) BOOL open;
@property (readonly, nonatomic) FFOptions *options;

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

/*!
 Close decoder.
 */
- (void)close;

@end
