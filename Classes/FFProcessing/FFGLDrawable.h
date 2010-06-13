//
//  FFGLDrawable.h
//  FFMP
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "FFReader.h"
#import "FFFilter.h"

@interface FFGLDrawable : GHGLViewDrawable {
  
  id<FFReader> _reader;
  id<FFFilter> _filter;
  
  GLint _GLFormat; // For example, GL_RGB, GL_BGRA

}

- (id)initWithReader:(id<FFReader>)reader filter:(id<FFFilter>)filter;

@end
