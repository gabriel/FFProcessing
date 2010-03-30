//
//  FFProcessing.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessing.h"
#import "FFDefines.h"

@implementation FFProcessing

- (void)dealloc {
  [self close];
  [super dealloc];
}

- (BOOL)openURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error {
  _decoder = [[FFDecoder alloc] init];
  
  if (![_decoder openWithURL:URL format:format error:error]) {
    return NO;
  }
  
  _decoderFrame = avcodec_alloc_frame();
  return YES;
}

- (BOOL)process:(NSError **)error {
  NSAssert(_decoder, @"No decoder, open first");

  while (YES) {
    NSError *readError = nil;
    
    AVPacket packet;
    if (![_decoder readFrame:&packet error:&readError]) {
      if (readError) {
        if (error) *error = readError;
        return NO;
      }
      continue;
    }
    
    [_decoder decodeFrame:_decoderFrame packet:&packet error:error];   
    
    if (!error) {
      if (_decoderFrame->pict_type == FF_I_TYPE) {
        FFDebug(@"Packet, pts=%lld, dts=%lld", packet.pts, packet.dts);

        FFDebug(@"Frame, key_frame=%d, pict_type=%@", 
                _decoderFrame->key_frame, NSStringFromAVFramePictType(_decoderFrame->pict_type));    
      }
    }
    
    av_free_packet(&packet);
  }
}
     
- (void)close {
  if (_decoderFrame != NULL) {
    av_free(_decoderFrame);
    _decoderFrame = NULL;
  }
  [_decoder release];
  _decoder = nil;
}

@end
