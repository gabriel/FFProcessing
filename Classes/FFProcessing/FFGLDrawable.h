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
#import "FFGLImaging.h"
#import "FFGLImageEncoder.h"

@interface FFGLDrawable : GHGLViewDrawable {
  
  id<FFReader> _reader;
  id<FFFilter> _filter;
  
  GLint _GLFormat; // For example, GL_RGB, GL_BGRA
  
  FFGLImaging *_imaging;
  
  NSUInteger _frameCount;
  FFGLImageEncoder *_imageEncoder;

}

- (id)initWithReader:(id<FFReader>)reader filter:(id<FFFilter>)filter;

@end
