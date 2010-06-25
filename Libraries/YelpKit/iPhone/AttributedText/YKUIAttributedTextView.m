//
//  YKUIAttributedTextView.m
//  YelpKit
//
//  Created by Gabriel Handford on 12/3/08.
//  Copyright 2008. All rights reserved.
//

#import "YKUIAttributedTextView.h"
#import "YKCGUtils.h"
#import "YKAttributedTextParser.h"
#import "YKDefines.h"
#import "YKLocalized.h"

// TODO(gabe): Support resizing
@implementation YKUIAttributedTextView

@synthesize dataSource=_textDataSource, delegate=_textDelegate, textColor=_textColor, touchableTextColor=_touchableTextColor, textAlignment=_textAlignment, 
highlightEnabled=_highlightEnabled, shadowColor=_shadowColor, shadowOffset=_shadowOffset, defaultFont=_defaultFont, contentVerticalAlignment=_contentVerticalAlignment;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    _textColor = [[UIColor blackColor] retain];
    _textAlignment = UITextAlignmentLeft;
    _contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = NO;
  }
  return self;
}

- (void)dealloc {
  [_textColor release];
  [_textDataSource release];
  [_shadowColor release];
  [_defaultFont release];
  [super dealloc];
} 

- (void)setAttributedText:(NSString *)text defaultFont:(UIFont *)defaultFont defaultBoldFont:(UIFont *)defaultBoldFont 
                    width:(CGFloat)width contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets 
                    color:(UIColor *)color linkColor:(UIColor *)linkColor {
  [self setAttributedText:text defaultFont:defaultFont defaultBoldFont:defaultBoldFont width:width maxLineCount:-1 contentEdgeInsets:contentEdgeInsets color:color linkColor:linkColor];
}  

- (void)setAttributedText:(NSString *)text defaultFont:(UIFont *)defaultFont defaultBoldFont:(UIFont *)defaultBoldFont 
                    width:(CGFloat)width maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets 
                    color:(UIColor *)color linkColor:(UIColor *)linkColor {
  
  YKUIAttributedTextViewDataSource *dataSource = [[YKUIAttributedTextViewDataSource alloc] initWithAttributedText:text defaultFont:defaultFont defaultBoldFont:defaultBoldFont
                                                                                                            width:width maxLineCount:maxLineCount contentEdgeInsets:contentEdgeInsets
                                                                                                            color:color linkColor:linkColor];
  self.dataSource = dataSource;
  [dataSource release];  
}

- (void)setText:(NSString *)text {
  NSAssert(_defaultFont, @"When using setText: you must set a default font");
  [self setText:text font:_defaultFont];
}

- (void)setText:(NSString *)text font:(UIFont *)font {
  [self setText:text font:font contentEdgeInsets:UIEdgeInsetsZero];
}

- (void)setText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
  NSAssert(width > 0, @"View should have a width when setting text");
  [self setText:text font:font width:width contentEdgeInsets:UIEdgeInsetsZero maxLineCount:-1];
}

- (void)setText:(NSString *)text font:(UIFont *)font contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
  NSAssert(self.frame.size.width > 0, @"View should have a width when setting text");
  [self setText:text font:font width:self.frame.size.width contentEdgeInsets:contentEdgeInsets maxLineCount:-1];
}

- (void)setText:(NSString *)text font:(UIFont *)font width:(CGFloat)width contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets maxLineCount:(NSInteger)maxLineCount {
  YKUIAttributedTextViewDataSource *dataSource = [[YKUIAttributedTextViewDataSource alloc] initWithString:text width:width font:font maxLineCount:maxLineCount contentEdgeInsets:contentEdgeInsets];
  self.dataSource = dataSource; 
  [dataSource release];
}

- (void)setAttributedStrings:(NSArray *)attributedStrings defaultFont:(UIFont *)defaultFont {
  NSAssert(self.frame.size.width > 0, @"YKUIAttributedTextView must have a width when setting strings");
  [self setAttributedStrings:attributedStrings defaultFont:defaultFont width:self.frame.size.width contentEdgeInsets:UIEdgeInsetsZero];
}

- (void)setAttributedStrings:(NSArray *)attributedStrings defaultFont:(UIFont *)defaultFont width:(CGFloat)width contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
  [self setAttributedStrings:attributedStrings defaultFont:defaultFont width:width maxLineCount:-1 contentEdgeInsets:contentEdgeInsets];
}

- (void)setAttributedStrings:(NSArray *)attributedStrings defaultFont:(UIFont *)defaultFont width:(CGFloat)width maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
  YKUIAttributedTextViewDataSource *dataSource = [[YKUIAttributedTextViewDataSource alloc] initWithAttributedStrings:attributedStrings width:width 
                                                                                                         defaultFont:defaultFont maxLineCount:maxLineCount skipEmptyLines:NO 
                                                                                                   contentEdgeInsets:contentEdgeInsets linePadding:0];
  self.dataSource = dataSource;
  [dataSource release];
}

- (void)setDataSource:(YKUIAttributedTextViewDataSource *)dataSource {
  [dataSource retain];
  [_textDataSource release];
  _textDataSource = dataSource;
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size {
  return [_textDataSource sizeThatFits:size];
}

- (YKAttributedString *)attributedStringAtPoint:(CGPoint)point touchableOnly:(BOOL)touchableOnly visibleOnly:(BOOL)visibleOnly padding:(CGSize)padding {
  // Adjust point to the text origin 
  point.x -= self.dataSource.textOrigin.x;
  point.y -= self.dataSource.textOrigin.y;
  
  YKAttributedString *lastVisibleString = [_textDataSource lastVisibleString];
    
  for(YKAttributedString *s in _textDataSource.formattedStrings) {
    CGRect rect = s.rect;
    rect.origin.x -= padding.width;
    rect.size.width += (padding.width * 2);
    rect.origin.y -= padding.height;
    rect.size.height += (padding.height * 2);
    if (((touchableOnly && s.touchable) || !touchableOnly) && CGRectContainsPoint(rect, point)) {
      return s;
    }
    if (visibleOnly && lastVisibleString && [s isEqual:lastVisibleString]) break;
  }
  return nil;
}

- (void)touchAtPoint:(CGPoint)point phase:(UITouchPhase)phase padding:(CGSize)padding {
  switch(phase) {
    case UITouchPhaseEnded: {
      [self highlight:nil];
      YKAttributedString *s = [self attributedStringAtPoint:point touchableOnly:YES visibleOnly:YES padding:padding];
      if (s)
        [_textDelegate attributedTextView:self didSelectAttributedString:s];
      break;
    }
    case UITouchPhaseCancelled:
      [self highlight:nil];
      break;
    case UITouchPhaseBegan: {
      YKAttributedString *s = [self attributedStringAtPoint:point touchableOnly:YES visibleOnly:YES padding:padding]; 
      [self highlight:s];
      break;
    }
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  
  if ([touches count] != 1) return;
  CGPoint point = [[touches anyObject] locationInView:self];
  [self touchAtPoint:point phase:UITouchPhaseBegan padding:CGSizeMake(2, 4)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {  
  if ([touches count] != 1) return;
  CGPoint point = [[touches anyObject] locationInView:self];  
  [self touchAtPoint:point phase:UITouchPhaseEnded padding:CGSizeMake(2, 4)];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  if ([touches count] != 1) return;
  CGPoint point = [[touches anyObject] locationInView:self];  
  [self touchAtPoint:point phase:UITouchPhaseCancelled padding:CGSizeMake(2, 4)];
}

- (void)highlight:(YKAttributedString *)string {
  if (string) {
    _highlightRect = YKCGRectAddPoint(string.rect, self.dataSource.textOrigin);
    _temporaryHighlight = YES;
  } else {
    _highlightRect = CGRectNull;
  }
  [self setNeedsDisplay];
}

- (CGPoint)drawTextInRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext(); 
  if (_highlightEnabled && !CGRectIsNull(_highlightRect)) {
    YKCGContextDrawRoundedRect(context, _highlightRect, [UIColor colorWithWhite:0.85 alpha:1].CGColor, NULL, 0, 3.0);
    if (_temporaryHighlight) _highlightRect = CGRectNull;
    [self setNeedsDisplay];
  }
    
  CGContextSetFillColorWithColor(context, _textColor.CGColor);
  
  if (_shadowColor && (_shadowOffset.width != 0 || _shadowOffset.height != 0)) {
    // Reverse y since origin is different
    CGContextSetShadowWithColor(context, CGSizeMake(_shadowOffset.width, -_shadowOffset.height), 0, _shadowColor.CGColor);
  }

  //YPDrawRect(context, rect, NULL, [UIColor redColor].CGColor, 1);
  return [_textDataSource drawInRect:rect defaultColor:_textColor defaultTouchableTextColor:_touchableTextColor textAlignment:_textAlignment 
            contentVerticalAlignment:_contentVerticalAlignment];
}

- (void)drawRect:(CGRect)rect { 
  [self drawTextInRect:YKCGRectZeroOrigin(self.frame)];
}

@end

@interface YKUIAttributedTextViewDataSource ()
- (void)_initMetrics;
@end

@implementation YKUIAttributedTextViewDataSource

@synthesize formattedStrings=_formattedStrings, defaultFont=_defaultFont, expanded=_expanded, collapsedHeightThatFits=_collapsedHeightThatFits, 
collapsedLineCount=_collapsedLineCount, expandable=_expandable, textOrigin=_textOrigin, contentEdgeInsets=_contentEdgeInsets, moreLinkOffset=_moreLinkOffset,
maxLineWidth=_maxLineWidth;

- (id)initWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maxLineCount:(NSInteger)maxLineCount {
  return [self initWithString:string width:width font:font maxLineCount:maxLineCount contentEdgeInsets:UIEdgeInsetsZero];
}

- (id)initWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets { 
  return [self initWithAttributedStrings:[NSArray arrayWithObject:[YKAttributedString string:string]] width:width defaultFont:font maxLineCount:maxLineCount 
                          skipEmptyLines:NO contentEdgeInsets:contentEdgeInsets linePadding:0];
}

- (id)initWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maxLineCount:(NSInteger)maxLineCount 
   contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets linePadding:(CGFloat)linePadding { 
  return [self initWithAttributedStrings:[NSArray arrayWithObject:[YKAttributedString string:string]] width:width defaultFont:font maxLineCount:maxLineCount 
                          skipEmptyLines:NO contentEdgeInsets:contentEdgeInsets linePadding:linePadding];
}

- (id)initWithAttributedText:(NSString *)text defaultFont:(UIFont *)defaultFont defaultBoldFont:(UIFont *)defaultBoldFont 
                       width:(CGFloat)width maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets 
                       color:(UIColor *)color linkColor:(UIColor *)linkColor {
  
  NSMutableArray *attributedStrings = [[NSMutableArray alloc] init];
  YKAttributedTextParser *parser = [[YKAttributedTextParser alloc] initWithColor:color linkColor:linkColor font:nil boldFont:defaultBoldFont];
  [parser parseXML:text attributedStrings:&attributedStrings error:nil];
  [parser release];
  if ((self = [self initWithAttributedStrings:attributedStrings width:width defaultFont:defaultFont maxLineCount:maxLineCount skipEmptyLines:NO contentEdgeInsets:contentEdgeInsets
                linePadding:0])) { }
  [attributedStrings release];
  return self;
}  

- (id)initWithAttributedStrings:(NSArray *)attributedStrings width:(CGFloat)width defaultFont:(UIFont *)defaultFont contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
  return [self initWithAttributedStrings:attributedStrings width:width defaultFont:defaultFont maxLineCount:-1 skipEmptyLines:NO contentEdgeInsets:contentEdgeInsets linePadding:0];
}

- (id)initWithAttributedStrings:(NSArray *)attributedStrings width:(CGFloat)width defaultFont:(UIFont *)defaultFont maxLineCount:(NSInteger)maxLineCount skipEmptyLines:(BOOL)skipEmptyLines 
              contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets linePadding:(CGFloat)linePadding {
  if ((self = [super init])) {    
    _expandable = NO;
    _formatWidth = width;
    _collapsedLineCount = -1;
    _defaultFont = [defaultFont retain];
    _maxLineCount = maxLineCount;

    _contentEdgeInsets = contentEdgeInsets;
    width -= _contentEdgeInsets.left + _contentEdgeInsets.right;

    _formattedStrings = [[YKAttributedString formatForWidth:width attributedStrings:attributedStrings size:&_sizeThatFits linePadding:linePadding withDefaultFont:defaultFont 
                                               maxLineCount:maxLineCount skipEmptyLines:skipEmptyLines] retain];
    _moreLinkOffset = 50.0; // Default
    [self _initMetrics];
  }
  return self;
}

- (id)initWithAttributedStrings:(NSArray *)attributedStrings width:(CGFloat)width collapsedLineCount:(NSInteger)collapsedLineCount 
                    defaultFont:(UIFont *)defaultFont lastLineWidth:(CGFloat)lastLineWidth linePadding:(CGFloat)linePadding {
  
  if ((self = [self init])) {
    _defaultFont = [defaultFont retain];
    _maxLineCount = -1;
    _formatWidth = width;
    _collapsedLineCount = collapsedLineCount;
    if (attributedStrings) {
      _formattedStrings = [[YKAttributedString formatForWidth:width attributedStrings:attributedStrings size:&_sizeThatFits linePadding:linePadding
                                              withDefaultFont:defaultFont maxLineCount:-1 skipEmptyLines:NO] retain];
      _collapsedHeightThatFits = [YKAttributedString heightForLineCount:_collapsedLineCount attributedStrings:_formattedStrings];
      _expandable = YES;      
    }
    _moreLinkOffset = 50.0; // Default
    _lastLineWidth = lastLineWidth;   
    [self _initMetrics];
  }
  return self;
}

- (void)_initMetrics {
  // Calculate max line width
  for (YKAttributedString *s in _formattedStrings)
    if (_maxLineWidth < s.lineWidth) _maxLineWidth = s.lineWidth;      
  //  YPDebug(@"Max line width: %.0f", _maxLineWidth); // This was getting annoying in the logs
}

- (void)dealloc {
  [_defaultFont release];
  [_formattedStrings release];
  [super dealloc];
}

- (NSString *)description {
  return YKDescription(@"formattedStrings");
}

- (BOOL)isExpandable {
  return (_expandable && _collapsedHeightThatFits < _sizeThatFits.height);
}

- (void)setExpanded:(BOOL)expanded {
  if (!self.isExpandable) return;
  _expanded = expanded;
}

- (CGFloat)heightThatFits {
  return _sizeThatFits.height;
}

- (BOOL)isCollapsed {
  return (self.isExpandable && !self.isExpanded);
}

- (NSInteger)lineCount {
  return (self.isCollapsed ? _collapsedLineCount : _maxLineCount);
}

- (CGSize)sizeThatFits:(CGSize)size {
  CGFloat height = (self.isCollapsed ? _collapsedHeightThatFits : _sizeThatFits.height);
  
  // If we need an extra line for the Less link (since it doesn't fit on last line)
  if (self.isExpandable && self.isExpanded) {
    YKAttributedString *lastWord = [_formattedStrings lastObject];
    if (lastWord && (lastWord.rect.origin.x + lastWord.rect.size.width) > _lastLineWidth) height += 20;
  }
  
  height += _contentEdgeInsets.top + _contentEdgeInsets.bottom;
  
  CGFloat width;
  // Width for expandable is the width we formatted at; Width for non-expandable is the max line width which may be less than formatted width.
  if (self.isExpandable) width = _formatWidth;
  else width = _maxLineWidth + _contentEdgeInsets.left + _contentEdgeInsets.right;
  return CGSizeMake(width, height);
}

- (YKAttributedString *)lastVisibleString {
  // Context is NULL so we can get the last string without drawing
  return [YKAttributedString drawStrings:_formattedStrings context:NULL defaultColor:nil defaultTouchableTextColor:nil 
                             defaultFont:_defaultFont textAlignment:UITextAlignmentLeft 
                contentVerticalAlignment:UIControlContentVerticalAlignmentTop
                                   rect:CGRectMake(0, 0, -1, -1)
                            maxLineCount:self.lineCount lastLineWidth:_lastLineWidth];
}
  
- (CGPoint)drawInRect:(CGRect)rect defaultColor:(UIColor *)defaultColor defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor 
         textAlignment:(UITextAlignment)textAlignment {
  return [self drawInRect:rect defaultColor:defaultColor defaultTouchableTextColor:defaultTouchableTextColor textAlignment:textAlignment 
      contentVerticalAlignment:UIControlContentVerticalAlignmentTop];
}

- (CGPoint)drawInRect:(CGRect)rect defaultColor:(UIColor *)defaultColor defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor 
         textAlignment:(UITextAlignment)textAlignment contentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment {
           
  rect.origin.x += _contentEdgeInsets.left;
  rect.origin.y += _contentEdgeInsets.top;
  rect.size.height -= _contentEdgeInsets.top + _contentEdgeInsets.bottom;
  rect.size.width -= _contentEdgeInsets.left + _contentEdgeInsets.right;
  _textOrigin = rect.origin;
  
  YKAttributedString *s = [YKAttributedString drawStrings:_formattedStrings defaultColor:defaultColor defaultTouchableTextColor:defaultTouchableTextColor 
                                              defaultFont:_defaultFont textAlignment:textAlignment 
                                            contentVerticalAlignment:contentVerticalAlignment rect:rect
                                             maxLineCount:self.lineCount lastLineWidth:_lastLineWidth];
  
  CGPoint p = rect.origin;
  if (s) {
    p.x += s.rect.origin.x + s.rect.size.width;
    p.y += s.rect.origin.y;
  }
  
  if (s && self.isExpandable) {
    if (!self.isExpanded) {
      CGFloat cwidth = s.rect.size.width;
      if (cwidth > _lastLineWidth) cwidth = _lastLineWidth;
      if (cwidth > 0) cwidth += 4; // Pad
      
      p.x = rect.origin.x + cwidth;
    } else {
      // If the position is larger than _lastLineWidth, then drop to a new line for the Less link
      if ((s.rect.origin.x + s.rect.size.width) > _lastLineWidth) {
        p.x = rect.origin.x;
        p.y += 20;
      } else {        
        p.x += 4;
      }
    }
    
    NSString *link = YKLocalizedString(!self.isExpanded ? @"More" : @"Less");
    [[UIColor blueColor] setFill]; // TODO(gabe): Link color and font should be configurable
    [link drawAtPoint:CGPointMake(rect.size.width - _moreLinkOffset, p.y) forWidth:40 withFont:[UIFont fontWithName:@"Helvetica" size:14] lineBreakMode:UILineBreakModeClip];   
  }
  return p;
}

@end
