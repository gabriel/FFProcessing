//
//  FFProcessingView.h
//  Steer
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "FFReader.h"

@interface FFPlayerView : GHGLView {
  UILabel *_displayLabel;  
}

- (id)initWithFrame:(CGRect)frame reader:(id<FFReader>)reader filter:(id<FFFilter>)filter;

- (void)start;

- (void)stop;

@end
