//
//  FFProcessing.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/21/10.
//  Copyright 2010. All rights reserved.
//

#import "FFProcessing.h"

#import "FFUtils.h"
#import "FFMPUtils.h"

@interface FFProcessing ()
- (BOOL)_processAtIndex:(NSInteger)index count:(NSInteger)count error:(NSError **)error;
@end

@implementation FFProcessing

@synthesize delegate=_delegate, cancelled=_cancelled;

- (id)initWithDecoder:(id<FFDecoder>)decoder processor:(id<FFProcessor>)processor filter:(id<FFFilter>)filter {
  if ((self = [super init])) {
    _decoder = [decoder retain];
    _processor = [processor retain];
    _filter = [filter retain];
  }
  return self;
}

- (void)dealloc {
  [self close:nil];
  [_decoder release];
  [_processor release];
  [_filter release];
  [super dealloc];
}

- (BOOL)_openDecoder:(NSURL *)URL format:(NSString *)format error:(NSError **)error {    
  if (![_decoder openWithURL:URL format:format error:error]) {
    return NO;
  }
  
  return YES;
}

- (void)_closeDecoder {
  [_decoder close];
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
  _frame = FFVFrameCreateWithData(format, NULL);

  while (!_cancelled) {
    *error = nil;
    
    if (![_decoder decodeFrame:_frame error:error]) {
      if (*error) {
        FFDebug(@"Decode error");
        break;
      }
      continue;
    }
        
    _frame->pts += _previousEndPTS;
    
    [_delegate processing:self didReadFramePTS:[_decoder readVideoPTS] duration:[_decoder videoDuration] 
                    index:index count:count];
    
    // Apply filter
    if (_filter) {
      _frame = [_filter filterFrame:_frame error:error];
      if (_frame == NULL) break;
    }

    // Run processor
    if (![_processor processFrame:_frame decoder:_decoder index:index error:error])
      break;
  }
  
  if (_frame)
    _previousEndPTS = [_decoder readVideoPTS] + 1; // TODO(gabe): Fix me
  
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
