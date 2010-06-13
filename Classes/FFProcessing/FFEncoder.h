//
//  FFEncoder.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/11/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"

@protocol FFEncoder <NSObject>
- (BOOL)open:(NSError **)error;
- (BOOL)isOpen;
- (BOOL)writeHeader:(NSError **)error;
- (int)encodeFrame:(FFVFrameRef)frame error:(NSError **)error;
- (BOOL)writeVideoBuffer:(NSError **)error;
- (BOOL)writeTrailer:(NSError **)error;
- (void)close;

/*!
 Access underlying coded frame.

 For FFMPEncoder is an (AVFrame *).
 */
- (void *)codedFrame;
@end