//
//  YKAttributedString.h
//  YelpKit
//
//  Created by Gabriel Handford on 6/12/09.
//  Copyright 2009. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

@class YPStringAttributes;

/*!
 AttributedString is a string with (display) properties like, color and font.
 */
@interface YKAttributedString : NSObject {
  NSString *_string;
  YPStringAttributes *_attributes;
  YKAttributedString *_source; // If we derived from original attributes
}

@property (readonly, nonatomic) NSString *string;
@property (readonly, nonatomic) YPStringAttributes *attributes;
@property (readonly, nonatomic) UIColor *color; // Forwards to attributes.color
@property (readonly, nonatomic) UIFont *font; // Forwards to attributes.font
@property (readonly, nonatomic) CGRect rect; // Forwards to attributes.rect; Cached position and bounds for quick drawing
@property (readonly, nonatomic) BOOL touchable; // Forwards to attributes.touchable
@property (readonly, nonatomic) NSInteger lineNumber; // Forwards to attributes.lineNumber
@property (readonly, nonatomic) UILineBreakMode lineBreakMode; // Forwards to attributes.lineBreakMode
@property (readonly, nonatomic) NSString *linkURLString; // Forwards to attributes.linkURLString
@property (readonly, nonatomic) YKAttributedString *source;

@property (assign, nonatomic) CGFloat lineWidth; // Forwards to attributes.lineWidth

/*! 
 @param string String
 @param stringAttributes Attributes, can be nil; font (UIFont), color (UIColor) 
 */
- (id)initWithString:(NSString *)string stringAttributes:(YPStringAttributes *)stringAttributes source:(YKAttributedString *)source;

/*!
 Bottom right corner of string.
 */
- (CGPoint)endPosition;

/*!
 Create attributed string with no attributes.
 @param string String
 @result String with no attributes
 */
+ (YKAttributedString *)string:(NSString *)string;

+ (YKAttributedString *)string:(NSString *)string color:(UIColor *)color;

/*!
 Create attributed string with font and color.
 @param string String to attribute
 @param font Font
 @param color Color
 @result String with font and color attributes
 */
+ (YKAttributedString *)string:(NSString *)string font:(UIFont *)font color:(UIColor *)color;

+ (YKAttributedString *)string:(NSString *)string font:(UIFont *)font color:(UIColor *)color touchable:(BOOL)touchable linkURLString:(NSString *)linkURLString;

+ (YKAttributedString *)string:(NSString *)string font:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect touchable:(BOOL)touchable 
                    lineNumber:(NSInteger)lineNumber source:(YKAttributedString *)source lineBreakMode:(UILineBreakMode)lineBreakMode
                 linkURLString:(NSString *)linkURLString;

/*!
 Create attributed strings from text.
 */
+ (NSArray *)stringsFromAttributedText:(NSString *)text font:(UIFont *)font boldFont:(UIFont *)boldFont color:(UIColor *)color linkColor:(UIColor *)linkColor;

/*!
 Compute the drawable attributed strings based on specified width.
 @param width Width to fit text in
 @param attributedStrings Strings to format
 @param size Total size
 @param linePadding Line padding (+/-)
 @param defaultFont Default font to use if attributed text does not specify
 @param maxLineCount Max number of lines
 @param skipEmptyLines If YES, will ignore empty lines
 @result An array of YKAttributedString's
 */
+ (NSArray *)formatForWidth:(CGFloat)width attributedStrings:(NSArray *)attributedStrings size:(CGSize*)size linePadding:(CGFloat)linePadding withDefaultFont:(UIFont *)defaultFont 
               maxLineCount:(NSInteger)maxLineCount skipEmptyLines:(BOOL)skipEmptyLines;

/*!
 Format width on single attributed string.
 @param width Width to wrap on
 @param size Total size
 @param linePadding Line padding (+/-)
 @param defaultFont Default font to use if attributed text does not specify
 @result An array of YKAttributedString's
 */
- (NSArray *)formatForWidth:(CGFloat)width size:(CGSize*)size linePadding:(CGFloat)linePadding withDefaultFont:(UIFont *)defaultFont;

/*!
 Get formatted attributed string for width from a string.
 */
+ (NSArray *)formatString:(NSString *)string forWidth:(CGFloat)width font:(UIFont *)font size:(CGSize *)size;

/*!
 Height to fit attributed text with line width.
 
 You might as well use formatForWidth and then use heightForLineCount:attributedStrings: on the formatted strings. That way you only have to
 format the strings in a single pass
 
 @param width Line width
 @param defaultFont Default font
 @param maxLineCount Max number of lines (-1 for no max)
 @result Height to fit
 */
+ (CGFloat)heightThatFitsWidth:(CGFloat)width attributedStrings:(NSArray *)attributedStrings withDefaultFont:(UIFont *)defaultFont maxLineCount:(NSInteger)maxLineCount;

/*!
 Draw a list of attributed strings in rect.
 A graphics context should be available when this is called.
 @param strings
 @param defaultColor Default color
 @param defaultTouchableTextColor Default color for touchable strings
 @param defaultFont Default font
 @param textAlignment Alignment (when supported, heh)
 @param contentVerticalAlignment Vertical content alignment
 @param rect Rect to draw in
 @param maxLineCount Maximum number of lines to draw (-1 to draw all lines)
 @param lastLineWidth Custom width for last line (if we wanted to leave room to show a 'More' or 'Less' link)
 @result Returns the last string that we drew
 */
+ (YKAttributedString *)drawStrings:(NSArray */*of YKAttributedString*/)strings defaultColor:(UIColor *)defaultColor defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor defaultFont:(UIFont *)defaultFont 
                      textAlignment:(UITextAlignment)textAlignment contentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment
                              rect:(CGRect)rect maxLineCount:(NSInteger)maxLineCount lastLineWidth:(CGFloat)lastLineWidth;

/*!
 Draw strings in context.
 (see drawStrings: above)
 */
+ (YKAttributedString *)drawStrings:(NSArray */*of YKAttributedString*/)strings context:(CGContextRef)context defaultColor:(UIColor *)defaultColor defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor 
                        defaultFont:(UIFont *)defaultFont textAlignment:(UITextAlignment)textAlignment contentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment
                       rect:(CGRect)rect maxLineCount:(NSInteger)maxLineCount lastLineWidth:(CGFloat)lastLineWidth;

/*!
 Get the height needed to draw the number of lines from a list of attributed strings.
 Helps determine preferred size.
 @param lineCount
 @param attributedStrings
 @result Height
 */
+ (CGFloat)heightForLineCount:(NSInteger)lineCount attributedStrings:(NSArray *)attributedStrings;

/*!
 Draw at point.
 @param point
 */
- (void)drawAtPoint:(CGPoint)point;

@end


/*!
 Attributes for a string.
 */
@interface YPStringAttributes : NSObject {
  UIFont *_font;  
  UIColor *_color;
  CGRect _rect;
  BOOL _touchable;
  NSInteger _lineNumber;
  CGFloat _lineWidth;
  UILineBreakMode _lineBreakMode;
  NSString *_linkURLString;
}

@property (readonly, nonatomic) UIFont *font;
@property (readonly, nonatomic) UIColor *color;
@property (readonly, nonatomic) CGRect rect;
@property (readonly, nonatomic) BOOL touchable;
@property (readonly, nonatomic) NSInteger lineNumber;
@property (readonly, nonatomic) UILineBreakMode lineBreakMode;
@property (readonly, nonatomic) NSString *linkURLString;
@property (assign, nonatomic) CGFloat lineWidth;

- (id)initWithFont:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect touchable:(BOOL)touchable lineNumber:(NSInteger)lineNumber
     lineBreakMode:(UILineBreakMode)lineBreakMode linkURLString:(NSString *)linkURLString;;

+ (YPStringAttributes *)font:(UIFont *)font;
+ (YPStringAttributes *)color:(UIColor *)color;
+ (YPStringAttributes *)font:(UIFont *)font color:(UIColor *)color;
+ (YPStringAttributes *)font:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect touchable:(BOOL)touchable lineNumber:(NSInteger)lineNumber
               lineBreakMode:(UILineBreakMode)lineBreakMode linkURLString:(NSString *)linkURLString;;


@end