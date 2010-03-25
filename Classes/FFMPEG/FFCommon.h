//
//  FFCommon.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

void FFInitialize(void);

BOOL FFIsFlushPacket(AVPacket *packet);

AVFrame *FFCreatePicture(enum PixelFormat pixelFormat, int width, int height);

// Fill dummy image
void FFFillYUVImage(AVFrame *picture, NSInteger frameIndex, int width, int height);


@interface FFCommon : NSObject { }

+ (NSString *)documentsDirectory;

@end