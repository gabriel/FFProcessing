//
//  FFDecoderOptions.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"

@interface FFDecoderOptions : NSObject {
  FFVFormat _format;
  FFRational _videoFrameRate;
  FFRational _videoTimeBase;
  FFRational _sampleAspectRatio;
  int64_t _duration;
}

@property (readonly, nonatomic) FFVFormat format;
@property (readonly, nonatomic) FFRational videoFrameRate;
@property (readonly, nonatomic) FFRational videoTimeBase;
@property (readonly, nonatomic) FFRational sampleAspectRatio;

- (id)initWithFormat:(FFVFormat)format videoFrameRate:(FFRational)videoFrameRate 
       videoTimeBase:(FFRational)videoTimeBase;

@end

