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

@interface FFConverter : NSObject {
  AVFrame *_destFrame;
  uint8_t *_videoBuffer;    
  
  enum PixelFormat _sourcePixelFormat;  
  int _sourceWidth;
  int _sourceHeight;  
  
  enum PixelFormat _destPixelFormat;  
  int _destWidth;
  int _destHeight;  
}

@property (readonly, nonatomic) int destWidth;
@property (readonly, nonatomic) int destHeight;  


- (id)initWithSourceWidth:(int)width sourceHeight:(int)sourceHeight sourcePixelFormat:(enum PixelFormat)sourcePixelFormat
                destWidth:(int)destWidth destHeight:(int)destHeight destPixelFormat:(enum PixelFormat)destPixelFormat
                    error:(NSError **)error;

// Buffer length in bytes for destination frame data
//- (int)destBufferLength;

- (AVFrame *)scalePicture:(AVFrame *)picture error:(NSError **)error;

@end
