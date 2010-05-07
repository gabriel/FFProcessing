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
  id<FFReader> _reader;
}

- (id)initWithFrame:(CGRect)frame reader:(id<FFReader>)reader;

- (void)play;

- (void)stop;

@end
