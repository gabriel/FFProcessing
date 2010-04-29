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

@synthesize URLString=_URLString, format=_format;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    
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

- (void)play {  
  NSAssert(_URLString, @"Must set URLString");
  FFReader *reader = [[FFReader alloc] initWithURL:[NSURL URLWithString:_URLString] format:_format];    
  FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithReader:reader];
  [reader release];
  /*!
  FFGLTestDrawable *drawable = [[FFGLTestDrawable alloc] init];
  */
  self.drawable = drawable;
  [drawable release];    
  
  [self startAnimation];
}

@end
