//
//  FFMPUtils.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/9/10.
//  Copyright 2010. All rights reserved.
//

#import "libavutil/pixfmt.h"
#import "libavcodec/avcodec.h"

#import "FFTypes.h"

extern NSString *const FFMPErrorCodeKey; // Key for NSError for source error code

#define FFMPSetError(__ERROR__, __ERROR_CODE__, __FFMP_ERROR_CODE__, __DESC__, ...) do { \
NSString *message = [NSString stringWithFormat:@"%@ (%d)", [NSString stringWithFormat:__DESC__, ##__VA_ARGS__], __FFMP_ERROR_CODE__]; \
NSLog(@"%@", message); \
if (__ERROR__) *__ERROR__ = [NSError errorWithDomain:@"FFMP" code:__ERROR_CODE__ \
userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,  \
[NSNumber numberWithInteger:__FFMP_ERROR_CODE__], FFMPErrorCodeKey, nil]]; \
} while (0)

enum PixelFormat PixelFormatFromFFPixelFormat(FFPixelFormat pixelFormat);
FFPixelFormat FFPixelFormatFromPixelFormat(enum PixelFormat pixelFormat);

FFVFrameRef FFVFrameCreateFromAVFrame(AVFrame *frame, FFVFormat format);

void FFVFrameCopyFromAVFrame(FFVFrameRef frame, AVFrame *avFrame, FFVFormat format);

AVPicture *AVPictureFromFFVFrame(FFVFrameRef frame);

/*!
 Fill AVFrame from FFVFrame.
 @param frame
 @param avFrame
 */
void AVFrameFillFromFFVFrame(AVFrame *avFrame, FFVFrameRef frame);

/*!
 Fill FFVFrame from AVFrame.
 @param avFrame
 @param frame
 */
void FFVFrameFillFromAVFrame(FFVFrameRef frame, AVFrame *avFrame);

FFRational FFRationalFromAVRational(AVRational rational);

AVRational AVRationalFromFFRational(FFRational rational);

#pragma mark -

static inline NSString *NSStringFromAVFramePictType(int pictType) {
  switch (pictType) {
    case FF_I_TYPE: return @"I";
    case FF_P_TYPE: return @"P";    
    case FF_B_TYPE: return @"B";
    default: return @"-";
  }
}

void FFMPInitialize(void);
BOOL FFMPIsInitialized(void);

BOOL FFIsAVFlushPacket(AVPacket *packet);
