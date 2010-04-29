//
//  YPUIAlertView.h
//  YelpKit
//
//  Created by Gabriel Handford on 7/16/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YPUIAlertView : NSObject <UIAlertViewDelegate> {
  
  id _target; // weak
  SEL _action;
  
  id _context;

}

- (id)initWithTarget:(id)target action:(SEL)action context:(id)context;

/*!
 Show alert with target/selector callback.
 @param target
 @param action 
  Selector of the form myAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index;
  If context is not nil, selector of the form myAlertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index context:(id)context;
 @param context Context passed to action (if not nil)
 @param title
 @param message
 @param cancelButtonTitle
 @param otherButtonTitle
 */
+ (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message 
          cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message 
          cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle args:(va_list)args;

/*!
 Show OK alert.
 @param message
 @param title
 @result Alert view
 */
+ (UIAlertView *)showOKAlertWithMessage:(NSString *)message title:(NSString *)title;

/*!
 Show (simple) alert.
 @param message
 @param title
 @param cancelButtonTitle
 @result Alert view
 */
+ (UIAlertView *)showAlertWithMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle;

@end

@protocol YPUIAlertViewActions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex context:(id)context; // If context not nil
@end


/*!
 Target, action for use in showAlertWithTarget context.
 */
@interface YPUIAlertViewTarget : NSObject {
  
  id _target; // weak
  SEL _action;
  
}

- (id)initWithTarget:(id)target action:(SEL)action;

+ (YPUIAlertViewTarget *)target:(id)target action:(SEL)action;

- (void)perform;

@end
