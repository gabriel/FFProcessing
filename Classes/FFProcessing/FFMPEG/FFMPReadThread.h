//
//  FFMPReadThread.h
//  FFProcessing
//
//  Created by Gabriel Handford on 3/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"
#import "FFMPDecoder.h"
#import "FFReading.h"

@interface FFMPReadThread : NSThread <FFReading> {

  AVFrame *_avFrame;  
  FFVFrameRef _frame;

  NSInteger _readPictureIndex;
  NSInteger _readIndex;

  FFMPDecoder *_decoder;
  NSURL *_URL;
  NSString *_formatName;
  
  NSLock *_lock;
}

- (id)initWithURL:(NSURL *)URL formatName:(NSString *)formatName;

- (FFVFormat)format;

- (BOOL)readFrame:(FFVFrameRef)frame;

- (void)close;

@end
