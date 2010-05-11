//
//  GHGLUtils.h
//  FFProcessing
//
//  Created by Gabriel Handford on 5/10/10.
//  Copyright 2010. All rights reserved.
//

#import <OpenGLES/ES1/gl.h>

/*!
 Next power of two. Used for padding GL textures.
 */
NSUInteger GHGLNextPOT(NSUInteger x);

extern NSString *const GHGLExtension_GL_APPLE_texture_2D_limited_npot;
extern NSString *const GHGLExtension_GL_IMG_texture_format_BGRA8888;

BOOL GHGLCheckForExtension(NSString *name);

NSString *GHGLErrorDescription(GLenum error);

@interface GHGLUtils : NSObject {

}

@end
