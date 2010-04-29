//
//  FFConverter.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFConverter.h"
#import "FFUtils.h"

@implementation FFConverter

@synthesize decoderOptions=_decoderOptions, encoderOptions=_encoderOptions;

- (id)initWithDecoderOptions:(FFDecoderOptions *)decoderOptions encoderOptions:(FFEncoderOptions *)encoderOptions {
  
  if ((self = [self init])) {
    _decoderOptions = [decoderOptions retain];
    _encoderOptions = [encoderOptions retain];
    _picture = NULL;
  }
  return self;
}

- (void)dealloc {
  FFPictureRelease(_picture);
  [_decoderOptions release];
  [_encoderOptions release];
  [super dealloc];
}  

- (AVFrame *)scalePicture:(AVFrame *)picture error:(NSError **)error {
  struct SwsContext *scaleContext = NULL;
  
  if (_picture == NULL) {
    _picture = FFPictureCreate(_encoderOptions.pixelFormat, _encoderOptions.width, _encoderOptions.height);    
    if (_picture == NULL) {
      FFSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame");
      return NULL;
    }
  }

  scaleContext = sws_getCachedContext(scaleContext, 
                                       _decoderOptions.width, _decoderOptions.height, _decoderOptions.pixelFormat,
                                       _encoderOptions.width, _encoderOptions.height, _encoderOptions.pixelFormat, 
                                       SWS_BICUBIC, NULL, NULL, NULL);
  
  if (scaleContext == NULL) {
    FFSetError(error, FFErrorCodeScaleContext, -1, @"No scale context");
    return NULL;
  }
  
  /*!
  int sws_scale(struct SwsContext *context, const uint8_t* const srcSlice[], const int srcStride[],
                int srcSliceY, int srcSliceH, uint8_t* const dst[], const int dstStride[]);
   */

  sws_scale(scaleContext, 
            (const uint8_t* const *)picture->data, 
            (const int *)picture->linesize, 
            0,
            _decoderOptions.height, 
            _picture->data, 
            _picture->linesize);
  
  _picture->pts = picture->pts;
  
  return _picture;
}


@end
