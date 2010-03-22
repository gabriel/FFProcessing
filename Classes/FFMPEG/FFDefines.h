//
//  FFDefines.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

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
  FFErrorCodeReadFrameDecode = 110,
  FFErrorCodeReadFrameIncomplete = 120,
  // Convert
  FFErrorCodeScaleContext = 200,
} FFErrorCode;

//#define FFDebug(...) do {} while(0)

#define FFDebug(...) NSLog(__VA_ARGS__)

