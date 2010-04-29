//
//  FFConverter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"
#include "libswscale/swscale.h"

#import "FFDecoderOptions.h"
#import "FFEncoderOptions.h"

@interface FFConverter : NSObject {
  AVFrame *_picture;

  FFDecoderOptions *_decoderOptions;
  FFEncoderOptions *_encoderOptions;
}

@property (readonly, nonatomic) FFDecoderOptions *decoderOptions;
@property (readonly, nonatomic) FFEncoderOptions *encoderOptions;

- (id)initWithDecoderOptions:(FFDecoderOptions *)decoderOptions encoderOptions:(FFEncoderOptions *)encoderOptions;


- (AVFrame *)scalePicture:(AVFrame *)picture error:(NSError **)error;

@end
