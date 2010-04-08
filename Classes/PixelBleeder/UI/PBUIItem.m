//
//  PBUIItem.m
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "PBUIItem.h"


@implementation PBUIItem

@synthesize text=_text, target=_target, action=_action, accessoryType=_accessoryType, context=_context;

- (id)initWithText:(NSString *)text target:(id)target action:(SEL)action {
  if ((self = [super init])) {
    _text = [text retain];
    _target = target;
    _action = action;
  }
  return self;
}

- (void)dealloc {
  [_text release];
  [_context release];
  [super dealloc];
}

+ (PBUIItem *)text:(NSString *)text target:(id)target action:(SEL)action {
  return [[[PBUIItem alloc] initWithText:text target:target action:action] autorelease];
}

+ (PBUIItem *)text:(NSString *)text target:(id)target action:(SEL)action accessoryType:(UITableViewCellAccessoryType)accessoryType {
  PBUIItem *item = [[PBUIItem alloc] initWithText:text target:target action:action];
  item.accessoryType = accessoryType;
  return [item autorelease];
}

+ (PBUIItem *)text:(NSString *)text target:(id)target action:(SEL)action context:(id)context {
  PBUIItem *item = [[PBUIItem alloc] initWithText:text target:target action:action];
  item.context = context;
  return [item autorelease];  
}

- (void)perform {
  [_target performSelector:_action withObject:_context];
}

@end
