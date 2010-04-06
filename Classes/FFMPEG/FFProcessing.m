//
//  FFProcessing.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessing.h"

#import "FFUtils.h"

@implementation FFProcessing

@synthesize IFrameInterval=_IFrameInterval, smoothInterval=_smoothInterval, smoothIterations=_smoothIterations;

- (void)dealloc {
  [self close];
  [super dealloc];
}

- (BOOL)openURL:(NSURL *)URL format:(NSString *)format outputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat 
outputCodecName:(NSString *)outputCodecName error:(NSError **)error {
  
  _decoder = [[FFDecoder alloc] init];
  
  if (![_decoder openWithURL:URL format:format error:error]) {
    return NO;
  }
  
  _decoderFrame = avcodec_alloc_frame();
  if (_decoderFrame == NULL) {
    FFSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame");
    return NO;
  }
  
  FFOptions *options = [_decoder options];
  FFPresets *presets = [[FFPresets alloc] init]; // TODO(gabe): Presets hardcoded
  
  _encoder = [[FFEncoder alloc] initWithOptions:options
                                        presets:presets
                                           path:outputPath 
                                         format:outputFormat
                                      codecName:outputCodecName];

  [presets release];
  if (![_encoder open:error])
    return NO;
  
  return YES;
}

- (BOOL)process:(NSError **)error {
  NSAssert(_decoder, @"No decoder, forgot to open?");
  NSAssert(_encoder, @"No encoder, forgot to open?");

  if (!error) {
    NSError *processError = nil;
    error = &processError;
  }
  
  AVFrame *picture = FFPictureCreate(_decoder.options.pixelFormat, _decoder.options.width, _decoder.options.height);

  if (![_encoder writeHeader:error]) 
    return NO;

  int64_t IFrameIndex = 0;
  int64_t PFrameIndex = 0;
  while (YES) {
    *error = nil;
    
    if (![_decoder decodeVideoFrame:_decoderFrame error:error]) {
      if (*error) {
        FFDebug(@"Decode error");
        break;
      }
      //FFDebug(@"Decode buffering, continuing...");
      continue;
    }
    
    //if (_decoderFrame->pict_type == FF_I_TYPE) { }
    //FFDebug(@"Decoded frame, pict_type=%@", NSStringFromAVFramePictType(_decoderFrame->pict_type));
    int64_t duration = _decoderFrame->pts - _previousPTS;
    _previousPTS = _decoderFrame->pts;
    FFDebug(@"Duration: %lld", duration);
    
    int bytesEncoded = [_encoder encodeVideoFrame:_decoderFrame error:error];
    if (bytesEncoded < 0) {
      FFDebug(@"Encode error");
      break;
    }
    
    // If bytesEncoded is zero, there was buffering
    if (bytesEncoded > 0) {      
      if (_decoderFrame->pict_type == FF_I_TYPE) {
        if (IFrameIndex++ % _IFrameInterval != 0) {
          FFDebug(@"Skipping keyframe");
          continue;     
        }
        if (![_encoder writeVideoBuffer:error duration:duration]) break;
      } else if (_decoderFrame->pict_type == FF_P_TYPE) {
        if (_smoothIterations > 0 && (PFrameIndex++ % _smoothInterval != 0)) {
          for (int i = 0; i < _smoothIterations; i++)
            if (![_encoder writeVideoBuffer:error duration:((float)duration/(float)_smoothIterations)]) break;
        } else {
          if (![_encoder writeVideoBuffer:error duration:duration]) break;
        }
      }
    }
  }
  
  if (![_encoder writeTrailer:error]) return NO;
  
  FFPictureRelease(picture);
  
  return YES;
}
     
- (void)close {
  if (_decoderFrame != NULL) {
    av_free(_decoderFrame);
    _decoderFrame = NULL;
  }
  [_decoder release];
  _decoder = nil;
  
  [_encoder release];
  _encoder = nil;
}

- (void)_converter {
  // Setup converter
  /*!
   _converter = [[FFConverter alloc] initWithSourceWidth:[_options sourceWidth]
   sourceHeight:[_options sourceHeight]
   sourcePixelFormat:[_options sourcePixelFormat]
   destWidth:[_options width]
   destHeight:[_options height]
   destPixelFormat:[_options pixelFormat]];
   */
}  

@end
