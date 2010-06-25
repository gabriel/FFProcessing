//
//  YKUIGridView.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 6/23/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIView.h"
#import "YKUIControl.h"

@interface YKUIGridView : YKUIView <UIScrollViewDelegate> {
  NSInteger _columnCount;
  NSInteger _rowCount;
  
  NSMutableArray *_views;
  UIScrollView *_scrollView;

  UIEdgeInsets _insets;
}

@property (assign, nonatomic) UIEdgeInsets insets;

- (id)initWithFrame:(CGRect)frame rowCount:(NSUInteger)rowCount columnCount:(NSUInteger)columnCount;

- (void)addView:(UIView *)view;

@end


@interface YKUIGridButton : YKUIControl { 
  UILabel *_label;
  UIImageView *_imageView;
  
  BOOL _widthRestricted;
}

@property (readonly, nonatomic) UILabel *label;
@property (readonly, nonatomic) UIImageView *imageView;
@property (assign, nonatomic, getter=isWidthRestricted) BOOL widthRestricted; //! If YES width is restricted to image width; Defaults to YES

- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

@end