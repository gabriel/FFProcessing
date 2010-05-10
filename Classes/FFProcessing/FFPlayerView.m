//
//  FFProcessingView.m
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerView.h"
#import "FFUtils.h"

#import "FFReader.h"
#import "FFGLDrawable.h"


#import "FFGLTestDrawable.h"

@implementation FFPlayerView

- (id)initWithFrame:(CGRect)frame reader:(id<FFReader>)reader filter:(id<FFFilter>)filter {
  if ((self = [self initWithFrame:frame])) {
    
    FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithReader:reader filter:filter];
    // FFGLTestDrawable *drawable = [[FFGLTestDrawable alloc] init];
    self.drawable = drawable;
    [drawable release];      

    /*!
    _displayLabel = [[UILabel alloc] initWithFrame:CGRectMake(-145, 240, 320, 30)];
    _displayLabel.textColor = [UIColor whiteColor];
    _displayLabel.backgroundColor = [UIColor blackColor];
    _displayLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _displayLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    [self addSubview:_displayLabel];
     */
  
    [self setAnimationInterval:(1.0 / 10.0)];  
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_displayLabel release];
  [super dealloc];
}

- (void)_onDisplay:(NSNotification *)notification {
  NSString *text = [notification object];
  FFDebug(@"%@", text);
  _displayLabel.hidden = NO;
  _displayLabel.text = text;
}

- (void)_onOpened {
  _displayLabel.hidden = YES;
}

- (void)start {    
  [self startAnimation];
}

- (void)stop {
  [self stopAnimation];
}

@end
