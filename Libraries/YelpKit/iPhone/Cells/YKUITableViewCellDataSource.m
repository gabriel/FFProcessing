//
//  YKUITableViewCellDataSource.m
//  YelpKit
//
//  Created by Gabriel Handford on 10/16/09.
//  Copyright 2009. All rights reserved.
//

#import "YKUITableViewCellDataSource.h"
#import "YKUITableViewCell.h"

@implementation YKUITableViewCellDataSource

@synthesize image=_image, text=_text, detailText=_detailText, height=_height, context=_context, accessoryType=_accessoryType, textFont=_textFont, detailTextFont=_detailTextFont,
showsReorderControl=_showsReorderControl, editingStyle=_editingStyle;

- (id)initWithImage:(UIImage *)image text:(NSString *)text height:(CGFloat)height context:(id)context accessoryType:(UITableViewCellAccessoryType)accessoryType {
	if ((self = [super init])) {
		_text = [text retain];
		_image = [image retain];
		_height = height;
		_context = [context retain];
		_accessoryType = accessoryType;
    _editingStyle = UITableViewCellEditingStyleNone;
	}
	return self;
}

+ (YKUITableViewCellDataSource *)image:(UIImage *)image text:(NSString *)text height:(CGFloat)height context:(id)context accessoryType:(UITableViewCellAccessoryType)accessoryType {
	return [[[self alloc] initWithImage:image text:text height:height context:context accessoryType:accessoryType] autorelease];
}

+ (YKUITableViewCellDataSource *)text:(NSString *)text tag:(NSInteger)tag accessoryType:(UITableViewCellAccessoryType)accessoryType {
  return [[[self alloc] initWithImage:nil text:text height:45 context:[NSNumber numberWithInteger:tag] accessoryType:accessoryType] autorelease];
}

+ (YKUITableViewCellDataSource *)text:(NSString *)text font:(UIFont *)font tag:(NSInteger)tag on:(BOOL)on {
  YKUITableViewCellDataSource *cellDataSource = [[[self alloc] initWithImage:nil text:text height:45 context:[NSNumber numberWithInteger:tag] accessoryType:UITableViewCellAccessoryNone] autorelease];
  cellDataSource.textFont = font;
  [cellDataSource setOn:on];
  return cellDataSource;
}

- (void)dealloc {
	[_text release];
  [_detailText release];
	[_image release];
	[_context release];
	[super dealloc];
}

- (BOOL)isOn {
	return (_accessoryType == YKUITableViewCellAccessoryCheckmark || _accessoryType == YKUITableViewCellAccessoryCheckmarkDisclosure);
}

- (void)setOn:(BOOL)on {
  switch(self.accessoryType) {
    case YKUITableViewCellAccessoryCheckmarkDisclosure:
      if (!on) self.accessoryType = YKUITableViewCellAccessoryDisclosure;
      break;
    case YKUITableViewCellAccessoryDisclosure:
      if (on) self.accessoryType = YKUITableViewCellAccessoryCheckmarkDisclosure;
      break;
    case YKUITableViewCellAccessoryCheckmark:
      if (!on) self.accessoryType = YKUITableViewCellAccessoryNone;
      break;
    case YKUITableViewCellAccessoryNone:
      if (on) self.accessoryType = YKUITableViewCellAccessoryCheckmark;
      break;
  }
}

- (BOOL)toggleOnOff {
	if ([self isOn]) {
		[self setOn:NO];
	} else {
		[self setOn:YES];
	}
	return [self isOn];
}

- (UITableViewCell *)cellForTableView:(YKUITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath {
	
  YKUITableViewCell *cell = nil;
  // Cell differs depending on if we have detail text
  if (_detailText) {
    static NSString *const DetailCellIdentifier = @"YKUITableViewDetailCellDataSource";
    cell = (YKUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
    if (!cell) cell = [[[YKUITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DetailCellIdentifier] autorelease];
    
    cell.detailTextLabel.text = self.detailText;
    if (self.detailTextFont) cell.detailTextLabel.font = self.detailTextFont;
    
  } else {
    static NSString *const CellIdentifier = @"YKUITableViewCellDataSource";
    cell = (YKUITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[[YKUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
	
	cell.imageView.image = self.image;
	cell.textLabel.text = self.text;
	cell.textLabel.textColor = [UIColor blackColor];	
  if (self.textFont) cell.textLabel.font = self.textFont;
  
  // For re-ordering
  cell.showsReorderControl = _showsReorderControl;
	
	cell.accessoryType = _accessoryType;
  [cell sizeToFit];
	
	return cell;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return CGSizeMake(320, _height);
}

- (NSInteger)tag {
  return [self.context integerValue];
}

- (void)setTag:(NSInteger)tag {
  self.context = [NSNumber numberWithInteger:tag];
}

@end