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
  
  NSError *error = nil;
  if (![decoder openWithURL:URL format:format error:&error]) {
    return;
  }
  
  AVFrame *frame = avcodec_alloc_frame();
  BOOL reading = YES;
  while (reading) {
    [decoder readFrame:frame error:&error];   
    if (error) {
      switch (error.code) {
        case FFErrorCodeReadFrameIncomplete: break;
        default: reading = NO; break;
      }
      continue;
    }
    FFDebug(@"key_frame=%d, pts=%d", frame->key_frame, frame->pts);    
  }  
  av_free(frame);
}
      

@end
