//
//  FFGLImaging.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/13/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "GHGLCommon.h"


@interface FFGLImaging : NSObject {

  // Framebuffer objects
  GLuint _systemFBO;
  GLuint _degenFBO;
  GLuint _scratchFBO;

  // Textures used for filtering
  Texture *_input;
  Texture *_half;
  Texture *_degen;
  Texture *_scratch;
}

- (void)initWithTexture:(Texture *)texture;

@end
