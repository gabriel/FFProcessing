//
//  FFAVFrameQueue.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"
#import "FFConverter.h"

@interface FFAVFrameQueue : NSObject {
  FFDecoder *_decoder;
  FFConverter *_converter;
  
  NSLock *_lock;
  
  NSURL *_URL;
  NSString *_format;
  
  AVFrame *_frame;
  NSInteger _frameIndex;
  NSInteger _readFrameIndex;
  
  uint8_t *_videoData;
  int _videoDataSize;
  
  BOOL _started;
  BOOL _running;
  BOOL _retryOnOpenFailure;
}

@property (readonly) FFDecoder *decoder;
@property (readonly, nonatomic) FFConverter *converter;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format;

- (uint8_t *)nextData;

@end
