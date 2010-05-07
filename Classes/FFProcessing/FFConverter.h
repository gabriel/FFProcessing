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

#import "FFTypes.h"
#import "FFFilter.h"

@interface FFConverter : NSObject <FFFilter> {
  FFAVFormat _avFormat;
  FFAVFrame _avFrame;
}

/*!
 Converter with picture format (output).
 @param avFormat Picture format; If width, height, or pixelFormat are set to 0, then will use the source format for that parameter
 */
- (id)initWithAVFormat:(FFAVFormat)avFormat;

- (FFAVFrame)scalePicture:(FFAVFrame)avFrame error:(NSError **)error;

@end
