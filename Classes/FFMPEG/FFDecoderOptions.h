//
//  FFDecoderOptions.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "libavcodec/avcodec.h"

#import "FFPresets.h"

@interface FFDecoderOptions : NSObject {
  int _width;
  int _height;
  enum PixelFormat _pixelFormat;  
  AVRational _videoFrameRate;
  AVRational _videoTimeBase;
  AVRational _sampleAspectRatio;
  int64_t _duration;
}

@property (readonly, nonatomic) int width;
@property (readonly, nonatomic) int height;
@property (readonly, nonatomic) enum PixelFormat pixelFormat;
@property (readonly, nonatomic) AVRational videoFrameRate;
@property (readonly, nonatomic) AVRational videoTimeBase;
@property (readonly, nonatomic) AVRational sampleAspectRatio;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat videoFrameRate:(AVRational)videoFrameRate
      videoTimeBase:(AVRational)videoTimeBase;

@end

