//
//  FFGLImageEncoder.m
//  FFProcessing
//
//  Created by Gabriel Handford on 6/16/10.
//  Copyright 2010. All rights reserved.
//

#import "FFGLImageEncoder.h"

#import "GHGLUtils.h"
#import "FFUtils.h"

@implementation FFGLImageEncoder

- (id)initWithWidth:(GLsizei)width height:(GLsizei)height {
  if ((self = [super init])) {
    _width = width;
    _height = height;
    _length = (_width * _height * 4);
    _buffer = (GLubyte *)malloc(_length);
    _colorSpace = CGColorSpaceCreateDeviceRGB();
  }
  return self;
}

- (void)dealloc {
  free(_buffer);
  CGColorSpaceRelease(_colorSpace);
  [super dealloc];
}

- (void)GLReadPixels {
  glReadPixels(0, 0, _width, _height, GL_BGRA, GL_UNSIGNED_BYTE, _buffer);
}

- (CGImageRef)createImageFromGL {
  [self GLReadPixels];
  return GHGLCreateImageFromBuffer(_buffer, _length, _width, _height, _colorSpace);  
  // NSData *data = UIImageJPEGRepresentation(image, 1.0);
}

- (void)writeToPhotosAlbum {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  FFDebug(@"Creating image");
  CGImageRef imageRef = [self createImageFromGL];
  UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
  FFDebug(@"Writing image to photo album");
  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil); 
  FFDebug(@"Done");
  [image release]; 
  CGImageRelease(imageRef);
  [pool release];
}

@end
