//
//  FFAVDecoder.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/14/10.
//  Copyright 2010. All rights reserved.
//

#import "FFAVDecoder.h"


@implementation FFAVDecoder

@synthesize options=_options, readVideoPTS=_readVideoPTS, videoDuration=_videoDuration;

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error {
  return NO;
}

- (BOOL)decodeFrame:(FFVFrameRef)frame error:(NSError **)error {
  return NO;
}

- (void)close {
}

@end
