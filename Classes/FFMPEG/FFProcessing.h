//
//  FFProcessing.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"
#import "FFEncoder.h"

@interface FFProcessing : NSObject {
  FFDecoder *_decoder;
  AVFrame *_decoderFrame;
  
  FFEncoder *_encoder;
}

- (BOOL)openURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error;

- (BOOL)process:(NSError **)error;

- (void)close;

@end
