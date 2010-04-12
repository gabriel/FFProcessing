//
//  FFProcessing.m
//  FFPlayer
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessing.h"

#import "FFUtils.h"

@interface FFProcessing ()
- (BOOL)_processAtIndex:(NSInteger)index count:(NSInteger)count error:(NSError **)error;
@end

@implementation FFProcessing

@synthesize outputPath=_outputPath;
@synthesize skipEveryIFrameInterval=_skipEveryIFrameInterval, smoothFrameInterval=_smoothFrameInterval, smoothFrameRepeat=_smoothFrameRepeat;

- (id)initWithOutputPath:(NSString *)outputPath outputFormat:(NSString *)outputFormat 
         outputCodecName:(NSString *)outputCodecName {
  
  if ((self = [super init])) {
    _outputPath = [outputPath retain];
    _outputFormat = [outputFormat retain];
    _outputCodecName = [outputCodecName retain];
  }
  return self;
}

- (void)dealloc {
  [self close];
  [_outputPath release];
  [_outputFormat release];
  [_outputCodecName release];
  [super dealloc];
}

- (BOOL)_openDecoder:(NSURL *)URL format:(NSString *)format error:(NSError **)error {
  _decoder = [[FFDecoder alloc] init];
  
  if (![_decoder openWithURL:URL format:format error:error]) {
    return NO;
  }
  
  _decoderFrame = avcodec_alloc_frame();
  if (_decoderFrame == NULL) {
    FFSetError(error, FFErrorCodeAllocateFrame, -1, @"Couldn't allocate frame");
    return NO;
  }
  
  return YES;
}

- (void)_closeDecoder {
  if (_decoderFrame != NULL) {
    av_free(_decoderFrame);
    _decoderFrame = NULL;
  }
  [_decoder release];
  _decoder = nil;  
}

- (BOOL)_openEncoder:(NSError **)error {
  FFPresets *presets = [[FFPresets alloc] initWithCodeName:_outputCodecName];
  
  _encoder = [[FFEncoder alloc] initWithOptions:[_decoder options]
                                        presets:presets
                                           path:_outputPath 
                                         format:_outputFormat
                                      codecName:_outputCodecName];
  
  [presets release];
  if (![_encoder open:error])
    return NO;
  
  return YES;
}

- (BOOL)processURL:(NSURL *)URL format:(NSString *)format index:(NSInteger)index count:(NSInteger)count error:(NSError **)error {
  if (!error) {
    NSError *processError = nil;
    error = &processError;
  }
  if (![self _openDecoder:URL format:format error:error])
    return NO;
    
  BOOL processed = [self _processAtIndex:index count:count error:error];
  [self _closeDecoder];
  return processed;
}

- (BOOL)_processAtIndex:(NSInteger)index count:(NSInteger)count error:(NSError **)error {

  _IFrameIndex = 0;  
  _PFrameIndex = 0;
  _GOPIndex = 0;
  
  if (!_encoder) {
    _previousEndPTS = 0;
    if (![self _openEncoder:error]) 
      return NO;
  }
  
  AVFrame *picture = FFPictureCreate(_decoder.options.pixelFormat, _decoder.options.width, _decoder.options.height);

  if (index == 0) {
    if (![_encoder writeHeader:error]) 
      return NO;
  }

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
    _decoderFrame->pts += _previousEndPTS;
    //_decoderFrame->pict_type = 0;

    int bytesEncoded = [_encoder encodeVideoFrame:_decoderFrame error:error];
    if (bytesEncoded < 0) {
      FFDebug(@"Encode error");
      break;
    }
    
    AVFrame *codedFrame = [_encoder codedFrame];
    
    // If bytesEncoded is zero, there was buffering
    if (bytesEncoded > 0) {      
      if (codedFrame->pict_type == FF_I_TYPE) {        
        FFDebug(@"I-frame %lld (%d, %d)", codedFrame->pts, _IFrameIndex, _GOPIndex);
        _IFrameIndex++;
        _GOPIndex = 0;
        
        if ((_skipEveryIFrameInterval > 0) && // Skipping I-frames is on
            !(index == 0 && _IFrameIndex == 1) && // Don't skip if first I-frame in first input, no matter what options later
            ((index > 0 && _IFrameIndex == 1) || // Skip if first I-frame in subsequent inputs
             (_IFrameIndex % _skipEveryIFrameInterval == 0))) // We are on skip interval
        { 
          FFDebug(@"Skipping I-frame");          
        } else {
          if (![_encoder writeVideoBuffer:error]) break;
        }
        
      } else if (codedFrame->pict_type == FF_P_TYPE) {
        _GOPIndex++;
        if (_smoothFrameInterval > 0 && (_PFrameIndex++ % _smoothFrameInterval == 0)) {
          
          NSInteger count = _smoothFrameRepeat + 1;
          int64_t startPTS = codedFrame->pts;
          int64_t duration = (int64_t)((codedFrame->pts - _previousPTS)/(double)count);
          
          for (int i = 0; i < count; i++) {
            codedFrame->pts = startPTS + (duration * i);            
            FFDebug(@"P-frame (duping), %lld (%d/%d)", codedFrame->pts, (i + 1), count);
            if (![_encoder writeVideoBuffer:error]) break;
          }
        } else { 
          FFDebug(@"P-frame %lld", codedFrame->pts);
          if (![_encoder writeVideoBuffer:error]) break;
        }
      }
    }
    
    _previousPTS = codedFrame->pts;    
  }
  
  _previousEndPTS = _previousPTS + 1; // TODO(gabe): Fix me
  
  if (index == (count - 1)) {
    if (![_encoder writeTrailer:error]) 
      return NO;
  }
  
  FFPictureRelease(picture);
  
  return YES;
}
     
- (void)close {  
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
