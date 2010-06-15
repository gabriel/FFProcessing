//
//  FFGLImaging.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/13/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLCommon.h"


@interface FFGLImaging : NSObject {

  // Framebuffer objects
  GLuint _systemFBO;
  GLuint _degenFBO;
  GLuint _scratchFBO;

  TextureSize _texSize;
  TextureCoord3D _texCoord;

  // Textures used for filtering
  Texture _half;
  Texture _degen;
  Texture _scratch;
}

- (id)initWithTextureSize:(TextureSize)texSize textureCoord:(TextureCoord3D)texCoord;

- (void)brightness:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)contrast:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)greyscale:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)extrapolate:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)hue:(TexturedVertexData2D[4])quad amount:(float)amount;

- (void)blur:(TexturedVertexData2D[4])quad amount:(float)amount;

@end
