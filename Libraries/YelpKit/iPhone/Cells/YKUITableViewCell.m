//
//  YKUITableViewCell.m
//  YelpKit
//
//  Created by Gabriel Handford on 10/24/08.
//  Copyright 2008. All rights reserved.
//

#import "YKUITableViewCell.h"
#import "YKCGUtils.h"
#import "YKUIButton.h"
#import "YKDefines.h"

@interface YKUITableViewCell () 
//! Shows the Copy Text menu 
- (void)_showEditingMenu; 
@end 

@implementation YKUITableViewCell

@synthesize cellView=_cellView, enabled=_enabled, deselect=_deselect, showingEditingMenu=_showingEditingMenu, cellDelegate=_cellDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		_enabled = YES;
		_deselect = YES;
		self.selectionStyle = UITableViewCellSelectionStyleGray;
	}
	return self;
}

- (id)initWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier {
	NSParameterAssert(view);
	if ((self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		_cellView = [view retain];
		
		if (!_cellView.backgroundColor) {
			YPWarn(@"No background color for cell: <%@>; view: <%@>", [self class], [_cellView class]);
			_cellView.opaque = NO;
			_cellView.backgroundColor = [UIColor clearColor];
		}		
	}
	return self;
}

- (void)dealloc {
	[_cellView release];
  [_selectContext release];
	[super dealloc];
}

+ (YKUITableViewCell *)tableViewCellWithView:(UIView *)view {
	return [self tableViewCellWithView:view reuseIdentifier:nil];
}

+ (YKUITableViewCell *)tableViewCellWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier {
	return [[[YKUITableViewCell alloc] initWithView:view reuseIdentifier:reuseIdentifier] autorelease];
}

+ (YKUITableViewCell *)transparentTableViewCellWithView:(UIView *)view reuseIdentifier:(NSString *)reuseIdentifier {
	YKUITableViewCell *cell = [[YKUITableViewCell alloc] initWithView:view reuseIdentifier:reuseIdentifier];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setTransparentBackground];
	return [cell autorelease];
}

- (void)setTransparentBackground {
	CGSize size = self.frame.size;
	UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	transparentView.opaque = NO;
	self.backgroundView = transparentView;	
	[transparentView release];
}

- (void)setBackgroundViewColor:(UIColor *)color {
  if (!self.backgroundView) 
    self.backgroundView = [[[UIView alloc] init] autorelease];
  self.backgroundView.backgroundColor = color;
}

- (void)setTransparentSelectedBackground {
	CGSize size = self.frame.size;
	UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	transparentView.opaque = NO;
	self.selectedBackgroundView = transparentView;	
	[transparentView release];
}

- (void)setCustomSelectedBackground {
	CGSize size = self.frame.size;
	YKUIButtonBackground *background = [[YKUIButtonBackground alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	self.selectedBackgroundView = background;	
	[background release];
}

- (void)sizeToFit {
	[_cellView sizeToFit];	
}

- (void)layoutSubviews {
	[super layoutSubviews];
	// It is very important to add this only after super#layoutSubviews 
	// where I believe it lazy loads contentView with the correct selected cell
	// background
	if (![_cellView superview]) {    
		[self.contentView addSubview:_cellView];
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGSize sizeThatFits = [_cellView sizeThatFits:size];
  sizeThatFits.height += _cellView.frame.origin.y + 1;
	return sizeThatFits;
}

- (UITableViewCell *)cellForTableView:(YKUITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath {
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if (!_enabled && selected) return;
	[super setSelected:selected animated:animated];	
	if ([_cellView respondsToSelector:@selector(setSelected:)]) {
		YPDebug(@"Cell view selected");
		[(id)_cellView setSelected:selected];
		[_cellView setNeedsDisplay];
	}
  if (!selected) {
		// Edit menu disappears when this cell is deselected
		_showingEditingMenu = NO;
		if (self.highlighted) {
			[self setHighlighted:NO animated:animated];
		}
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	if (!_enabled && highlighted) return;
	[super setHighlighted:highlighted animated:animated];	
	if ([_cellView respondsToSelector:@selector(setHighlighted:)]) {
		[(id)_cellView setHighlighted:highlighted];
		[_cellView setNeedsDisplay];
	}
  if (highlighted && [self canCopyText]) [[self gh_proxyAfterDelay:0.3] _showEditingMenu];
}

- (void)setSelectTarget:(id)target action:(SEL)action {
	_selectTarget = target;
	_selectAction = action;
}

- (void)setSelectTarget:(id)target action:(SEL)action context:(id)context {
  _selectTarget = target;
	_selectAction = action;
  _selectContext = [context retain];
}

- (void)select:(YKUITableView *)tableView {
	if (!_enabled) return;
	[_selectTarget performSelector:_selectAction withObject:(_selectContext ? _selectContext : tableView)];
}

// Override; Handles special accessory type: YKUITableViewCellAccessoryCheckmarkDisclosure
- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
  if (accessoryType == YKUITableViewCellAccessoryCheckmarkDisclosure) {
    [super setAccessoryType:UITableViewCellAccessoryNone];    
    static UIImageView *CheckmarkDisclosureImage = NULL;
    if (CheckmarkDisclosureImage == NULL) {
      CheckmarkDisclosureImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_disclosure.png"]];
      CheckmarkDisclosureImage.highlightedImage = [UIImage imageNamed:@"checkmark_disclosure_selected.png"];
    }
    self.accessoryView = CheckmarkDisclosureImage;
  } else {
    self.accessoryView = nil;
    [super setAccessoryType:accessoryType];
  }
}

#pragma mark Copying Text To Clipboard Support


- (BOOL)canBecomeFirstResponder {
	return [self canCopyText];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	if (action == @selector(copy:) && [self canCopyText]) {
		return true;
	} else {
		return false;
	}
}

- (void)copy:(id)sender {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	[self setHighlighted:NO animated:YES];
	[self setSelected:NO animated:YES];
	pasteboard.string = [self stringToCopy];
}

- (BOOL)shouldDeselect {
	if (_showingEditingMenu) {
		return NO;
	} else {
		return _deselect;
	}
}

- (BOOL)canCopyText {
	return NO;
}

- (NSString *)stringToCopy {
	return nil;
}

- (void)_showEditingMenu {
	if (self.highlighted) {
    if ([_cellDelegate respondsToSelector:@selector(tableViewCellWillShowSelectMenu:)]) {
			[_cellDelegate tableViewCellWillShowSelectMenu:self];
		}
		[self becomeFirstResponder];
		UIMenuController *menuController = [UIMenuController sharedMenuController];
		[menuController setTargetRect:self.bounds inView:self];
		[menuController setMenuVisible:YES animated:YES];
		_showingEditingMenu = YES;
	}
}

@end
