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

@synthesize filter=_filter;

- (id)initWithReader:(id<FFReader>)reader filter:(id<FFFilter>)filter {
  if ((self = [self init])) {
    _reader = [reader retain];
    _filter = [filter retain];
    _GLFormat = GL_BGRA;
  }
  return self;
}

- (void)dealloc {
  [_imaging release];
  [_imageEncoder release];
  [_reader release];
  [_filter release];
  [super dealloc];
}

- (void)start { }

- (void)stop {
  [_reader close];
}

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions {
  _imagingOptions = imagingOptions;
}

- (void)setupView:(GHGLView *)view {
  [super setupView:view];
  TextureSize texSize = {(GLsizei)view.frame.size.width, (GLsizei)view.frame.size.height};
  TextureCoord3D texCoord = {1, 1}; 
  _imaging = [[FFGLImaging alloc] initWithTextureSize:texSize textureCoord:texCoord];
  _imageEncoder = [[FFGLImageEncoder alloc] initWithWidth:texSize.wide height:texSize.high format:_GLFormat];
}

- (BOOL)drawView:(GHGLView *)view {
  NSAssert(_reader, @"No reader");

  FFVFrameRef frame = [_reader nextFrame:nil];
  if (frame == NULL) return NO;
  
  if (_filter) {
    frame = [_filter filterFrame:frame error:nil];
    if (frame == NULL) return NO;
  }
  
  uint8_t *data = FFVFrameGetData(frame, 0);
  FFVFormat format = FFVFrameGetFormat(frame);
  // TODO(gabe): Assert (pixel) format is correct for our GL setup
  if (data == NULL) return NO;
  
  //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);	
	glLoadIdentity();
  
  glBindTexture(GL_TEXTURE_2D, _texture);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  // You have to do clamp to edge to support NPOT textures
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  
  if (!_textureLoaded) {
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, format.width, format.height, 0, _GLFormat, GL_UNSIGNED_BYTE, data);        
    _textureLoaded = YES;
    FFDebug(@"Texture loaded");
  } else {
    glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, format.width, format.height, _GLFormat, GL_UNSIGNED_BYTE, data);
  }
  
  GHGLCheckError();

  CGRect texRect = CGRectMake(0, 0, view.frame.size.height, view.frame.size.width); // TODO(gabe): ??
  
  TexturedVertexData2D quad[4] = {
    {{texRect.origin.y, texRect.origin.x}, {0, 1}},
    {{texRect.origin.y, texRect.origin.x + texRect.size.width}, {1, 1}},
    {{texRect.origin.y + texRect.size.height, texRect.origin.x}, {0, 0}},
    {{texRect.origin.y + texRect.size.height, texRect.origin.x + texRect.size.width}, {1, 0}}
  };
  
  glBindTexture(GL_TEXTURE_2D, _texture);
  glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);	  
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  [_imaging apply:quad options:_imagingOptions];
  
  /*
  [_imageEncoder GLReadPixels];
  if (_frameCount == 30) {
    [_imageEncoder writeToPhotosAlbum];    
  }
   */
  
  _frameCount++;
  return YES;
}

@end
