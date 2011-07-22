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
  
  NSMutableArray *_controls;
  UIScrollView *_scrollView;

  UIEdgeInsets _insets;
}

@property (assign, nonatomic) UIEdgeInsets insets;
@property (readonly, nonatomic) NSArray *controls;

- (id)initWithFrame:(CGRect)frame rowCount:(NSUInteger)rowCount columnCount:(NSUInteger)columnCount;

- (void)addControl:(YKUIControl *)control;

/*!
 Sets selected NO on all controls except the one with the specified tag.
 @param tag
 */
- (void)setSelected:(NSInteger)tag;

/*!
 @param tag Tag to check
 @result YES if control with tag is selected.
 */
- (BOOL)isSelected:(NSInteger)tag;

/*!
 Clear selected.
 Calls setSelected with NSNotFound.
 */
- (void)clearSelected;

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