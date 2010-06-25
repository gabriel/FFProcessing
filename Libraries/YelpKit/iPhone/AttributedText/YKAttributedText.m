//
//  YKAttributedText.m
//  YelpKit
//
//  Created by Gabriel Handford on 12/3/08.
//  Copyright 2008. All rights reserved.
//

#import "YKAttributedText.h"
#import "YKCGUtils.h"
#import "YKDefines.h"

@interface YKAttributedText ()
@property (retain, nonatomic) NSString *string;
@property (retain, nonatomic) NSArray *attributedRanges;
- (BOOL)_checkAttributeRanges:(YPAttributedRange **)range;
- (void)_onAttributesChange;
- (YPAttributedRange *)_findRange:(NSRange)range;
@end

@implementation YKAttributedText

@synthesize string=_string, attributedRanges=_attributedRanges;

- (id)init {
  return [self initWithString:nil];
}

- (id)initWithString:(NSString *)string {
  if ((self = [super init])) {
    _string = [string retain];
    _attributedRanges = [[NSMutableArray alloc] init];
  }
  return self;
}

- (id)initWithAttributedStrings:(NSArray *)attributedStrings {
  if ((self = [super init])) {
    NSArray *attributedRanges = nil;
    NSString *string = [YPAttributedRange joinAttributedStrings:attributedStrings ranges:&attributedRanges];
    _string = [string retain];
    _attributedRanges = [attributedRanges retain];
  }
  return self;
}

- (void)dealloc {
  [_string release];
  [_attributedRanges release];
  [super dealloc];
}

- (void)_onAttributesChange {
  if ([_attributedRanges count] > 1)
    [_attributedRanges sortUsingSelector:@selector(compare:)];
}

- (NSString *)description {
  return YKDescription(@"string", @"attributedRanges");
}

/*!
 Checks to make sure there are no overlapping ranges.   
 If there is no overlap, the overlapping range will be set
 @result Returns YES if ok, NO otherwise. 
 */
- (BOOL)_checkAttributeRanges:(YPAttributedRange **)range {
  if ([_attributedRanges count] <= 1) return YES;
  
  NSInteger lastPosition = -1;
  for(YPAttributedRange *ar in _attributedRanges) {
    if (lastPosition > (NSInteger)ar.range.location) {
      *range = ar;
      return NO;
    }
    lastPosition = ar.range.location + ar.range.length;   
  } 
  return YES;
}

- (YPAttributedRange *)_findRange:(NSRange)range {
  for(YPAttributedRange *ar in _attributedRanges) {
    if (NSEqualRanges(ar.range, range)) return ar;
    if (ar.range.location > range.location) break;
  }
  return nil;
}

- (void)addAttributes:(YPStringAttributes *)attributes range:(NSRange)range {
  if ((range.location + range.length) > [_string length]) 
    [NSException raise:NSInvalidArgumentException format:@"Invalid range: %@ on string: %@ (length=%d)", NSStringFromRange(range), _string, [_string length]];  
  
  YPAttributedRange *ar = [self _findRange:range];
  if (ar) {
    [ar mergeAttributes:attributes];
    return;
  }
    
  ar = [[[YPAttributedRange alloc] initWithRange:range attributes:attributes source:nil] autorelease];
  [_attributedRanges addObject:ar];
  [self _onAttributesChange];
  YPAttributedRange *overlap = nil;
  if (![self _checkAttributeRanges:&overlap]) {
    [_attributedRanges removeObject:ar];
    [NSException raise:NSInvalidArgumentException format:@"The attributed range: %@ overlaps with an existing range: %@", ar, overlap];
  }
}

- (void)addFontAttribute:(UIFont *)font range:(NSRange)range {
  [self addAttributes:[YPStringAttributes font:font] range:range];
}

- (void)addColorAttribute:(UIColor *)color range:(NSRange)range {
  [self addAttributes:[YPStringAttributes color:color] range:range];
}

- (NSArray *)attributedStringArray {
  NSMutableArray *attributedText = [NSMutableArray array];
  NSInteger lastPosition = -1;
  for(YPAttributedRange *ar in _attributedRanges) {
    NSInteger gapLength = (NSInteger)ar.range.location - (lastPosition + 1); // Length of text in between attributed substrings
    if (gapLength > 0) {
      NSString *string = [_string substringWithRange:NSMakeRange(lastPosition + 1, gapLength)];
      [attributedText addObject:[[[YKAttributedString alloc] initWithString:string stringAttributes:nil source:ar.source] autorelease]];
    }
    
    [attributedText addObject:[[[YKAttributedString alloc] initWithString:[_string substringWithRange:ar.range] stringAttributes:ar.attributes source:ar.source] autorelease]];
    lastPosition = ar.range.location + ar.range.length;
  }
  
  NSInteger endGapLength = [_string length] - (lastPosition + 1);
  if (endGapLength > 0)
    [attributedText addObject:[[[YKAttributedString alloc] initWithString:[_string substringWithRange:NSMakeRange(lastPosition + 1, endGapLength)] stringAttributes:nil source:nil] autorelease]];

  return attributedText;
}


@end


@implementation YPAttributedRange 

@synthesize range=_range, attributes=_attributes, source=_source;

- (id)initWithRange:(NSRange)range attributes:(YPStringAttributes *)attributes source:(YKAttributedString *)source {
  if ((self = [super init])) {
    _range = range;
    _attributes = [attributes retain];
    _source = [source retain];
  }
  return self;
}

- (void)dealloc {
  [_attributes release];
  [_source release];
  [super dealloc];
}

- (void)mergeAttributes:(YPStringAttributes *)attributes {
  UIFont *font = nil;
  UIColor *color = nil;
  CGRect rect = CGRectNull;
  NSInteger lineNumber = -1;
  UILineBreakMode lineBreakMode = -1;
  NSString *linkURLString = nil;
  
  if (attributes.font) font = attributes.font;
  else font = _attributes.font;
  if (attributes.color) color = attributes.color;
  else color = _attributes.color;
  if (!CGRectIsNull(attributes.rect)) rect = attributes.rect;
  else rect = _attributes.rect;
  BOOL touchable = _attributes.touchable | attributes.touchable;
  if (attributes.lineNumber != -1) lineNumber = attributes.lineNumber;
  else lineNumber = _attributes.lineNumber;
  if (attributes.lineBreakMode != -1) lineBreakMode = attributes.lineBreakMode;
  else lineBreakMode = _attributes.lineBreakMode;
  if (attributes.linkURLString) linkURLString = attributes.linkURLString;
  else linkURLString = _attributes.linkURLString;
  
  [_attributes release];
  _attributes = [[YPStringAttributes alloc] initWithFont:font color:color rect:rect touchable:touchable lineNumber:lineNumber 
                                           lineBreakMode:lineBreakMode linkURLString:linkURLString];
}

+ (NSString *)joinAttributedStrings:(NSArray *)attributedStrings ranges:(NSArray **)ranges {
  NSMutableString *string = [NSMutableString string];
  NSMutableArray *attributedRanges = [NSMutableArray array];
  for(YKAttributedString *s in attributedStrings) {
    NSRange range = NSMakeRange(string.length, [s.string length]);
    YPAttributedRange *attributedRange = [[[YPAttributedRange alloc] initWithRange:range attributes:s.attributes source:s] autorelease];
    [attributedRanges addObject:attributedRange];
    [string appendString:s.string];
  }
  
  if (ranges) *ranges = attributedRanges;
  return string;
}


- (NSString *)description {
  return YKDescription(@"range", @"attributes");
}

- (NSComparisonResult)compare:(YPAttributedRange *)obj {
  if (_range.location < obj.range.location) return NSOrderedAscending;
  else if (_range.location > obj.range.location) return NSOrderedDescending;
  else return NSOrderedSame;  
}

@end

