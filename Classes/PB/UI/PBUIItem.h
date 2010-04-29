//
//  PBUIItem.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/7/10.
//  Copyright 2010. All rights reserved.
//

@protocol PBUIItem <NSObject>
- (NSString *)text;
- (UITableViewCellAccessoryType)accessoryType;
- (void)perform;
- (id)context;
@end

@interface PBUIItem : NSObject <PBUIItem> {
  NSString *_text;
  id _target;
  SEL _action;
  UITableViewCellAccessoryType _accessoryType;
  id _context;
}

@property (retain, nonatomic) NSString *text;
@property (assign, nonatomic) id target; // weak
@property (assign, nonatomic) SEL action;
@property (retain, nonatomic) id context;
@property (assign, nonatomic) UITableViewCellAccessoryType accessoryType;

- (id)initWithText:(NSString *)text target:(id)target action:(SEL)action;

+ (PBUIItem *)text:(NSString *)text target:(id)target action:(SEL)action;

+ (PBUIItem *)text:(NSString *)text target:(id)target action:(SEL)action accessoryType:(UITableViewCellAccessoryType)accessoryType;

+ (PBUIItem *)text:(NSString *)text target:(id)target action:(SEL)action context:(id)context;

- (void)perform;

@end

