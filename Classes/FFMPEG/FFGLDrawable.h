//
//  FFGLDrawable.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "FFReader.h"

@interface FFGLDrawable : NSObject <GHGLViewDrawable> {
  
  FFReader *_reader;
  
  GLuint _videoTexture[1];
  BOOL _textureLoaded;

}

- (id)initWithReader:(FFReader *)reader;

@end
