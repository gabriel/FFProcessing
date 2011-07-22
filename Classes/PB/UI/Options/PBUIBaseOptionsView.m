//
//  PBUIBaseOptionsView.m
//  FFProcessing
//
//  Created by Gabriel Handford on 7/6/10.
//  Copyright 2010 All rights reserved.
//

#import "PBUIBaseOptionsView.h"

#import "PBUIModeNavigationView.h"

@implementation PBUIBaseOptionsView

@synthesize optionsDelegate=_optionsDelegate, contentView=_contentView, display=_display;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.opaque = NO;
    _contentView.backgroundColor = [UIColor clearColor];
    _display = YES;
    [self addSubview:_contentView];
  }
  return self;
}

- (void)dealloc {
  [_titleLabel release];
  [_contentView release];
  [super dealloc];
}

- (void)setTitle:(NSString *)title {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.opaque = NO;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.contentMode = UIViewContentModeCenter;
    [self addSubview:_titleLabel];
  }
  _titleLabel.text = title;
  [self setNeedsLayout];
}

- (NSString *)title {
  return _titleLabel.text;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  CGFloat y = 0;
  if (_titleLabel) {
    _titleLabel.frame = CGRectMake(0, 0, self.yk_width, 44);
    y += 44;
  }
  _contentView.frame = CGRectMake(0, y, self.yk_width, self.yk_height - y);
}

- (void)update { }

@end
