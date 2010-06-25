//
//  FFDecoder.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/11/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoderOptions.h"

@protocol FFDecoder <NSObject>

@property (readonly, nonatomic) FFDecoderOptions *options;
@property (readonly, nonatomic) int64_t readVideoPTS;
@property (readonly, nonatomic) int64_t videoDuration;

- (BOOL)openWithURL:(NSURL *)URL format:(NSString *)format error:(NSError **)error;
- (BOOL)decodeFrame:(FFVFrameRef)frame error:(NSError **)error;
- (void)close;
@end