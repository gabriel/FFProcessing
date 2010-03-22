//
//  FFGLDrawable.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "FFAVFrameQueue.h"

@interface FFGLDrawable : NSObject <GHGLViewDrawable> {
  
  FFAVFrameQueue *_frameQueue;
  
  GLuint _videoTexture[1];
  BOOL _textureLoaded;

}

- (id)initWithFrameQueue:(FFAVFrameQueue *)frameQueue;

@end
