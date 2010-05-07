//
//  FFReadThread.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReadThread.h"

#import "FFUtils.h"

@implementation FFReadThread

- (id)init {
  if ((self = [super init])) {
    self.name = @"FFReadThread";
    _decoder = [[FFDecoder alloc] init];
    _readPictureIndex = 0;
    _readIndex = 0;
    _frame = NULL;
    _lock = [[NSLock alloc] init];
  }
  return self;
}

- (id)initWithURL:(NSURL *)URL format:(NSString *)format {
  if ((self = [self init])) {
    _URL = [URL retain];
    _format = [format retain];
  }
  return self;
}

- (void)dealloc {
  [_decoder release];
  [_URL release];
  [_format release];
  [_lock release];
  [super dealloc];
}

- (void)close {
  NSAssert(self != [NSThread currentThread], @"Can't close from same thread");
    
  [self cancel];
  while (![self isFinished]) {
    [NSThread sleepForTimeInterval:0.05];
  }
}

- (FFDecoder *)decoder {
  return _decoder;
}

- (FFAVFrame)createPictureFrame {
  if (!_decoder) return FFAVFrameNone;
  return FFAVFrameCreate(_decoder.options.avFormat);
}

- (BOOL)readPicture:(AVFrame *)picture {
  if (_avFrame.frame == NULL || _readIndex == _readPictureIndex) {
    return NO;
  }

  [_lock lock];
  av_picture_copy((AVPicture *)picture, (AVPicture *)_avFrame.frame, _avFrame.avFormat.pixelFormat, 
                  _avFrame.avFormat.width, _avFrame.avFormat.height);
  _readIndex = _readPictureIndex;
  [_lock unlock];
  return YES;
}

- (void)main {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  FFDebug(@"Started");
  
  if (![_decoder openWithURL:_URL format:_format error:nil]) {
    FFDebug(@"Error opening player");
    // TODO(gabe): Handle error
  }
  
  if ([_decoder isOpen]) {
    // Frame decoded from video stream (before conversion)
    _frame = avcodec_alloc_frame();
    // TODO(gabe): if (_frame == NULL)  
    
    _avFrame = [self createPictureFrame];
    
    while (![self isCancelled]) {  
      NSError *error = nil;
      // Note: This may block on http streaming
      [_decoder decodeVideoFrame:_frame error:&error];    
      if (error)
        break;
      
      if (_frame != NULL) {
        [_lock lock];
        av_picture_copy((AVPicture *)_avFrame.frame, (AVPicture *)_frame, _avFrame.avFormat.pixelFormat, 
                        _avFrame.avFormat.width, _avFrame.avFormat.height);
        _readPictureIndex++;
        [_lock unlock];
      }
    }
    FFDebug(@"Cancelled");
    
    [_lock lock];
    av_free(_frame);    
    _frame = NULL;
    FFAVFrameRelease(_avFrame);
    [_lock unlock];
  }
  
  FFDebug(@"Stopped");
  [pool release];  
}


@end
