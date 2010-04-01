//
//  FFDefines.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#include "libavcodec/avcodec.h"

#define FFSetError(__ERROR__, __ERROR_CODE__, ...) do { NSLog(__VA_ARGS__); \
  if (__ERROR__) *__ERROR__ = [NSError errorWithDomain:@"FFMPEG" code:__ERROR_CODE__ \
userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:__VA_ARGS__] forKey:NSLocalizedDescriptionKey]]; \
} while (0)

enum {
  // Opening
  FFErrorCodeInputFormatNotFound = 5,
  FFErrorCodeOpen = 10,
  FFErrorCodeStreamInfoNotFound = 20,
  FFErrorCodeVideoStreamNotFound = 30,
  FFErrorCodeVideoCodecNotFound = 40,
  FFErrorCodeVideoCodecOpen = 41,  
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
  FFErrorCodeOpenAlready = 350,
  FFErrorCodeWriteHeader = 360,
  FFErrorCodeWriteTrailer = 370,
} FFErrorCode;

//#define FFDebug(...) do {} while(0)

#define FFDebug(...) NSLog(__VA_ARGS__)

static inline NSString *NSStringFromAVFramePictType(int pictType) {
  switch (pictType) {
    case FF_I_TYPE: return @"I";
    case FF_P_TYPE: return @"P";    
    case FF_B_TYPE: return @"B";
    default: return @"-";
  }
}