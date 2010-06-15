//
//  FFGLTestDrawable.m
//  FFMP
//
//  Created by Gabriel Handford on 3/7/10.
//  Copyright 2010. All rights reserved.
//

#import "FFGLTestDrawable.h"
#import "GHGLUCommon.h"

@implementation FFGLTestDrawable

- (void)dealloc {
  [_texture release];
  [super dealloc];
}

- (void)setupView:(GHGLView *)view {
  
  _texture = [[GHGLTexture alloc] initWithName:@"test.png"];
  
  glViewport(0, 0, view.backingWidth, view.backingHeight);
	glMatrixMode(GL_PROJECTION);
  
	glLoadIdentity();
  
	glOrthof(0, view.backingWidth, view.backingHeight, 0, -100, 100);
	glMatrixMode(GL_MODELVIEW);
  
}

- (void)start { }
- (void)stop { }

- (BOOL)drawView:(GHGLView *)view {
  
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
	glLoadIdentity();  
  
  CGRect rect = CGRectMake(0, 20, 64, 64);  
  
  [_texture drawInRect:rect];
  
  return YES;
}

@end
