//
//  YKUITableViewCell.h
//  YelpKit
//
//  Created by Gabriel Handford on 10/24/08.
//  Copyright 2008. All rights reserved.
//

#import "YKUITableViewCellDataSource.h"

@class YKUITableViewCell;

/*!
 As the showing of the select menu is activated some time after this cell is highlighted
 (not selected) the cell must notify its delegate that it has shown the text select
 menu: there's no way for YKUITableView to be notified otherwise.
 */
@protocol YKUITableViewCellDelegate <NSObject>
@optional
- (void)tableViewCellWillShowSelectMenu:(YKUITableViewCell *)tableViewCell;
@end

/*!
 A UITableViewCell that wraps a view.
 This class does not support text as content; Only a view.
 To use a text cell (with working textAlignment), use YKUITableViewTextCell.
 */
@interface YKUITableViewCell : UITableViewCell <YKUITableViewCellDataSource> { 
	UIView *_cellView;
  id<YKUITableViewCellDelegate> _cellDelegate; // weak
	
	// Optional, can place a select target/action and call via select:
	id _selectTarget; // weak
	SEL _selectAction; 
  id _selectContext; 
	
	BOOL _enabled;
	
	// Whether to deselect as a hint to the table view if it supports it; Defaults to YES
	BOOL _deselect;

	BOOL _showingEditingMenu;
}

@property (retain, nonatomic) UIView *cellView;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic, getter=shouldDeselect) BOOL deselect;
@property (readonly, nonatomic, getter=isShowingEditMenu) BOOL showingEditingMenu;
@property (assign, nonatomic) id<YKUITableViewCellDelegate> cellDelegate;


/*!
 Create a cell from a UIView with reuse identifier.
 
 The cell size expands to the size of the specified view.
 
 @param view View to use in cell. Cell is expanded to fill the view.
 @param reuseIdentifier Identifier for reuse
 */
- (id)initWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier;

//- (id)initWithFrame:(CGRect)frame view:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier;

/*!
 Create a UITableViewCell from a view.
 */
+ (YKUITableViewCell *)tableViewCellWithView:(UIView *)view;
+ (YKUITableViewCell *)tableViewCellWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier;

/*!
 Create a UITableViewCell from a view with a transparent background (required for UITableViewControllers of grouped style) and not clickable.
 */
+ (YKUITableViewCell *)transparentTableViewCellWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier;

// For UITableViewController with UITableViewStyleGrouped, this container will have a background.
// Calling this method will replace the background with a transparent one.
- (void)setTransparentBackground;
- (void)setTransparentSelectedBackground;
- (void)setCustomSelectedBackground;

/*!
 The the background color of the background view.
 @param color
 */
- (void)setBackgroundViewColor:(UIColor *)color;

/*!
 Set an optional select target/action. Will be called with tableView if an arg is allowed.
 @param target (not retained, weak)
 @param action
 */
- (void)setSelectTarget:(id)target action:(SEL)action;

/*!
 Set an optional select target/action. Will be called with context if set.
 @param target (not retained, weak)
 @param action
 @param context
 */
- (void)setSelectTarget:(id)target action:(SEL)action context:(id)context;

/*!
 If set, perform action on target.
 @param sender Table view to pass to action; Can be nil
 */
- (void)select:(YKUITableView *)tableView;

//! Returns true if this cell supports text copying to clipboard. Default is NO.
- (BOOL)canCopyText;

//! String to copy to clipboard if this cell supports copying.  Default is nil.
- (NSString *)stringToCopy;

@end




