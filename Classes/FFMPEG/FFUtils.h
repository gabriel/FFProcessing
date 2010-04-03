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

AVFrame *FFPictureCreate(enum PixelFormat pixelFormat, int width, int height);

void FFPictureRelease(AVFrame *picture);

// Fill dummy image
void FFFillYUVImage(AVFrame *picture, NSInteger frameIndex, int width, int height);


@interface FFUtils : NSObject { }

+ (NSString *)documentsDirectory;

+ (NSString *)resolvedPathForURL:(NSURL *)URL;

+ (NSURL *)resolvedURLForURL:(NSURL *)URL;

@end