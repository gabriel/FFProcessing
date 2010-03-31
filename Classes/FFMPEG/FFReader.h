//
//  FFReader.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReadThread.h"
#import "FFConverter.h"

@interface FFReader : NSObject {
  FFReadThread *_readThread;
  FFConverter *_converter;
  
  AVFrame *_picture;
  
  BOOL _started;
}

@property (readonly, nonatomic) FFConverter *converter;

- (id)initWithURL:(NSURL *)URL format:(NSString *)format;

- (AVFrame *)nextFrame:(NSError **)error;

@end
