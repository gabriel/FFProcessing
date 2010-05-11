//
//  FFGLDrawable.h
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "FFReader.h"

@interface FFGLDrawable : GHGLViewDrawable {
  
  id<FFReader> _reader;
  id<FFFilter> _filter;
  
  GLint _format; // For example, GL_RGB, GL_BGRA

}

- (id)initWithReader:(id<FFReader>)reader filter:(id<FFFilter>)filter;

@end
