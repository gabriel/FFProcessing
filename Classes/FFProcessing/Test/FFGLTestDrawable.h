//
//  FFGLTestDrawable.h
//  FFMP
//
//  Created by Gabriel Handford on 3/7/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "GHGLTexture.h"

@interface FFGLTestDrawable : NSObject <GHGLViewDrawable> {
  GHGLTexture *_texture;
}

@end
