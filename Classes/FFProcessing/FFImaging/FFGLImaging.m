//
//  FFGLImaging.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/13/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFGLImaging.h"

#import "GHGLUtils.h"

@implementation FFGLImaging

- (void)initWithTexture:(Texture *)texture {

  // Create 1x1 for default constant texture
	// To enable a texture unit, a valid texture has to be bound even if the combine modes do not access it
	GLubyte half[4] = {0x80, 0x80, 0x80, 0x80};	  
  _half->wide = 1;
  _half->high = 1;
	_half->s = 1.0;
  _half->t = 1.0;  
  glActiveTexture(GL_TEXTURE1);
  GHGLGenTexImage2D(_half, half);
	glActiveTexture(GL_TEXTURE0);
  
	// Remember the FBO being used for the display framebuffer
	glGetIntegerv(GL_FRAMEBUFFER_BINDING_OES, (GLint *)&_systemFBO);
  
	// Degen + FBO
  _degen->wide = texture->wide;
	_degen->high = texture->high;
	_degen->s = texture->s;
	_degen->t = texture->t;  
  GHGLGenTexImage2D(_degen, NULL);  
	glGenFramebuffersOES(1, &_degenFBO);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _degenFBO);
	glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, _degen->texID, 0);
	GHGLAssert(GL_FRAMEBUFFER_COMPLETE_OES == glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
	
  // Scratch + FBO
  _scratch->wide = texture->wide;
	_scratch->high = texture->high;
	_scratch->s = texture->s;
	_scratch->t = texture->t;  
  GHGLGenTexImage2D(_scratch, NULL);  
	glGenFramebuffersOES(1, &_scratchFBO);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _scratchFBO);
	glFramebufferTexture2DOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_TEXTURE_2D, _scratch->texID, 0);
  GHGLAssert(GL_FRAMEBUFFER_COMPLETE_OES == glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
  
  // Reset to system FBO
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, _systemFBO);
	
	GHGLCheckError();
}

@end
