//
//  GHGLUtils.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/10/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLDefines.h"
#import "GHGLUtils.h"

NSUInteger GHGLNextPOT(NSUInteger x) {
	x = x - 1;
	x = x | (x >> 1);
	x = x | (x >> 2);
	x = x | (x >> 4);
	x = x | (x >> 8);
	x = x | (x >>16);
	return x + 1;
}

NSString *const GHGLExtension_GL_APPLE_texture_2D_limited_npot = @"GL_APPLE_texture_2D_limited_npot";
NSString *const GHGLExtension_GL_IMG_texture_format_BGRA8888 = @"GL_APPLE_texture_format_BGRA8888";

BOOL GHGLCheckForExtension(NSString *name) {
  static NSArray *ExtensionNames = NULL;
  if (ExtensionNames == NULL) {
    NSString *extensionsString = [NSString stringWithCString:(char *)glGetString(GL_EXTENSIONS) encoding:NSASCIIStringEncoding];
    ExtensionNames = [[extensionsString componentsSeparatedByString:@" "] retain];
    //GHGLDebug(@"Extension names: %@", ExtensionNames);
  }
  return [ExtensionNames containsObject:name];
}

NSString *GHGLErrorDescription(GLenum GLError) {
  switch (GLError) {
    case GL_INVALID_ENUM: return [NSString stringWithFormat:@"GL_INVALID_ENUM (%d)", GLError];
    case GL_INVALID_VALUE: return [NSString stringWithFormat:@"GL_INVALID_VALUE (%d)", GLError];
    case GL_INVALID_OPERATION: return [NSString stringWithFormat:@"GL_INVALID_OPERATION (%d)", GLError];
    case GL_STACK_OVERFLOW: return [NSString stringWithFormat:@"GL_STACK_OVERFLOW (%d)", GLError];
    case GL_STACK_UNDERFLOW: return [NSString stringWithFormat:@"GL_STACK_UNDERFLOW (%d)", GLError];
    case GL_OUT_OF_MEMORY: return [NSString stringWithFormat:@"GL_OUT_OF_MEMORY (%d)", GLError];
    default:
      return [NSString stringWithFormat:@"Unkown (%d)", GLError];
  }
}

@implementation GHGLUtils

@end
