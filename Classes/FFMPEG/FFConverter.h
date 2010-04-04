//
//  FFConverter.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"
#include "libswscale/swscale.h"

#import "FFOptions.h"

@interface FFConverter : NSObject {
  AVFrame *_picture;

  FFOptions *_inputOptions;
  FFOptions *_outputOptions;
}

@property (readonly, nonatomic) FFOptions *inputOptions;
@property (readonly, nonatomic) FFOptions *outputOptions;

- (id)initWithInputOptions:(FFOptions *)inputOptions outputOptions:(FFOptions *)outputOptions;


- (AVFrame *)scalePicture:(AVFrame *)picture error:(NSError **)error;

@end
