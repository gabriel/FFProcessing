//
//  FFUtils.h
//  FFPlayer
//
//  Created by Gabriel Handford on 3/24/10.
//  Copyright 2010. All rights reserved.
//

#include "libavformat/avformat.h"
#include "libavdevice/avdevice.h"

#import "libavcodec/avcodec.h"

extern NSString *const FFMPEGErrorCodeKey; // Key for NSError for source error code

#define FFSetError(__ERROR__, __ERROR_CODE__, __FFMPEG_ERROR_CODE__, __DESC__, ...) do { \
NSString *message = [NSString stringWithFormat:@"%@ (%d)", [NSString stringWithFormat:__DESC__, ##__VA_ARGS__], __FFMPEG_ERROR_CODE__]; \
NSLog(@"%@", message); \
if (__ERROR__) *__ERROR__ = [NSError errorWithDomain:@"FFMPEG" code:__ERROR_CODE__ \
userInfo:[NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey,  \
[NSNumber numberWithInteger:__FFMPEG_ERROR_CODE__], FFMPEGErrorCodeKey, nil]]; \
} while (0)

enum {
  // Opening
  FFErrorCodeInputFormatNotFound = 5,
  FFErrorCodeOpen = 10,
  FFErrorCodeOpenAlready = 11,
  FFErrorCodeStreamInfoNotFound = 20,
  FFErrorCodeVideoStreamNotFound = 30,
  FFErrorCodeCodecNotFound = 40,
  FFErrorCodeCodecOpen = 41,  
  // Alloc
  FFErrorCodeAllocateFrame = 51,
  FFErrorCodeAllocateVideoBuffer = 60,
  // Reading
  FFErrorCodeReadFrame = 100,
  // Convert
  FFErrorCodeScaleContext = 200,
  // Encode
  FFErrorCodeWriteFrame = 300,
  FFErrorCodeEncodeFrame = 301,
  FFErrorCodeUnknownOutputFormat = 310,
  FFErrorCodeAllocFormatContext = 320,
  FFErrorCodeInvalidFormatParameters = 330,
  FFErrorCodeAllocStream = 340,  
  FFErrorCodeWriteHeader = 360,
  FFErrorCodeWriteTrailer = 370,
} FFErrorCode;

#if DEBUG
#define FFDebugFrame(...) do { } while(0)
//#define FFDebugFrame(...) NSLog(__VA_ARGS__)
#define FFDebug(...) NSLog(__VA_ARGS__)
#else
#define FFDebug(...) do { } while(0)
#endif
#define FFWarn(...) NSLog(__VA_ARGS__)

static inline NSString *NSStringFromAVFramePictType(int pictType) {
  switch (pictType) {
    case FF_I_TYPE: return @"I";
    case FF_P_TYPE: return @"P";    
    case FF_B_TYPE: return @"B";
    default: return @"-";
  }
}


void FFInitialize(void);
BOOL FFIsInitialized(void);

BOOL FFIsFlushPacket(AVPacket *packet);

AVFrame *FFPictureCreate(enum PixelFormat pixelFormat, int width, int height);

void FFPictureRelease(AVFrame *picture);

// Fill dummy image
void FFFillYUVImage(AVFrame *picture, NSInteger frameIndex, int width, int height);

/*!
 Find rational approximation to given real number.
 David Eppstein / UC Irvine / 8 Aug 1993
 
 With corrections from Arno Formella, May 2008
 
 @param r Real number to approx
 @param maxden Maximum denominator allowed
 
 Based on the theory of continued fractions
 if x = a1 + 1/(a2 + 1/(a3 + 1/(a4 + ...)))
 then best approximation is found by truncating this series
 (with some adjustments in the last term).
 
 Note the fraction can be recovered as the first column of the matrix
 ( a1 1 ) ( a2 1 ) ( a3 1 ) ...
 ( 1  0 ) ( 1  0 ) ( 1  0 )
 Instead of keeping the sequence of continued fraction terms,
 we just keep the last partial product of these matrices.
 */
AVRational FFFindRationalApproximation(float r, long maxden);


@interface FFUtils : NSObject { }

+ (NSString *)documentsDirectory;

+ (NSString *)resolvedPathForURL:(NSURL *)URL;

+ (NSURL *)resolvedURLForURL:(NSURL *)URL;

@end