//
//  FFPlayerView.h
//  Steer
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"

@interface FFPlayerView : GHGLView {
  UILabel *_displayLabel;
  
  NSString *_URLString;
  NSString *_format;
}

@property (retain, nonatomic) NSString *URLString;
@property (retain, nonatomic) NSString *format;

- (void)play;

@end
