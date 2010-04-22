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
@property (retain, nonatomic) FFProcessingOptions *options;
- (BOOL)_processAtIndex:(NSInteger)index count:(NSInteger)count error:(NSError **)error;
@end

@implementation FFProcessing

@synthesize options=_options, delegate=_delegate, cancelled=_cancelled;

- (id)initWithOptions:(FFProcessingOptions *)options {
  if ((self = [super init])) {
    _options = [options retain];
  }
  return self;
}

- (void)dealloc {
  [self close];
  [_options release];
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
  
  // Fill in encoder options (with decoder properties) if not set
  int width = _options.encoderOptions.width;
  int height = _options.encoderOptions.height;
  enum PixelFormat pixelFormat = _options.encoderOptions.pixelFormat;
  AVRational videoTimeBase = _options.encoderOptions.videoTimeBase;
  if (width == 0) width = _decoder.options.width;
  if (height == 0) height = _decoder.options.height;
  if (pixelFormat == PIX_FMT_NONE) pixelFormat = _decoder.options.pixelFormat;
  if (videoTimeBase.num == 0) videoTimeBase = _decoder.options.videoTimeBase;
  
  self.options.encoderOptions = [[FFEncoderOptions alloc] initWithPath:_options.encoderOptions.path 
                                                                format:_options.encoderOptions.format
                                                             codecName:_options.encoderOptions.codecName
                                                                 width:width
                                                                height:height
                                                           pixelFormat:pixelFormat
                                                         videoTimeBase:videoTimeBase];

  _encoder = [[FFEncoder alloc] initWithOptions:self.options.encoderOptions];
  
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
  
  if (!processed && *error) {
    [_delegate processing:self didError:*error index:index count:count];
  }
  
  [self _closeDecoder];
  return processed;
}

- (BOOL)_processAtIndex:(NSInteger)index count:(NSInteger)count error:(NSError **)error {

  [_delegate processing:self didStartIndex:index count:count];
  
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

  while (!_cancelled) {
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
    
    [_delegate processing:self didReadFramePTS:[_decoder readVideoPTS] duration:[_decoder videoDuration] 
                    index:index count:count];

    int bytesEncoded = [_encoder encodeVideoFrame:_decoderFrame error:error];
    if (bytesEncoded < 0) {
      FFDebug(@"Encode error");
      break;
    }
    
    if (_cancelled) break;
    
    AVFrame *codedFrame = [_encoder codedFrame];
    
    // If bytesEncoded is zero, there was buffering
    if (bytesEncoded > 0) {      
      if (codedFrame->pict_type == FF_I_TYPE) {        
        FFDebug(@"I-frame %lld (%d, %d)", codedFrame->pts, _IFrameIndex, _GOPIndex);
        _IFrameIndex++;
        _GOPIndex = 0;
        
        if ((_options.skipEveryIFrameInterval > 0) && // Skipping I-frames is on
            !(index == 0 && _IFrameIndex == 1) && // Don't skip if first I-frame in first input, no matter what options later
            ((index > 0 && _IFrameIndex == 1) || // Skip if first I-frame in subsequent inputs
             (_IFrameIndex % _options.skipEveryIFrameInterval == 0))) // We are on skip interval
        { 
          FFDebug(@"Skipping I-frame");          
        } else {
          if (![_encoder writeVideoBuffer:error]) break;
        }
        
      } else if (codedFrame->pict_type == FF_P_TYPE) {
        _GOPIndex++;
        if (_options.smoothFrameInterval > 0 && (_PFrameIndex++ % _options.smoothFrameInterval == 0)) {
          
          NSInteger count = _options.smoothFrameRepeat + 1;
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
  
  if (_cancelled) {
    [_delegate processingDidCancel:self];
    return NO;
  } else { 
    [_delegate processing:self didFinishIndex:index count:count];  
    return YES;
  }
}
     
- (void)close {  
  [_encoder release];
  _encoder = nil;
}

- (void)cancel {
  _cancelled = YES;
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
