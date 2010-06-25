//
//  YKUIActivityLabel.h
//  YelpKit
//
//  Created by Gabriel Handford on 4/6/10.
//  Copyright 2010. All rights reserved.
//

@interface YKUIActivityLabel : UIView {
  UILabel *_textLabel;
  UILabel *_detailLabel;
  UIActivityIndicatorView *_activityIndicator;
  UIImageView *_imageView;
}

@property (readonly, nonatomic) UILabel *textLabel;
@property (readonly, nonatomic) UILabel *detailLabel;
@property (readonly, nonatomic) UIImageView *imageView;

/*!
 Set image to display when not animating.
 By default no image is shown.
 */
- (void)setImage:(UIImage *)image;

- (void)startAnimating;

- (void)stopAnimating;

@end
