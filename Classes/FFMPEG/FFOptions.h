//
//  FFOptions.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/4/10.
//  Copyright 2010. All rights reserved.
//

#import "libavcodec/avcodec.h"

#import "FFPresets.h"

@interface FFOptions : NSObject {
  int _width;
  int _height;
  enum PixelFormat _pixelFormat;  
  AVRational _videoFrameRate;
  
  FFPresets *_presets;
}

@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;
@property (assign, nonatomic) enum PixelFormat pixelFormat;
@property (assign, nonatomic) AVRational videoFrameRate;
@property (retain, nonatomic) FFPresets *presets;

- (id)initWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat;

+ (FFOptions *)optionsWithWidth:(int)width height:(int)height pixelFormat:(enum PixelFormat)pixelFormat;

- (void)apply:(AVCodecContext *)codecContext;

@end
