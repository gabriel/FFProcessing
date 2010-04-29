//
//  FFGLDrawable.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "FFGLDrawable.h"
#import "FFUtils.h"


@implementation FFGLDrawable

- (id)initWithReader:(FFReader *)reader {
  if ((self = [self init])) {
    _reader = [reader retain];
  }
  return self;
}

- (void)dealloc {
  [_reader release];
  glDeleteTextures(1, &_videoTexture[0]);
  [super dealloc];
}

- (void)setupView:(GHGLView *)view {
  
  
  glViewport(0, 0, view.backingWidth, view.backingHeight);
	glMatrixMode(GL_PROJECTION);
  
	glLoadIdentity();
  
	glOrthof(0, view.backingWidth, view.backingHeight, 0, -100, 100);
	glMatrixMode(GL_MODELVIEW);
  
  glEnable(GL_TEXTURE_2D);
  glGenTextures(1, &_videoTexture[0]);
  
}

- (void)drawInRect:(CGRect)rect {
  
  // Portrait
  /*
  const GLfloat vertices[] = {
    rect.origin.x, rect.origin.y,
    rect.origin.x + rect.size.width, rect.origin.y,
    rect.origin.x, rect.origin.y + rect.size.height,
    rect.origin.x + rect.size.width, rect.origin.y + rect.size.height
	};
	
  // Coords flipped so we appear right side up
	const GLfloat texCoords[] = {
    0, 0,
    1, 0,
    0, 1,
    1, 1,
  };
   */
  
  // Landscape
  const GLfloat vertices[] = {
    rect.origin.y, rect.origin.x,
    rect.origin.y, rect.origin.x + rect.size.width,
    rect.origin.y + rect.size.height, rect.origin.x, 
    rect.origin.y + rect.size.height, rect.origin.x + rect.size.width,
	};
	
	const GLfloat texCoords[] = {
    0, 1,
    1, 1,
    0, 0,
    1, 0,
  };  
  
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, _videoTexture[0]);
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
  
}

- (BOOL)drawView:(CGRect)frame inView:(GHGLView *)view {

  /*!
  AVFrame *avframe = [_frameQueue next];
  if (avframe == NULL) {
    return NO;
  }
   */
  AVFrame *avFrame = [_reader nextFrame:nil];
  if (avFrame == NULL) return NO;

  uint8_t *nextData = avFrame->data[0];
  if (nextData == NULL) return NO;
    
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
	glLoadIdentity();

  glEnable(GL_TEXTURE_2D);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);  
  glBindTexture(GL_TEXTURE_2D, _videoTexture[0]);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  
  if (!_textureLoaded) {
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, _reader.converter.encoderOptions.width, _reader.converter.encoderOptions.height, 0, GL_RGB, GL_UNSIGNED_BYTE, nextData);
  } else {
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, _reader.converter.encoderOptions.width, _reader.converter.encoderOptions.height,
                    GL_RGB, GL_UNSIGNED_BYTE, nextData);
  }
  
  GLenum GLError = glGetError();
  if (GLError != GL_NO_ERROR) {
    FFDebug(@"GL error: %d", GLError);
    return NO;
  } else if (!_textureLoaded) {
    FFDebug(@"Texture loaded");
    _textureLoaded = YES;
  }
  
  // Portrait
  //[self drawInRect:frame];
  // Landscape
  [self drawInRect:CGRectMake(0, 0, frame.size.height, frame.size.width)]; // TODO(gabe): ?? 
  return YES;
}

@end
