//
//  YKUIActivityLabel.m
//  YelpKit
//
//  Created by Gabriel Handford on 4/6/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIActivityLabel.h"
#import "GHNSString+Utils.h"
#import "YKCGUtils.h"
#import "YKLocalized.h"

@implementation YKUIActivityLabel

@synthesize textLabel=_textLabel, detailLabel=_detailLabel, imageView=_imageView;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _textLabel.text = YKLocalizedString(@"Loading...");
    _textLabel.font = [UIFont systemFontOfSize:16.0];
    _textLabel.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.contentMode = UIViewContentModeCenter;
    _textLabel.textAlignment = UITextAlignmentLeft;
    [self addSubview:_textLabel];
    [_textLabel release];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.hidesWhenStopped = YES;
    [self addSubview:_activityIndicator];
    [_activityIndicator release];  

    _imageView = [[UIImageView alloc] init];
    _imageView.hidden = YES;
    [self addSubview:_imageView];
    [_imageView release];
    
    [self setNeedsLayout];
  }
  return self;
}

- (void)layoutSubviews {  
  CGSize size = self.frame.size;
  CGFloat height = 20;  
  
  CGSize lineSize = [_textLabel.text sizeWithFont:_textLabel.font constrainedToSize:size
                                    lineBreakMode:UILineBreakModeTailTruncation];    
  
  if (![NSString gh_isBlank:_detailLabel.text]) height += 20;
  
  if (_activityIndicator.isAnimating || !_imageView.hidden) lineSize.width += 24;
  
  CGFloat x = YKCGFloatToCenter(lineSize.width, size.width, 0);
  CGFloat y = YKCGFloatToCenter(height, size.height, 0);
  
  _activityIndicator.frame = CGRectMake(x, y, 20, 20);
  if (_activityIndicator.isAnimating) x += 24;
  
  _imageView.frame = CGRectMake(x, y, 20, 20);
  if (!_imageView.hidden) x += 24;

  _textLabel.frame = CGRectMake(x, y, size.width, 20);
  y += 24;
  _detailLabel.frame = CGRectMake(0, y, size.width, 20);  
}

- (void)startAnimating {
  _imageView.hidden = YES;
  [_activityIndicator startAnimating];
}

- (void)stopAnimating {
  [_activityIndicator stopAnimating];
  if (_imageView.image)
    _imageView.hidden = NO;
}

- (void)setImage:(UIImage *)image {
  if (image) {
    _activityIndicator.hidden = YES;
    _imageView.hidden = NO;
    _imageView.image = image;
  } else {
    _activityIndicator.hidden = NO;
    _imageView.hidden = YES;
  }
  [self setNeedsDisplay];
}

- (UILabel *)detailLabel {
  if (!_detailLabel) {
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _detailLabel.font = [UIFont systemFontOfSize:14.0];
    _detailLabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    _detailLabel.textAlignment = UITextAlignmentCenter;
    _detailLabel.contentMode = UIViewContentModeCenter;
    [self addSubview:_detailLabel];
    [_detailLabel release];
    [self setNeedsLayout];
  }
  return _detailLabel;
}

@end
