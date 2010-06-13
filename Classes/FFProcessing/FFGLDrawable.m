//
//  FFGLDrawable.m
//  FFMP
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
    _GLFormat = GL_BGRA;
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

- (BOOL)drawView:(CGRect)rect inView:(GHGLView *)view {
  NSAssert(_reader, @"No reader");

  BOOL debugFrame = NO;
#if DEBUG
  static NSInteger DebugCount = 0;
  if (DebugCount++ % 30 == 0) debugFrame = YES;
  if (debugFrame) FFDebug(@"[DEBUG FRAME]");
#endif
  
  FFVFrameRef frame = [_reader nextFrame:nil];
  if (frame == NULL) return NO;
  
  if (_filter) {
    if (debugFrame) FFDebug(@"Applying filter...");
    frame = [_filter filterFrame:frame error:nil];
    if (frame == NULL) return NO;
  }
  
  uint8_t *data = FFVFrameGetData(frame, 0);
  FFVFormat format = FFVFrameGetFormat(frame);
  // TODO(gabe): Assert (pixel) format is correct for our GL setup
  if (data == NULL) return NO;
    
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
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, format.width, format.height, 0, _GLFormat, GL_UNSIGNED_BYTE, data);    
  } else {
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, format.width, format.height, _GLFormat, GL_UNSIGNED_BYTE, data);
  }
  
  GHGLCheckError();

  if (!_textureLoaded) {
    FFDebug(@"Texture loaded");
    _textureLoaded = YES;
  }
  
  // Portrait
  //[self drawInRect:rect];
  // Landscape
  //FFDebug(@"Draw, rect=%@", NSStringFromCGRect(rect));
  [self drawInRect:CGRectMake(0, 0, rect.size.height, rect.size.width)]; // TODO(gabe): ?? 
  return YES;
}

@end
