//
//  YKUIGridView.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 6/23/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIGridView.h"
#import "YKDefines.h"

@implementation YKUIGridView

@synthesize insets=_insets, controls=_controls;

- (id)initWithFrame:(CGRect)frame {
  return [self initWithFrame:frame rowCount:3 columnCount:3];
}

- (id)initWithFrame:(CGRect)frame rowCount:(NSUInteger)rowCount columnCount:(NSUInteger)columnCount {
  if ((self = [super initWithFrame:frame])) {
    self.userInteractionEnabled = YES;
    
    _columnCount = columnCount;
    _rowCount = rowCount;
    _insets = UIEdgeInsetsMake(8, 8, 8, 8);

    _controls = [[NSMutableArray alloc] initWithCapacity:(rowCount * columnCount)];

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _scrollView.pagingEnabled = YES;    
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    [_scrollView release];
  }
  return self;
}

- (void)dealloc {
  [_controls release];
  [super dealloc];
}

- (void)addControl:(YKUIControl *)control {
  [_controls addObject:control];
  [_scrollView addSubview:control];
  [self setNeedsLayout];
}

- (void)setSelected:(NSInteger)tag {
  for (YKUIControl *control in _controls) {
    control.selected = (control.tag == tag);
  }
}

- (BOOL)isSelected:(NSInteger)tag {
  for (YKUIControl *control in _controls) {
    if (control.tag == tag) return control.isSelected;
  }
  return NO;
}

- (void)clearSelected {
  [self setSelected:NSNotFound];
}

- (void)layoutSubviews {
  
  CGFloat width = self.frame.size.width;
  CGFloat height = self.frame.size.height;
  CGFloat pageWidth = ceilf(width - _insets.left - _insets.right);
  CGFloat pageHeight = ceilf(height - _insets.left - _insets.right);
  
  NSInteger pageCount = (NSInteger)ceilf((float)[_controls count] / (float)(_rowCount * _columnCount));
  CGSize contentSize = CGSizeMake(pageWidth * pageCount, pageHeight);
  [_scrollView setContentSize:contentSize];    
  
  _scrollView.frame = CGRectMake(_insets.left, _insets.top, pageWidth, pageHeight);
  
  // No pages
  /*!
   _pageControl.frame = CGRectMake(0, height - 16, width, 16);
   _pageControl.numberOfPages = pageCount;
   _pageControl.currentPage = 0;  
   */
  
  NSInteger row = 0;
  NSInteger column = 0;
  CGFloat columnWidth = roundf(pageWidth / (float)_columnCount);
  CGFloat rowHeight = roundf(pageHeight / (float)_rowCount);
  
  CGFloat page = 0;  
  for (UIView *view in _controls) {
    view.frame = CGRectMake((page * width) + (column * columnWidth), (row * rowHeight), columnWidth, rowHeight);
    [view setNeedsLayout];
    column++;
    if (column >= _columnCount) {
      column = 0;
      row++;
    }
    // Skip to next page
    if (row >= _rowCount) {
      page++;
      row = 0;
      column = 0;
    }
  }    
}

@end


@implementation YKUIGridButton

@synthesize label=_label, imageView=_imageView, widthRestricted=_widthRestricted;


- (id)initWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
  if ((self = [super initWithFrame:CGRectZero])) {
    _widthRestricted = YES;
    
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.text = title;
    _label.textAlignment = UITextAlignmentCenter;
    _label.contentMode = UIViewContentModeBottom;
    _label.textColor = [UIColor blackColor];
    _label.opaque = NO;
    _label.backgroundColor = [UIColor clearColor];
    _label.adjustsFontSizeToFitWidth = YES;
    _label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    _label.numberOfLines = 1;
    [self addSubview:_label];
    [_label release];
    _imageView = [[UIImageView alloc] initWithImage:image highlightedImage:highlightedImage];
    [self addSubview:_imageView];
    [_imageView release];    
    
    [self bringSubviewToFront:_label];
  }
  return self;
}

- (void)layoutSubviews {
  CGSize size = self.frame.size;
  CGSize imageSize = (_imageView.image ? _imageView.image.size : CGSizeZero);
  CGFloat maxWidth = (size.width - 8); // Max label width
  
  [_label sizeToFit];  
  
  // If label shouldn't be wider than image
  if (_widthRestricted && _imageView.image)
    maxWidth = imageSize.width;

  if (_label.yk_width > maxWidth)
    _label.frame = YKCGRectSetWidth(_label.frame, maxWidth);
  
  // Place at bottom if we have an image, otherwise in center
  if (_imageView.image) {
    _label.frame = CGRectMake(ceilf((size.width / 2.0) - (_label.yk_width / 2.0)), // Centered in X
                              ceilf((size.height / 2.0) + (imageSize.height / 2.0) - (_label.yk_height) - 4), // Bottom of centered image with some padding
                              _label.yk_width, _label.yk_height);
    
    
  } else {
    _label.frame = CGRectIntegral(YKCGRectToCenter(_label.frame.size, self.frame.size));
  }
  _imageView.frame = CGRectIntegral(YKCGRectToCenter(_imageView.frame.size, self.frame.size));
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  _label.highlighted = highlighted;
  _imageView.highlighted = highlighted;
}

@end
