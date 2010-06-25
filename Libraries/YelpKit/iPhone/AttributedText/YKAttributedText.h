//
//  YKAttributedText.h
//  YelpKit
//
//  Created by Gabriel Handford on 12/3/08.
//  Copyright 2008. All rights reserved.
//

#import "YKAttributedString.h"


/*!
 AttributedText is a string with a set of (range, attribute) pairs.
 You can generate an array of AttributedString from AttributedText using #attributedStringArray.
 
 This class is best for when you have text that you want to set attributes on. If you want to build attributed text via
 segments of attributed strings, then you should build an array of YKAttributedString directly.

 @code
  YKAttributedText *text = [[[YKAttributedText alloc] initWithString:@"Everything was absolutely wonderful and the sangria is great. (in 231 reviews)"] autorelease];   
  [text addFontAttribute:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(44, 7)];
  [text addFontAttribute:[UIFont systemFontOfSize:14] range:NSMakeRange(62, 16)];
  [text addColorAttribute:[UIColor grayColor] range:NSMakeRange(62, 16)];
  NSArray *attributedStrings = [text attributedStringArray];
  for(YKAttributedString *s in attributedStrings) {
    // Attributed string with properties: s.string, s.color, s.font, s.attributes
  }
 @endcode
*/

@interface YKAttributedText : NSObject {
  NSString *_string;
  NSMutableArray *_attributedRanges; // of YPAttributedRange  
}

@property (readonly, retain, nonatomic) NSString *string;
@property (readonly, retain, nonatomic) NSArray *attributedRanges;

- (id)initWithString:(NSString *)string;

// Creates attributed text from array of attributed strings
- (id)initWithAttributedStrings:(NSArray *)attributedRanges;

// Add or merge attributes for range.
// Overlapping with existing range will throw an NSInvalidArgumentException.
- (void)addAttributes:(YPStringAttributes *)attributes range:(NSRange)range;

// Add a font attribute with range.
- (void)addFontAttribute:(UIFont *)font range:(NSRange)range;

- (void)addColorAttribute:(UIColor *)color range:(NSRange)range;

// To go back to attributed strings
- (NSArray *)attributedStringArray;

@end

/*!
 YPAttributedRange is a range with attributes.
 */
@interface YPAttributedRange : NSObject {
  NSRange _range;
  YPStringAttributes *_attributes;
  YKAttributedString *_source; // If we derived from original attributes
}

@property (readonly, nonatomic) NSRange range;
@property (readonly, nonatomic) YPStringAttributes *attributes;
@property (readonly, nonatomic) YKAttributedString *source;

- (id)initWithRange:(NSRange)range attributes:(YPStringAttributes *)attributes source:(YKAttributedString *)source;

/*!
 Join attributed strings into a single string with ranges
 If you join: "foo", "bars" 
 Joined would be "foobars" with ranges (0, 3), (3, 4)
 
 @param attributedStrings Array of YKAttributedString
 @param ranges Autoreleased array of ranges (optional, can be nil)
 @result Joined string
 */
+ (NSString *)joinAttributedStrings:(NSArray *)attributedStrings ranges:(NSArray **)ranges;

/*!
 Merge attributes with existing attributes.
 Passed in attributes override any existing attributes if set.
 @param attributes Attributes to merge in (override existing)
 */
- (void)mergeAttributes:(YPStringAttributes *)attributes;

@end


