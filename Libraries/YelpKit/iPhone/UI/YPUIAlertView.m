//
//  YPUIAlertView.m
//  YelpKit
//
//  Created by Gabriel Handford on 7/16/09.
//  Copyright 2009. All rights reserved.
//

#import "YPUIAlertView.h"
#import "YPLocalized.h"
#import "YPDefines.h"
#import "GHNSObject+Invocation.h"

@implementation YPUIAlertView

- (id)initWithTarget:(id)target action:(SEL)action context:(id)context {
  if ((self = [super init])) {
    // TODO(gabe): check for different method signature if context is nil
    YPAssertSelectorNilOrImplementedWithArguments(target, action, @encode(UIAlertView *), @encode(NSInteger), @encode(id), 0);

    _target = target; 
    _action = action;
    _context = [context retain];
  }
  return self;
}

- (void)dealloc {
  [_context release];
  [super dealloc];
}

+ (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message 
          cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... {
  
  va_list args;
  va_start(args, otherButtonTitle);
  [self showAlertWithTarget:target action:action context:context title:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle args:args];
  va_end(args);
}

+ (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message 
          cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle args:(va_list)args {
  
  YPUIAlertView *delegate = [[YPUIAlertView alloc] initWithTarget:target action:action context:context] NS_RETURNS_RETAINED; // Released in alertView:clickedButtonAtIndex:context:
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
  while(otherButtonTitle) {
    [alertView addButtonWithTitle:otherButtonTitle];
    otherButtonTitle = va_arg(args, id);
  }
  
  [alertView show];
  [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [[_target gh_argumentProxy:_action] alertView:alertView clickedButtonAtIndex:buttonIndex context:_context];
  [self autorelease];
}

+ (UIAlertView *)showAlertWithMessage:(NSString *)message title:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]; 
  [alert show];
  [alert release];
  return alert;
}

+ (UIAlertView *)showOKAlertWithMessage:(NSString *)message title:(NSString *)title {
  return [self showAlertWithMessage:message title:title cancelButtonTitle:YPLocalizedString(@"OK")];
}

@end


@implementation YPUIAlertViewTarget

- (id)initWithTarget:(id)target action:(SEL)action {
  if ((self = [super init])) {
    _target = [target retain];
    _action = action;
  }
  return self;
}

- (void)dealloc {
  [_target release];
  [super dealloc];
}

+ (YPUIAlertViewTarget *)target:(id)target action:(SEL)action {
  return [[[YPUIAlertViewTarget alloc] initWithTarget:target action:action] autorelease];
}

- (void)perform {
  [_target performSelector:_action];
}

@end