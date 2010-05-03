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
  FFPictureFormat _pictureFormat;
  FFPictureFrame _pictureFrame;
}

/*!
 Converter with picture format (output).
 @param pictureFormat Picture format; If width, height, or pixelFormat are set to 0, then will use the source format for that parameter
 */
- (id)initWithPictureFormat:(FFPictureFormat)pictureFormat;

- (FFPictureFrame)scalePicture:(FFPictureFrame)pictureFrame error:(NSError **)error;

@end
