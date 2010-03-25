//
//  FFProcessing.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFProcessing.h"
#import "FFDefines.h"

@implementation FFProcessing

- (void)decodeURL:(NSURL *)URL format:(NSString *)format {
  FFDecoder *decoder = [[FFDecoder alloc] init];
  
  if (![decoder openWithURL:URL format:format error:nil]) {
    return;
  }
  
  AVFrame *frame = avcodec_alloc_frame();

  while (YES) {
    NSError *error = nil;
    
    AVPacket packet;
    if (![decoder readFrame:&packet error:&error]) {
      if (error) break;
      continue;
    }
    
    [decoder decodeFrame:frame packet:&packet error:&error];   
    
    if (!error) {
      if (frame->pict_type == FF_I_TYPE) {
        FFDebug(@"Packet, pts=%lld, dts=%lld", packet.pts, packet.dts);

        FFDebug(@"Frame, key_frame=%d, pts=%lld, coded_picture_number=%d, display_picture_number=%d, pict_type=%@, quality=%d, age=%d", 
                frame->key_frame, frame->pts, frame->coded_picture_number, frame->display_picture_number,
                NSStringFromAVFramePictType(frame->pict_type), frame->quality, frame->age);    
      }
    }
    
    av_free_packet(&packet);
  }

  av_free(frame);
  
  [decoder release];
}
      

@end
