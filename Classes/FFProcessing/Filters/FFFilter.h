//
//  FFFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "libavcodec/avcodec.h"
#import "FFDecoder.h"

@protocol FFFilter <NSObject>
- (FFAVFrame)filterAVFrame:(FFAVFrame)avFrame error:(NSError **)error;
@end

