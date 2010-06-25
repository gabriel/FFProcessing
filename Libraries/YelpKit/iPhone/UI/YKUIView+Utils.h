//
//  YKUIView+Utils.h
//  YelpKit
//
//  Created by Gabriel Handford on 10/6/09.
//  Copyright 2009. All rights reserved.
//

#import "YKCGUtils.h"

@interface UIView (YPUtils)

- (NSInteger)yk_removeAllSubviews;
- (void)yk_addHeight:(CGFloat)delta animated:(BOOL)animated;

- (NSArray *)yk_findSubviewsOfClass:(Class)class limit:(NSInteger)limit;

- (NSString *)yk_debugSubviews;

+ (void)yk_redrawSubviewsForView:(UIView *)view;

- (void)yk_redrawSubviews;

#pragma mark -

//
// From Three20 UIViewAdditions
//

@property (nonatomic) CGFloat yk_left;
@property (nonatomic) CGFloat yk_top;
@property (nonatomic) CGFloat yk_right;
@property (nonatomic) CGFloat yk_bottom;

@property (nonatomic) CGFloat yk_width; 
@property (nonatomic) CGFloat yk_height;

@property (nonatomic) CGFloat yk_centerX;
@property (nonatomic) CGFloat yk_centerY;

@property (readonly, nonatomic) CGFloat yk_screenX;
@property (readonly, nonatomic) CGFloat yk_screenY;
@property (readonly, nonatomic) CGFloat yk_screenViewX;
@property (readonly, nonatomic) CGFloat yk_screenViewY;
@property (readonly, nonatomic) CGRect yk_screenFrame;

- (UIScrollView *)yk_findFirstScrollView;

- (UIView *)yk_firstViewOfClass:(Class)cls;

- (UIView *)yk_firstParentOfClass:(Class)cls;

- (UIView *)yk_findChildWithDescendant:(UIView*)descendant;

/**
 * Removes all subviews.
 */
- (void)yk_removeSubviews;

- (CGPoint)yk_offsetFromView:(UIView*)otherView;

@end
