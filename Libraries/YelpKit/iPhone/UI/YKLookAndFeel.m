//
//  YKLookAndFeel.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 4/22/10.
//  Copyright 2010. All rights reserved.
//

#import "YKLookAndFeel.h"

NSString *const YKLookAndFeelDidChangeNotification = @"YKLookAndFeelDidChangeNotification";

@implementation YKLookAndFeel

static YKLookAndFeel *gSharedLookAndFeel = NULL;

+ (YKLookAndFeel *)sharedLookAndFeel {
  if (gSharedLookAndFeel == NULL) [NSException raise:NSObjectNotAvailableException 
                                              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
  return gSharedLookAndFeel;
}

+ (void)setSharedLookAndFeel:(YKLookAndFeel *)sharedLookAndFeel {
  [sharedLookAndFeel retain];
  [gSharedLookAndFeel release];
  gSharedLookAndFeel = sharedLookAndFeel;
  [[NSNotificationCenter defaultCenter] postNotificationName:YKLookAndFeelDidChangeNotification object:gSharedLookAndFeel];
}


- (void)showAlertWithTarget:(id)target action:(SEL)action context:(id)context title:(NSString *)title message:(NSString *)message 
          cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitle, ... {
  
  [NSException raise:NSObjectInaccessibleException 
              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
}

- (YKUIButton *)basicButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
  [NSException raise:NSObjectInaccessibleException 
              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
  return nil;
}

- (UIControl *)basicSegmentedButtonWithTitle:(NSString *)title {
  [NSException raise:NSObjectInaccessibleException 
              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
  return nil;
} 

#pragma mark -

- (UIColor *)barTintColor {
  [NSException raise:NSObjectInaccessibleException 
              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
  return nil;
}

- (UIColor *)buttonTintColor {
  [NSException raise:NSObjectInaccessibleException 
              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
  return nil;  
}

- (UIColor *)barViewTintColorTop {
  [NSException raise:NSObjectInaccessibleException 
              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
  return nil;  
}

- (UIColor *)barViewTintColorBottom {
  [NSException raise:NSObjectInaccessibleException 
              format:@"No current look and feel. You need to setSharedLookAndFeel:"];
  return nil;  
}

@end
