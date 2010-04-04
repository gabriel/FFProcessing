//
//  FFConverter.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFConverter.h"
#import "FFUtils.h"

@implementation FFConverter

@synthesize inputOptions=_inputOptions, outputOptions=_outputOptions;

- (id)initWithInputOptions:(FFOptions *)inputOptions outputOptions:(FFOptions *)outputOptions {
  
  if ((self = [self init])) {
    _inputOptions = [inputOptions retain];
    _outputOptions = [outputOptions retain];
    _picture = NULL;
  }
  return self;
}

- (void)dealloc {
  FFPictureRelease(_picture);
  [_inputOptions release];
  [_outputOptions release];
  [super dealloc];
}  

- (AVFrame *)scalePicture:(AVFrame *)picture error:(NSError **)error {
  struct SwsContext *scaleContext = NULL;
  
  if (_picture == NULL) {
    _picture = FFPictureCreate(_outputOptions.pixelFormat, _outputOptions.width, _outputOptions.height);    
    if (_picture == NULL) {
      FFSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame");
      return NULL;
    }
  }

  scaleContext = sws_getCachedContext(scaleContext, 
                                       _inputOptions.width, _inputOptions.height, _inputOptions.pixelFormat,
                                       _outputOptions.width, _outputOptions.height, _outputOptions.pixelFormat, 
                                       SWS_BICUBIC, NULL, NULL, NULL);
  
  if (scaleContext == NULL) {
    FFSetError(error, FFErrorCodeScaleContext, -1, @"No scale context");
    return NULL;
  }
  
  sws_scale(scaleContext, picture->data, picture->linesize, 0,
            _inputOptions.height, _picture->data, _picture->linesize);
  
  _picture->pts = picture->pts;
  
  return _picture;
}


@end
