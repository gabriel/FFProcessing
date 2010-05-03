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
  
  FFPictureFrame _pictureFrame;
  
  BOOL _started;
}

- (id)initWithURL:(NSURL *)URL format:(NSString *)format;

- (FFPictureFrame)nextFrame:(NSError **)error;

@end
