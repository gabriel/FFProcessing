//
//  FFReadThread.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFDecoder.h"

@interface FFReadThread : NSThread {

  AVFrame *_avFrame;  
  FFVFrameRef _frame;

  NSInteger _readPictureIndex;
  NSInteger _readIndex;

  FFDecoder *_decoder;
  NSURL *_URL;
  NSString *_formatName;
  
  NSLock *_lock;
}

- (id)initWithURL:(NSURL *)URL formatName:(NSString *)formatName;

//- (FFDecoder *)decoder;

- (FFVFormat)format;

- (BOOL)readFrame:(FFVFrameRef)frame;

- (void)close;

@end
