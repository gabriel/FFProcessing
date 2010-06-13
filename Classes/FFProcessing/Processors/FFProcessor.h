//
//  FFProcessor.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"
#import "libavcodec/avcodec.h"

@protocol FFProcessor <NSObject>
- (BOOL)open:(NSError **)error;
- (BOOL)processFrame:(FFVFrameRef)frame decoder:(id<FFDecoder>)decoder index:(NSInteger)index error:(NSError **)error;
- (BOOL)close:(NSError **)error;
@end
