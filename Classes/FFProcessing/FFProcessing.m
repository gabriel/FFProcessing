//
//  FFProcessing.m
//  FFProcessing
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

@synthesize delegate=_delegate, cancelled=_cancelled;

- (id)initWithProcessor:(id<FFProcessor>)processor filter:(id<FFFilter>)filter {
  if ((self = [super init])) {
    _processor = [processor retain];
    _filter = [filter retain];
  }
  return self;
}

- (void)dealloc {
  [self close:nil];
  [_processor release];
  [_filter release];
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

  if (index == 0) {
    _previousEndPTS = 0;
    if (![_processor open:error])
      return NO;
    _open = YES;
  }
  
  FFVFormat format = _decoder.options.format;
  _decodedFrame = FFVFrameCreate(format);

  while (!_cancelled) {
    *error = nil;
    
    if (![_decoder decodeAVFrame:_decoderFrame error:error]) {
      if (*error) {
        FFDebug(@"Decode error");
        break;
      }
      //FFDebug(@"Decode buffering, continuing...");
      continue;
    }

    //FFDebug(@"Decoded frame, pict_type=%@", NSStringFromAVFramePictType(_decoderFrame->pict_type));    
    _decoderFrame->pts += _previousEndPTS;
    
    FFVFrameSetData(_decodedFrame, _decoderFrame->data[0]);
    
    [_delegate processing:self didReadFramePTS:[_decoder readVideoPTS] duration:[_decoder videoDuration] 
                    index:index count:count];
    
    // Apply filter
    if (_filter) {
      _decodedFrame = [_filter filterFrame:_decodedFrame error:error];
      if (!_decodedFrame) break;
    }

    // Run processor
    if (![_processor processFrame:_decodedFrame decoder:_decoder index:index error:error])
      break;
  }
  
  // Clear, don't release; Will be freed by av_free
  _decodedFrame->data[0] = NULL;
  
  if (_decoderFrame)
    _previousEndPTS = _decoderFrame->pts + 1; // TODO(gabe): Fix me
  
  // Last file
  if (index == (count - 1)) {
    [self close:error];
  }
  
  if (_cancelled) {
    [_delegate processingDidCancel:self];
    return NO;
  } else { 
    [_delegate processing:self didFinishIndex:index count:count];  
    return YES;
  }
}

- (void)cancel {
  _cancelled = YES;
}

- (BOOL)close:(NSError **)error {
  if (_open) {
    BOOL closed = [_processor close:error];
    _open = NO;
    return closed;
  }
  return NO;
}  

@end
