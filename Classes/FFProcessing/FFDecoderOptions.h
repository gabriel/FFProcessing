//
//  FFDecoderOptions.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "libavcodec/avcodec.h"

#import "FFPresets.h"
#import "FFTypes.h"

@interface FFDecoderOptions : NSObject {
  FFAVFormat _avFormat;
  AVRational _videoFrameRate;
  AVRational _videoTimeBase;
  AVRational _sampleAspectRatio;
  int64_t _duration;
}

@property (readonly, nonatomic) FFAVFormat avFormat;
@property (readonly, nonatomic) AVRational videoFrameRate;
@property (readonly, nonatomic) AVRational videoTimeBase;
@property (readonly, nonatomic) AVRational sampleAspectRatio;

- (id)initWithAVFormat:(FFAVFormat)avFormat videoFrameRate:(AVRational)videoFrameRate 
              videoTimeBase:(AVRational)videoTimeBase;

@end

