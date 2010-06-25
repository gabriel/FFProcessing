//
//  YKUITableViewCellDataSource.h
//  YelpKit
//
//  Created by Gabriel Handford on 10/16/09.
//  Copyright 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
  YKUITableViewCellAccessoryNone = UITableViewCellAccessoryNone, // Same as UITableViewCellAccessoryNone
  YKUITableViewCellAccessoryDisclosure = UITableViewCellAccessoryDisclosureIndicator, // Same as UITableViewCellAccessoryDisclosureIndicator
  YKUITableViewCellAccessoryDetailDisclosureButton = UITableViewCellAccessoryDetailDisclosureButton, // Same as UITableViewCellAccessoryDetailDisclosureButton
  YKUITableViewCellAccessoryCheckmark = UITableViewCellAccessoryCheckmark, // Same as UITableViewCellAccessoryCheckmark
  YKUITableViewCellAccessoryCheckmarkDisclosure = 2990 // Using large number in case UITableViewCellAccessoryTypes are added later
};
typedef UITableViewCellAccessoryType YKUITableViewCellAccessoryType;


@class YKUITableView;

@protocol YKUITableViewCellDataSource <NSObject>
- (UITableViewCell *)cellForTableView:(YKUITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeThatFits:(CGSize)size;
@optional
// If your size depends on row or tableview
- (CGSize)sizeThatFits:(CGSize)size tableView:(YKUITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath;
// If implemented will be called when cell is selected
- (void)select:(YKUITableView *)tableView;
- (id)context;
@end


/*!
 Basic data source that displays an image and label,
 can handle checkmark display and custom height.
 */
@interface YKUITableViewCellDataSource : NSObject <YKUITableViewCellDataSource> {
	UIImage *_image;
	NSString *_text;
  NSString *_detailText;
	YKUITableViewCellAccessoryType _accessoryType;
	CGFloat _height;
  
  UIFont *_textFont;
  UIFont *_detailTextFont;
	
	id _context;
  
  BOOL _showsReorderControl;
  UITableViewCellEditingStyle _editingStyle;
}

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) NSString *text;
@property (retain, nonatomic) NSString *detailText;
@property (retain, nonatomic) UIFont *textFont;
@property (retain, nonatomic) UIFont *detailTextFont;

@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) YKUITableViewCellAccessoryType accessoryType;
@property (retain, nonatomic) id context;

@property (assign, nonatomic) BOOL showsReorderControl;
@property (assign, nonatomic) UITableViewCellEditingStyle editingStyle;


- (id)initWithImage:(UIImage *)image text:(NSString *)text height:(CGFloat)height context:(id)context accessoryType:(YKUITableViewCellAccessoryType)accessoryType;
+ (YKUITableViewCellDataSource *)image:(UIImage *)image text:(NSString *)text height:(CGFloat)height context:(id)context accessoryType:(YKUITableViewCellAccessoryType)accessoryType;

+ (YKUITableViewCellDataSource *)text:(NSString *)text tag:(NSInteger)tag accessoryType:(YKUITableViewCellAccessoryType)accessoryType;

+ (YKUITableViewCellDataSource *)text:(NSString *)text font:(UIFont *)font tag:(NSInteger)tag on:(BOOL)on;

- (void)setOn:(BOOL)on;
- (BOOL)isOn;

- (BOOL)toggleOnOff;

- (NSInteger)tag;
- (void)setTag:(NSInteger)tag;

@end