//
//  FFReadThread.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"

@interface FFReadThread : NSThread {
  AVFrame *_frame;
  AVFrame *_picture;

  NSInteger _readPictureIndex;
  NSInteger _readIndex;

  FFDecoder *_decoder;
  NSURL *_URL;
  NSString *_format;
  
  NSLock *_lock;
}

- (FFDecoder *)decoder;

- (AVFrame *)createPicture;

- (BOOL)readPicture:(AVFrame *)picture;

- (void)close;

@end
