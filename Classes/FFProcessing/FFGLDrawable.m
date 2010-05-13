//
//  FFGLDrawable.m
//  FFMPEG
//
//  Created by Gabriel Handford on 3/6/10.
//  Copyright 2010. All rights reserved.
//

#import "FFGLDrawable.h"
#import "FFUtils.h"
#import "GHGLUtils.h"


@implementation FFGLDrawable

- (id)initWithReader:(id<FFReader>)reader filter:(id<FFFilter>)filter {
  if ((self = [self init])) {
    _reader = [reader retain];
    _filter = [filter retain];
    _format = GL_BGRA;
  }
  return self;
}

- (void)dealloc {
  [_reader release];
  [_filter release];
  [super dealloc];
}

- (void)start { }

- (void)stop {
  [_reader close];
}

- (BOOL)drawView:(CGRect)frame inView:(GHGLView *)view {
  NSAssert(_reader, @"No reader");

  BOOL debugFrame = NO;
#if DEBUG
  static NSInteger DebugCount = 0;
  if (DebugCount++ % 30 == 0) debugFrame = YES;
  if (debugFrame) FFDebug(@"[DEBUG FRAME]");
#endif
  
  FFAVFrame avFrame = [_reader nextFrame:nil];
  if (avFrame.frame == NULL) return NO;
  
  if (_filter) {
    if (debugFrame) FFDebug(@"Applying filter...");
    avFrame = [_filter filterAVFrame:avFrame error:nil];
    if (avFrame.frame == NULL) return NO;
  }
  
  uint8_t *nextData = avFrame.frame->data[0];
  if (nextData == NULL) return NO;
    
  if (debugFrame) FFDebug(@"Rendering...");
  
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
	glLoadIdentity();

  glEnable(GL_TEXTURE_2D);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);  
  glBindTexture(GL_TEXTURE_2D, _videoTexture[0]);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  // You have to do clamp to edge to support NPOT textures
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  
  if (!_textureLoaded) {
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, avFrame.avFormat.width, avFrame.avFormat.height, 0, _format, GL_UNSIGNED_BYTE, nextData);    
  } else {
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, avFrame.avFormat.width, avFrame.avFormat.height,
                    _format, GL_UNSIGNED_BYTE, nextData);
  }
  
  GLenum GLError = glGetError();
  if (GLError != GL_NO_ERROR) {
    FFDebug(@"GL error: %@", GHGLErrorDescription(GLError));
    return NO;
  } else if (!_textureLoaded) {
    FFDebug(@"Texture loaded");
    _textureLoaded = YES;
  }
  
  // Portrait
  //[self drawInRect:frame];
  // Landscape
  //FFDebug(@"Draw, rect=%@", NSStringFromCGRect(frame));
  [self drawInRect:CGRectMake(0, 0, frame.size.height, frame.size.width)]; // TODO(gabe): ?? 
  return YES;
}

@end
