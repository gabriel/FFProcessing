//
//  FFAVDecoder.h
//  FFProcessing
//
//  Created by Gabriel Handford on 7/14/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoderOptions.h"

#import "FFDecoder.h"

@interface FFAVDecoder : NSObject <FFDecoder> {
  FFDecoderOptions *_options;
  
  int64_t _readVideoPTS;
  int64_t _videoDuration;
}

@property (readonly, nonatomic) FFDecoderOptions *options;
@property (readonly, nonatomic) int64_t readVideoPTS;
@property (readonly, nonatomic) int64_t videoDuration;

@end
