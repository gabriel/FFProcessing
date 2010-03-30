//
//  FFAVFrameQueue.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFAVFrameQueue.h"
#import "FFDefines.h"

@implementation FFAVFrameQueue

@synthesize decoder=_decoder, converter=_converter;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format {
  if ((self = [self init])) {
    _URL = [URL retain];
    _format = [format retain];
    _lock = [[NSLock alloc] init];
    _frame = NULL;
    _videoData = NULL;
  }
  return self;
}

- (void)dealloc {
  _running = NO;
  [_decoder release];
  [_converter release];
  [_URL release];
  [_format release];
  [_lock release];
  if (_videoData != NULL) av_free(_videoData);
  [super dealloc];
}

- (void)_run {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
  _running = YES;
  FFDebug(@"Started");
    
  // TODO(gabe): Must be power of 2 for texture
  FFDecoder *decoder = [[FFDecoder alloc] init];
  
  while (![decoder isOpen] && _running) {    
    if (![decoder openWithURL:_URL format:_format error:nil]) {
      if (_retryOnOpenFailure) {
        FFDebug(@"Error opening player, waiting & trying again");
        [NSThread sleepForTimeInterval:2];
      } else {
        FFDebug(@"Error opening player");
        break;
      }
    }
  }

  if ([decoder isOpen]) {
    // Frame decoded from video stream (before conversion)
    _frame = avcodec_alloc_frame();
    // TODO(gabe): if (_frame == NULL)  
    
    _decoder = decoder;
    
    while (_running) {  
      NSError *error = nil;
      // TODO(gabe): How is this working if I am not locking around this call?
      [_decoder decodeFrame:_frame error:&error];    
      if (error)
        break;

      _readFrameIndex++;
    }
    
    av_free(_frame);    
  }
  
  _running = NO;
  //_started = NO;
  FFDebug(@"Stopped");
  [pool release];  
}

- (uint8_t *)nextData {  
  if (!_started) {
    _started = YES;    
    [NSThread detachNewThreadSelector:@selector(_run) toTarget:self withObject:nil];          
  }
  
  if (![_decoder isOpen]) return NULL;
  if (_frame == NULL) return NULL;
  
  if (!_converter) {
    _converter = [[FFConverter alloc] initWithSourceWidth:[_decoder videoWidth]
                                             sourceHeight:[_decoder videoHeight]
                                        sourcePixelFormat:[_decoder videoPixelFormat]
                                                destWidth:256
                                               destHeight:256
                                          destPixelFormat:PIX_FMT_RGB24
                                                    error:nil]; // TODO(gabe): Handle error

    _videoDataSize = [_converter destBufferLength];
    _videoData = (uint8_t*)av_malloc(_videoDataSize * sizeof(uint8_t));    
  }
  
  if (_readFrameIndex == _frameIndex) {
    //FFDebug(@"Skipping, frame unchanged");
    return NULL;
  }

  [_lock lock];
  AVFrame *frame = [_converter scaleFrame:_frame error:nil];
  memcpy(_videoData, frame->data[0], _videoDataSize);
  _frameIndex = _readFrameIndex;
  [_lock unlock];
  return _videoData;
}

@end
