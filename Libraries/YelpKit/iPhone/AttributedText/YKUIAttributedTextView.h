//
//  YKUIAttributedTextView.h
//  YelpKit
//
//  Created by Gabriel Handford on 12/3/08.
//  Copyright 2008. All rights reserved.
//

#import "YKAttributedText.h"

@class YKUIAttributedTextView;

@protocol YKUIAttributedTextViewDelegate <NSObject>
- (void)attributedTextView:(YKUIAttributedTextView *)attributedTextView didSelectAttributedString:(YKAttributedString *)attributedString;
@end

@class YKUIAttributedTextViewDataSource;

/*!
 Attributed text view. 
 */
@interface YKUIAttributedTextView : UIControl {
    
  UIColor *_textColor; // Default text color for non-attributed text
  UIColor *_touchableTextColor; // Default text color for touchable text
  UITextAlignment _textAlignment; 
  UIControlContentVerticalAlignment _contentVerticalAlignment;
  
  UIColor *_shadowColor; // Defaults to nil
  CGSize _shadowOffset;
  
  BOOL _highlightEnabled; // Whether highlighting is enabled
  CGRect _highlightRect; // Region to mark as highlighted
  BOOL _temporaryHighlight; // If YES, highlight is temporary and will be reset after it is drawn
  
  UIFont *_defaultFont; // Default font when using setText:
  
  YKUIAttributedTextViewDataSource *_textDataSource;

  id<YKUIAttributedTextViewDelegate> _textDelegate; // weak
}

@property (retain, nonatomic) YKUIAttributedTextViewDataSource *dataSource;
@property (assign, nonatomic) id<YKUIAttributedTextViewDelegate> delegate;

@property (retain, nonatomic) UIColor *textColor;
@property (retain, nonatomic) UIColor *touchableTextColor;
@property (assign, nonatomic) UITextAlignment textAlignment;
@property (assign, nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
@property (assign, nonatomic) BOOL highlightEnabled;

@property (retain, nonatomic) UIColor *shadowColor; // Defaults to nil
@property (assign, nonatomic) CGSize shadowOffset;

@property (retain, nonatomic) UIFont *defaultFont;


/*!
 Set attributed strings.
 @param attributedStrings
 @param defaultFont
 @param width
 @param contentEdgeInsets
 */
- (void)setAttributedStrings:(NSArray *)attributedStrings defaultFont:(UIFont *)defaultFont width:(CGFloat)width contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets;

/*!
 Set attributed strings.
 @param attributedStrings
 @param defaultFont
 @param width
 @param maxLineCount
 @param contentEdgeInsets
 */
- (void)setAttributedStrings:(NSArray *)attributedStrings defaultFont:(UIFont *)defaultFont width:(CGFloat)width maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets;

- (void)setAttributedStrings:(NSArray *)attributedStrings defaultFont:(UIFont *)defaultFont;

/*!
 Set text (with default font).
 @param text
 */
- (void)setText:(NSString *)text;

/*!
 Set text for current width.
 @param text Text
 @param font Font
 */
- (void)setText:(NSString *)text font:(UIFont *)font;

/*!
 Set text for specified width.
 @param text Text
 @param font Font
 @param width Width
 */
- (void)setText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

/*!
 Set text for current width.
 @param text Text
 @param font Font
 @param contentEdgeInsets Content edge insets (Defaults to UIEdgeInsetsZero)
 */
- (void)setText:(NSString *)text font:(UIFont *)font contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets;

/*!
 Set text for specified width.
 @param text Text
 @param font Font
 @param width Width to wrap on
 @param contentEdgeInsets Content edge insets (Defaults to UIEdgeInsetsZero)
 @param maxLineCount Max line count, -1 for no max
 */
- (void)setText:(NSString *)text font:(UIFont *)font width:(CGFloat)width contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets maxLineCount:(NSInteger)maxLineCount;

/*!
 Set attributed text.
 @param text Text, like <b>Foo</b><br/>Bar
 @param defaultFont
 @param defaultBoldFont
 @param width
 @param contentEdgeInsets
 @param color
 @param linkColor
 */
- (void)setAttributedText:(NSString *)text defaultFont:(UIFont *)defaultFont defaultBoldFont:(UIFont *)defaultBoldFont 
                    width:(CGFloat)width contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets 
                    color:(UIColor *)color linkColor:(UIColor *)linkColor; 

/*!
 Set attributed text.
 @param text Text, like <b>Foo</b><br/>Bar
 @param defaultFont
 @param defaultBoldFont
 @param width
 @param maxLineCount
 @param contentEdgeInsets
 @param color
 @param linkColor
 */
- (void)setAttributedText:(NSString *)text defaultFont:(UIFont *)defaultFont defaultBoldFont:(UIFont *)defaultBoldFont 
                    width:(CGFloat)width maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets 
                    color:(UIColor *)color linkColor:(UIColor *)linkColor;

/*!
 Get attributed string at point in this view.
 @param p Point
 @param touchableOnly If YES, will only return string if it was touchable
 @param visibleOnly If YES, will stop looking after we encounter the last visible string
 @param padding Amount of padding to expand strings touchable region by. (size.width is added to left/right, size.height to top/bottom)
 @result String at that point
 */
- (YKAttributedString *)attributedStringAtPoint:(CGPoint)point touchableOnly:(BOOL)touchableOnly visibleOnly:(BOOL)visibleOnly padding:(CGSize)padding;

- (void)highlight:(YKAttributedString *)string;

/*!
 Programmatically touch the string at point with phase.
 @param point
 @param phase
 @param padding
 */
- (void)touchAtPoint:(CGPoint)point phase:(UITouchPhase)phase padding:(CGSize)padding;

/*!
 Draw text in rect.
 @param rect
 @result The ending point where we stopped
 */
- (CGPoint)drawTextInRect:(CGRect)rect;

@end


@interface YKUIAttributedTextViewDataSource : NSObject {

  NSArray */*of YKAttributedString*/_formattedStrings; // Formatted for current width
  
  CGSize _sizeThatFits; 
  UIFont *_defaultFont; // Default font for non-attributed text
  NSInteger _maxLineCount;
  
  UIEdgeInsets _contentEdgeInsets; // Edge insets for text
      
  CGFloat _formatWidth; // Width we formatted at  

  // Special options for expandable/collapsing text view
  CGFloat _lastLineWidth;
  CGFloat _collapsedHeightThatFits;
  NSInteger _collapsedLineCount;
  BOOL _expanded; // Defaults to NO
  BOOL _expandable; // Defaults to NO
  CGPoint _textOrigin;
  CGFloat _moreLinkOffset;

  CGFloat _maxLineWidth;
}

@property (readonly, nonatomic) NSArray *formattedStrings; 

@property (readonly, nonatomic) UIFont *defaultFont;
@property (readonly, nonatomic) NSInteger lineCount;

@property (assign, nonatomic, getter=isExpanded) BOOL expanded;
@property (readonly, nonatomic, getter=isCollapsed) BOOL collapsed;
@property (assign, nonatomic, getter=isExpandable) BOOL expandable;
@property (readonly, nonatomic) CGFloat collapsedHeightThatFits;
@property (readonly, nonatomic) NSInteger collapsedLineCount;
@property (readonly, nonatomic) CGPoint textOrigin;
@property (readonly, nonatomic) UIEdgeInsets contentEdgeInsets;
@property (assign, nonatomic) CGFloat moreLinkOffset; //! Offset from right edge to draw More/Less text.  Default is 50.
@property (readonly, nonatomic) CGFloat maxLineWidth;

/*!
 Create data source with string/font.
 @param string String
 @param width Width to format string in
 @param font Font for string
 @param maxLineCount Max number of lines, -1 for no max
 */
- (id)initWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maxLineCount:(NSInteger)maxLineCount;

/*!
 Create data source with string/font.
 @param string String
 @param width Width to format string in
 @param font Font for string
 @param maxLineCount Max number of lines, -1 for no max
 @param contentEdgeInsets Insets
 */
- (id)initWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets;

/*!
 Create data source with attributed strings.
 @param attributedStrings Strings to format
 @param width Width to format strings in
 @param defaultFont Default font if not specified in string
 @param contentEdgeInsets Insets
 */
- (id)initWithAttributedStrings:(NSArray *)attributedStrings width:(CGFloat)width defaultFont:(UIFont *)defaultFont contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets;

- (id)initWithString:(NSString *)string width:(CGFloat)width font:(UIFont *)font maxLineCount:(NSInteger)maxLineCount 
   contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets linePadding:(CGFloat)linePadding;

/*!
 Create data source with attributed strings.
 @param attributedStrings Strings to format
 @param width Width to format strings in
 @param defaultFont Default font if not specified in string
 @param maxLineCount Max number of lines, -1 for no max
 @param skipEmptyLines If YES, will not include empty lines
 @param contentEdgeInsets Insets
 @param linePadding
 */
- (id)initWithAttributedStrings:(NSArray */*of YKAttributedString*/)attributedStrings width:(CGFloat)width defaultFont:(UIFont *)defaultFont 
                   maxLineCount:(NSInteger)maxLineCount skipEmptyLines:(BOOL)skipEmptyLines contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
                    linePadding:(CGFloat)linePadding;

/*!
 Create data source with attributed strings.
 @param attributedStrings Strings to format
 @param width Width to format strings in
 @param collapsedLineCount Number of lines to show in collapsed view
 @param defaultFont Default font if not specified in string
 @param lastLineWidth Width of last line; Defaults to -1
 @param linePadding
 */
- (id)initWithAttributedStrings:(NSArray */*of YKAttributedString*/)attributedStrings width:(CGFloat)width collapsedLineCount:(NSInteger)collapsedLineCount 
                    defaultFont:(UIFont *)defaultFont lastLineWidth:(CGFloat)lastLineWidth linePadding:(CGFloat)linePadding;

/*!
 Set attributed text.
 @param text Text, like <b>Foo</b><br/>Bar
 @param defaultFont
 @param defaultBoldFont
 @param width
 @param maxLineCount
 @param contentEdgeInsets
 @param color
 @param linkColor
 */
- (id)initWithAttributedText:(NSString *)text defaultFont:(UIFont *)defaultFont defaultBoldFont:(UIFont *)defaultBoldFont 
                       width:(CGFloat)width maxLineCount:(NSInteger)maxLineCount contentEdgeInsets:(UIEdgeInsets)contentEdgeInsets 
                       color:(UIColor *)color linkColor:(UIColor *)linkColor;

- (CGSize)sizeThatFits:(CGSize)size;

- (CGFloat)heightThatFits;

/*!
 The last visible string.
 @result The last visible string
 */
- (YKAttributedString *)lastVisibleString;

- (CGPoint)drawInRect:(CGRect)rect defaultColor:(UIColor *)defaultColor defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor 
         textAlignment:(UITextAlignment)textAlignment;

- (CGPoint)drawInRect:(CGRect)rect defaultColor:(UIColor *)defaultColor defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor 
         textAlignment:(UITextAlignment)textAlignment contentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment;

@end

