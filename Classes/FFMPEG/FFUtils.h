//
//  FFUtils.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

void FFInitialize(void);
BOOL FFIsInitialized(void);

BOOL FFIsFlushPacket(AVPacket *packet);

AVFrame *FFCreatePicture(enum PixelFormat pixelFormat, int width, int height);

void FFReleasePicture(AVFrame *picture);

// Fill dummy image
void FFFillYUVImage(AVFrame *picture, NSInteger frameIndex, int width, int height);


@interface FFUtils : NSObject { }

+ (NSString *)documentsDirectory;

+ (NSString *)resolvePathForURL:(NSURL *)URL;

@end