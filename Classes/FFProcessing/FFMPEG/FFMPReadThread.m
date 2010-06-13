//
//  FFMPReadThread.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFMPReadThread.h"

#import "FFUtils.h"
#import "FFMPUtils.h"

@implementation FFMPReadThread

- (id)init {
  if ((self = [super init])) {
    self.name = @"FFMPReadThread";
    _decoder = [[FFMPDecoder alloc] init];
    _readPictureIndex = 0;
    _readIndex = 0;
    _frame = NULL;
    _lock = [[NSLock alloc] init];
  }
  return self;
}

- (id)initWithURL:(NSURL *)URL formatName:(NSString *)formatName {
  if ((self = [self init])) {
    _URL = [URL retain];
    _formatName = [formatName retain];
  }
  return self;
}

- (void)dealloc {
  [_decoder release];
  [_URL release];
  [_formatName release];
  [_lock release];
  FFVFrameRelease(_frame);
  [super dealloc];
}

- (void)close {
  NSAssert(self != [NSThread currentThread], @"Can't close from same thread");
    
  [self cancel];
  while (![self isFinished]) {
    [NSThread sleepForTimeInterval:0.05];
  }
}

- (FFVFormat)format {
  NSAssert(_decoder.options, @"Must have decoder options set");
  return _decoder.options.format;
}

- (BOOL)readFrame:(FFVFrameRef)frame {
  if (_frame == NULL || _readIndex == _readPictureIndex) {
    return NO;
  }

  [_lock lock];
  FFVFrameCopy(_frame, frame);
  _readIndex = _readPictureIndex;
  [_lock unlock];
  return YES;
}

- (void)main {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  FFDebug(@"Started");
  
  if (![_decoder openWithURL:_URL format:_formatName error:nil]) {
    FFDebug(@"Error opening player");
    // TODO(gabe): Handle error
  }
  
  if ([_decoder isOpen]) {
    // Frame decoded from video stream (before conversion)
    _avFrame = avcodec_alloc_frame();
    // TODO(gabe): if (_frame == NULL)  

    FFVFormat format = self.format;
    if (_frame == NULL)
      _frame = FFVFrameCreate(self.format);
    
    while (![self isCancelled]) {  
      NSError *error = nil;
      // Note: This may block on http streaming
      [_decoder decodeAVFrame:_avFrame error:&error];    
      if (error)
        break;
      
      if (_avFrame != NULL) {
        [_lock lock];
        FFVFrameCopyFromAVFrame(_frame, _avFrame, format);
        _readPictureIndex++;
        [_lock unlock];
      }
    }
    FFDebug(@"Cancelled");
    
    [_lock lock];    
    av_free(_avFrame);    
    _avFrame = NULL;
    [_lock unlock];
  }
  
  FFDebug(@"Stopped");
  [pool release];  
}


@end
