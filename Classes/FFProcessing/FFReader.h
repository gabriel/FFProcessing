//
//  FFReader.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReadThread.h"
#import "FFConverter.h"

@protocol FFReader <NSObject>
- (FFVFrameRef)nextFrame:(NSError **)error;
- (void)close;
@end

@interface FFReader : NSObject <FFReader> {
  FFReadThread *_readThread;
  FFConverter *_converter;
  
  FFVFrameRef _frame;
  
  BOOL _started;
}

- (id)initWithURL:(NSURL *)URL format:(NSString *)format;

- (FFVFrameRef)nextFrame:(NSError **)error;

@end
