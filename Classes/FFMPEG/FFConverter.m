//
//  FFConverter.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFConverter.h"
#import "FFDefines.h"

@interface FFConverter ()
- (BOOL)_loadWithError:(NSError **)error;
@end

@implementation FFConverter

@synthesize destWidth=_destWidth, destHeight=_destHeight;

- (id)initWithSourceWidth:(int)sourceWidth sourceHeight:(int)sourceHeight sourcePixelFormat:(enum PixelFormat)sourcePixelFormat
                destWidth:(int)destWidth destHeight:(int)destHeight destPixelFormat:(enum PixelFormat)destPixelFormat
                    error:(NSError **)error {
  
  if ((self = [super init])) {
    _sourceWidth = sourceWidth;
    _sourceHeight = sourceHeight;
    _sourcePixelFormat = sourcePixelFormat;
    _destWidth = destWidth;
    _destHeight = destHeight;
    _destPixelFormat = destPixelFormat;
    [self _loadWithError:error];
  }
  return self;
}

- (void)dealloc {
  if (_destFrame != NULL) av_free(_destFrame);
  _destFrame = NULL;
  if (_videoBuffer != NULL) av_free(_videoBuffer);
  _videoBuffer = NULL;  
  [super dealloc];
}  

- (BOOL)_loadWithError:(NSError **)error {
  // Frame after scaling and converting pixel format
  _destFrame = avcodec_alloc_frame();
  if (_destFrame == NULL) {
    FFSetError(error, FFErrorCodeAllocateFrame, @"Couldn't allocate destination frame");
    return NO;
  }  
  
  // Video buffer
  int bytes = avpicture_get_size(_destPixelFormat, _destWidth, _destHeight);		
  _videoBuffer = (uint8_t*)av_malloc(bytes * sizeof(uint8_t));
  if (_videoBuffer == NULL) {
    FFSetError(error, FFErrorCodeAllocateVideoBuffer, @"Couldn't allocate video buffer");
    return NO;
  }
  
  // Assign video buffer to dest frame
  avpicture_fill((AVPicture *)_destFrame, _videoBuffer, _destPixelFormat, _destWidth, _destHeight);
  return YES;
}

- (int)destBufferLength {
  return avpicture_get_size(_destPixelFormat, _destWidth, _destHeight);
}

- (AVFrame *)scaleFrame:(AVFrame *)frame error:(NSError **)error {
  struct SwsContext *scaleContext = NULL;

  scaleContext = sws_getCachedContext(scaleContext, 
                                       _sourceWidth, _sourceHeight, _sourcePixelFormat, 
                                       _destWidth, _destHeight, _destPixelFormat, 
                                       SWS_BICUBIC, NULL, NULL, NULL);
  
  if (scaleContext == NULL) {
    FFSetError(error, FFErrorCodeScaleContext, @"No scale context");
    return NULL;
  }
  
  sws_scale(scaleContext, frame->data, frame->linesize, 0,
            _sourceHeight, _destFrame->data, _destFrame->linesize);
  
  return _destFrame;
}


@end
