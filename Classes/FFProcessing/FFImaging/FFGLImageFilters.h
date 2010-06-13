//
//  FFGLImageFilters.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/12/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLCommon.h"

// t [0..2]
void FFGLBrightness(TexturedVertexData2D *quad, float t);

// t [0..2]
void FFGLContrast(TexturedVertexData2D *quad, float t);

// t = 1 for standard perceptual weighting
void FFGLGreyscale(TexturedVertexData2D *quad, float t);

 // t [0..2]
void FFGLExtrapolate(TexturedVertexData2D quad[4], float t, 
                     GLuint scratchFBO, Texture *half, Texture *degen, Texture *scratch);

// t [0..2] == [-180..180] degrees
void FFHue(TexturedVertexData2D *quad, float t);

// t = 1
void FFBlur(TexturedVertexData2D quad[4], float t, Texture *input, Texture *half);
