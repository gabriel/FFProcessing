//
//  YKLookAndFeel.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 4/22/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIButton.h"

extern NSString *const YKLookAndFeelDidChangeNotification;

/*!
 Look and feel for YelpKit controllers.
 This class provides empty abstract implementation that raises an exception on access.
 You should subclass and set your own LookAndFeel class.
 */
@interface YKLookAndFeel : NSObject {

}

+ (YKLookAndFeel *)sharedLookAndFeel;

+ (void)setSharedLookAndFeel:(YKLookAndFeel *)sharedLookAndFeel;

- (UIColor *)barTintColor;

- (UIColor *)buttonTintColor;

- (UIColor *)barViewTintColorTop;

- (UIColor *)barViewTintColorBottom;

/*!
 Show alert with target/selector callback.
 @param target
 @param action Selector of the form myAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index context:(id)context;
 @param context Context passed to action
 @param title
 @param message
 @param cancelButtonTitle
 @param otherButtonTitle
 */
- (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message 
          cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ...;

/*!
 A basic button.
 */
- (YKUIButton *)basicButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

- (UIControl *)basicSegmentedButtonWithTitle:(NSString *)title;

@end
