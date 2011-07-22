//
//  YKAttributedString.m
//  YelpKit
//
//  Created by Gabriel Handford on 6/12/09.
//  Copyright 2009. All rights reserved.
//

#import "YKAttributedString.h"

#import "YKCGUtils.h"
#import "YKAttributedTextParser.h"
#import "YKDefines.h"

@interface YKAttributedString ()
//! Returns a character set for characters that should be word-wrapped around
+ (NSCharacterSet *)_wordWrapCharacterSet;
@end


@implementation YKAttributedString

#define kYKAttributedStringDebug NO

@synthesize string=_string, attributes=_attributes, source=_source;

- (id)initWithString:(NSString *)string stringAttributes:(YPStringAttributes *)stringAttributes source:(YKAttributedString *)source {
  if (!string) string = @"";
  
  if ((self = [super init])) {
    _string = [string retain];
    _attributes = [stringAttributes retain];
    _source = [source retain];
  }
  return self;
}

+ (YKAttributedString *)string:(NSString *)string {
  return [[[YKAttributedString alloc] initWithString:string stringAttributes:nil source:nil] autorelease];
}

+ (YKAttributedString *)string:(NSString *)string color:(UIColor *)color {
  return [[[YKAttributedString alloc] initWithString:string stringAttributes:[YPStringAttributes font:nil color:color] source:nil] autorelease];
}

+ (YKAttributedString *)string:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
  return [[[YKAttributedString alloc] initWithString:string stringAttributes:[YPStringAttributes font:font color:color] source:nil] autorelease];
}

+ (YKAttributedString *)string:(NSString *)string font:(UIFont *)font color:(UIColor *)color touchable:(BOOL)touchable linkURLString:(NSString *)linkURLString {
  return [[[YKAttributedString alloc] initWithString:string stringAttributes:[YPStringAttributes font:font color:color rect:CGRectNull touchable:touchable lineNumber:-1 lineBreakMode:-1 linkURLString:linkURLString] source:nil] autorelease];
}

+ (YKAttributedString *)string:(NSString *)string font:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect touchable:(BOOL)touchable 
                    lineNumber:(NSInteger)lineNumber source:(YKAttributedString *)source lineBreakMode:(UILineBreakMode)lineBreakMode
                 linkURLString:(NSString *)linkURLString {
  return [[[YKAttributedString alloc] initWithString:string stringAttributes:
           [YPStringAttributes font:font color:color rect:rect touchable:touchable 
                         lineNumber:lineNumber lineBreakMode:lineBreakMode linkURLString:linkURLString] source:source] autorelease];
}

+ (NSArray *)stringsFromAttributedText:(NSString *)text font:(UIFont *)font boldFont:(UIFont *)boldFont color:(UIColor *)color linkColor:(UIColor *)linkColor {
  NSMutableArray *attributedStrings = [[NSMutableArray alloc] init];
  YKAttributedTextParser *parser = [[YKAttributedTextParser alloc] initWithColor:color linkColor:linkColor font:font boldFont:boldFont];
  [parser parseXML:text attributedStrings:&attributedStrings error:nil];
  [parser release];
  return [attributedStrings autorelease];
}  

- (void)dealloc {
  [_string release];
  [_attributes release];
  [_source release];
  [super dealloc];
}

- (UIFont *)font {
  return _attributes.font;
}

- (UIColor *)color {
  return _attributes.color;
}

- (CGRect)rect {
  return _attributes.rect;
}

- (BOOL)touchable {
  return _attributes.touchable;
}

- (NSInteger)lineNumber {
  return _attributes.lineNumber;
}

- (CGFloat)lineWidth {
  return _attributes.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
  _attributes.lineWidth = lineWidth;
}

- (UILineBreakMode)lineBreakMode {
  return _attributes.lineBreakMode;
}

- (NSString *)linkURLString {
  return _attributes.linkURLString;
}

- (CGPoint)endPosition {
  return CGPointMake(self.rect.origin.x + self.rect.size.width, self.rect.origin.y + self.rect.size.height);
}

- (NSString *)description {
  return YKDescription(@"string", @"attributes");
}

- (BOOL)isEqual:(id)obj { 
  if (![obj isMemberOfClass:[YKAttributedString class]]) return NO;
  if ([[obj string] isEqual:_string] && 
      (_attributes == (YPStringAttributes *)[obj attributes] ||
       [[obj attributes] isEqual:_attributes])) return YES;
  return NO;
}

- (NSUInteger)hash {
  return _string.hash;
}

- (void)drawAtPoint:(CGPoint)point {
  CGPoint ps = self.rect.origin;
  CGPoint p = CGPointMake(point.x + ps.x, point.y + ps.y);
  
  if (self.lineBreakMode != -1) {
    [self.string drawAtPoint:p forWidth:self.rect.size.width withFont:self.font lineBreakMode:self.lineBreakMode];
  } else {
    [self.string drawAtPoint:p withFont:self.font];
  }
}

+ (YKAttributedString *)drawStrings:(NSArray */*of YKAttributedString*/)strings defaultColor:(UIColor *)defaultColor defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor 
                        defaultFont:(UIFont *)defaultFont textAlignment:(UITextAlignment)textAlignment contentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment
                               rect:(CGRect)rect maxLineCount:(NSInteger)maxLineCount lastLineWidth:(CGFloat)lastLineWidth {
  
  CGContextRef context = UIGraphicsGetCurrentContext(); 
  return [self drawStrings:strings context:context defaultColor:defaultColor defaultTouchableTextColor:defaultTouchableTextColor defaultFont:defaultFont textAlignment:textAlignment 
    contentVerticalAlignment:contentVerticalAlignment rect:rect maxLineCount:maxLineCount lastLineWidth:lastLineWidth];
} 

+ (YKAttributedString *)drawStrings:(NSArray */*of YKAttributedString*/)strings 
                            context:(CGContextRef)context 
                       defaultColor:(UIColor *)defaultColor 
          defaultTouchableTextColor:(UIColor *)defaultTouchableTextColor 
                        defaultFont:(UIFont *)defaultFont 
                      textAlignment:(UITextAlignment)textAlignment 
           contentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment
                               rect:(CGRect)rect 
                       maxLineCount:(NSInteger)maxLineCount 
                      lastLineWidth:(CGFloat)lastLineWidth {
  
  if ([strings count] == 0) return nil;
  if (maxLineCount == 0) {
    YPWarn(@"Max line count is 0");
    return nil;
  }
    
  YKAttributedString *allLastString = [strings lastObject];
  // We are truncated if we have more lines than the max or the last string line width is greater than last line width
  BOOL isTruncated = ((allLastString.lineNumber > maxLineCount) || (allLastString.lineNumber == maxLineCount && allLastString.endPosition.x > lastLineWidth));
  BOOL isLastLine;
  CGPoint p;
  CGFloat width = rect.size.width;
  YKAttributedString *lastString = nil;
  
  // Center vertically (experimental)
  if (allLastString && contentVerticalAlignment == UIControlContentVerticalAlignmentCenter && rect.size.height >= 0) {    
    CGFloat voffset = (rect.size.height / 2.0 - allLastString.endPosition.y / 2.0);
    if (voffset < 0) voffset = 0;
    rect.origin.y += voffset;
  }

  UIColor *lastColor = nil;
  for(YKAttributedString *s in strings) {   
    if (maxLineCount != -1 && s.lineNumber > maxLineCount) {
      break;
    }
    isLastLine = (maxLineCount != -1 && s.lineNumber >= maxLineCount);
    UIColor *textColor = s.color;
    if (!textColor && s.touchable) textColor = defaultTouchableTextColor;
    else if (!textColor) textColor = defaultColor;
    
    if (![textColor isEqual:lastColor]) {
      if (context != NULL) CGContextSetFillColorWithColor(context, textColor.CGColor);
      lastColor = textColor;
    }
    
    CGPoint ps = s.rect.origin;
    p = CGPointMake(rect.origin.x + ps.x, rect.origin.y + ps.y);
    
    // TODO(gabe): This only works with strings that are full lines
    if (textAlignment == UITextAlignmentCenter && s.lineWidth > 0) {
      p.x += roundf((width / 2.0) - (s.lineWidth / 2.0));
    }
    
//    if (isLastLine)
//      YPDebug(@"Last line: %@ (truncated=%d, lastLineWidth=%0f, endPosition=%0f)", s, isTruncated, lastLineWidth, s.endPosition); 
    
    if (isTruncated && isLastLine && lastLineWidth > 0) {
      if (context != NULL) {
        if (kYKAttributedStringDebug) CGContextStrokeRectWithWidth(context, YKCGRectAddPoint(s.rect, rect.origin), 0.2);
        // Make sure there's enough room for an ellipsis
        if (lastLineWidth - p.x > 15)
          [s.string drawAtPoint:p forWidth:lastLineWidth - p.x withFont:s.font lineBreakMode:UILineBreakModeTailTruncation];
        lastString = s;
      }
    } else {
      if (s.lineBreakMode != -1) {
        if (context != NULL)  {
          if (kYKAttributedStringDebug) CGContextStrokeRectWithWidth(context, YKCGRectAddPoint(s.rect, rect.origin), 0.2);
          [s.string drawAtPoint:p forWidth:s.rect.size.width withFont:s.font lineBreakMode:s.lineBreakMode];
        }       
      } else {        
        if (context != NULL) {
          if (kYKAttributedStringDebug) CGContextStrokeRectWithWidth(context, YKCGRectAddPoint(s.rect, rect.origin), 0.2);
          [s.string drawAtPoint:p withFont:s.font];
          //if (append) [append drawAtPoint:CGPointMake(p.x + s.rect.size.width, p.y) withFont:defaultFont];
        }
      }
      lastString = s;
      // Update our position, in case we break, so we can return the exact position 
      // we left off to the caller
      //p.x += s.rect.size.width;
    }   
  }
  return lastString;
} 

/*!
 Format attributed strings according to line width.
 
 We tried to group into lines instead of an attributed string per word.
 
 This is complex because it needs to be efficient.
 
 // TODO(gabe): skipEmptyLines doesn't work when separated by different attributed strings
 
 @param width Width to wrap on
 @param attributedStrings Attributed strings to format
 @param defaultFont The default font if one is not specified
 @param size If specified will be set to the total size of the formatted strings
 @param linePadding Extra line height padding (+/-)
 @param maxLineCount Maximum number of lines before we truncate
 @param lineBreakMode If a string (word) is wider than the width, this defines how we truncate it; Currently wrapping is not supported
 @param skipEmptyLines If YES, will not include empty lines
 */
+ (NSArray */*of YKAttributedString*/)_formatForWidth:(CGFloat)width 
                                    attributedStrings:(NSArray *)attributedStrings
                                      withDefaultFont:(UIFont *)defaultFont 
                                                 size:(CGSize *)size 
                                          linePadding:(CGFloat)linePadding
                                         maxLineCount:(NSInteger)maxLineCount 
                                        lineBreakMode:(UILineBreakMode)lineBreakMode
                                       skipEmptyLines:(BOOL)skipEmptyLines {
  
  CGFloat xOrigin = 0; // Origin for x, whenever we are on a new line
  
  CGFloat xpos = xOrigin;
  CGFloat ypos = 0;
  CGFloat xStart = xpos;
  CGFloat maxLineHeight = 0;
  NSInteger lineNumber = 1;
  CGRect stringRect = CGRectZero;
  
  BOOL isTruncated = NO;
  
  NSMutableArray *formattedStrings = [NSMutableArray arrayWithCapacity:20];
  
  NSMutableString *string = nil;
  
  for(YKAttributedString *attributedString in attributedStrings) {
    UIFont *font = attributedString.font;
    if (!font) font = defaultFont;
    CGFloat lineHeight = [@" " sizeWithFont:font].height + linePadding;
    UIColor *color = attributedString.color;    
    
    GHNSStringEnumerator *enumerator = [[GHNSStringEnumerator alloc] initWithString:attributedString.string
                                                              separatorCharacterSet:[self _wordWrapCharacterSet]];
    [string release];
    string = [[NSMutableString alloc] initWithCapacity:80];
    NSString *word = nil;
    while((word = [enumerator nextObject])) {
      NSInteger newLineCount = [word gh_count:@"\n"];
      
      CGSize wordSize = CGSizeZero;

      if (newLineCount == 0) {
        wordSize = [word sizeWithFont:font];
        if (wordSize.height > maxLineHeight) maxLineHeight = wordSize.height;
      }

      // If word is a newline(s), OR
      // If word does not fit on current line, AND we are not the start of a line
      if ((newLineCount > 0) || 
          ((xpos + wordSize.width > width) && (xpos != xOrigin))) {

        // Increment and check line number against max
        if ((maxLineCount > 0 && lineNumber > maxLineCount) || (ypos + maxLineHeight + wordSize.height) > 4000) {
          isTruncated = YES;
          break;
        }
        
        // If string is too long to fit on line then apply lineBreakMode
        BOOL needsBreak = (xpos > width);
        if (needsBreak) xpos = width;
        
        // TODO(gabe): Line width is wrong if we have more than 1 attributed string
        // If this is last line but string is truncated, add ellipsis
        if (maxLineCount > 0 && lineNumber == maxLineCount && lineBreakMode == UILineBreakModeTailTruncation && [string length] > 3) {
          // Strip trailing whitespace, so ellipsis goes right after any characters
          [string setString:[string gh_rightStrip]];
          // If there is room to append, otherwise replace
          CGFloat ellipsisWidth = [@"…" sizeWithFont:font].width;
          if (width - xpos > ellipsisWidth) {
            [string appendString:@"…"];
            xpos += ellipsisWidth;
          } else {
            [string replaceCharactersInRange:NSMakeRange([string length] - 3, 3) withString:@"…"];
          }
        }
        
        stringRect = CGRectMake(xStart, ypos, xpos - xStart, maxLineHeight);
        
        YKAttributedString *formattedString = [YKAttributedString string:string font:font color:color 
                                                                     rect:stringRect
                                                               touchable:attributedString.touchable lineNumber:lineNumber source:attributedString 
                                                            lineBreakMode:(needsBreak ? lineBreakMode : -1) linkURLString:attributedString.linkURLString];
        [formattedStrings addObject:formattedString];
        
        // Release and alloc since we don't copy when creating YKAttributedString above
        [string release];
        string = [[NSMutableString alloc] initWithCapacity:80];
        
        xpos = xOrigin;
        ypos += maxLineHeight + linePadding;
        maxLineHeight = wordSize.height; // On new line the maxLineHeight defaults to the first word
        xStart = xOrigin;
        
        // If more than 1 newline, than adjust ypos
        lineNumber += 1;
        if (maxLineCount > 0 && lineNumber > maxLineCount) {
          isTruncated = YES;
          break;
        }
        
        // If we have more than 1 newline in a whitespace/newline chunk then we have to be careful to check that we hit the max line count after each line
        // We also insert an empty string with the line number so that we can views can break in between lines
        if (newLineCount > 1 && !skipEmptyLines) {          
          for(NSInteger i = (newLineCount - 1); i < newLineCount; i++) {
            CGRect rect = CGRectMake(xpos, ypos, 0, lineHeight);            
            YKAttributedString *newLineString = [YKAttributedString string:@"" font:nil color:nil rect:rect touchable:NO 
                                                                lineNumber:lineNumber source:attributedString lineBreakMode:-1 linkURLString:nil];
            [formattedStrings addObject:newLineString];
            ypos += lineHeight;
            lineNumber++;
            if (maxLineCount > 0 && lineNumber > maxLineCount) {
              isTruncated = YES;
              break;
            }
          }
        } 
        if (isTruncated) break;
      } 
      if (isTruncated) break;
      
      if (xpos == xOrigin && enumerator.isInSeparator) continue;

      xpos += wordSize.width;
      [string appendString:word];                 
    }
    [enumerator release];
    if (isTruncated) break;
    
    // If string is too long to fit on line then apply lineBreakMode
    BOOL needsBreak = (xpos > width);
    if (needsBreak) xpos = width; 
    
    stringRect = CGRectMake(xStart, ypos, xpos - xStart, maxLineHeight);

    
    YKAttributedString *formattedString = [YKAttributedString string:string font:font color:color 
                                                                 rect:stringRect
                                                            touchable:attributedString.touchable lineNumber:lineNumber source:attributedString 
                                                        lineBreakMode:(needsBreak ? lineBreakMode : -1) linkURLString:attributedString.linkURLString];
    [formattedStrings addObject:formattedString];   
    // Release instead of clearing since we don't copy when creating YKAttributedString above
    [string release];
    string = nil;
    
    // Set next X start position to current
    xStart = xpos;
  }
  
  // Make sure released if we broke out via isTruncated
  [string release];
  string = nil;
  
  if (size != NULL && size) *size = CGSizeMake(width, stringRect.origin.y + stringRect.size.height);
  
  // Go back and fill in line width for each line
  NSInteger ln = -1;
  CGFloat lineWidth = 0;
  for(NSInteger i = [formattedStrings count] - 1; i >= 0; i--) {
    YKAttributedString *as = [formattedStrings objectAtIndex:i];
    if (as.lineNumber != ln) {
      lineWidth = as.rect.origin.x + as.rect.size.width - xOrigin; // Line width is last words x position + width (minus x origin)
      ln = as.lineNumber;
    }
    as.lineWidth = lineWidth;
  }
  
  
  return formattedStrings;
}

+ (NSCharacterSet *)_wordWrapCharacterSet {
  static NSCharacterSet *wrapCharacterSet = nil;
  if (!wrapCharacterSet) {
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [characterSet addCharactersInString:@"-–—"]; // Hyphen, en-dash, em-dash
    // Apple docs say: "Mutable character sets are less efficient to use than immutable
    // character sets. If you don’t need to change a character set after creating it, 
    // create an immutable copy with copy and use that."
    wrapCharacterSet = [characterSet copy];
  }
  return wrapCharacterSet;
}

+ (CGFloat)heightThatFitsWidth:(CGFloat)width attributedStrings:(NSArray *)attributedStrings withDefaultFont:(UIFont *)defaultFont maxLineCount:(NSInteger)maxLineCount {
  CGSize size;
  [self _formatForWidth:width attributedStrings:attributedStrings withDefaultFont:defaultFont size:&size linePadding:0 maxLineCount:maxLineCount lineBreakMode:UILineBreakModeTailTruncation skipEmptyLines:NO];
  return size.height;
}

+ (CGFloat)heightForLineCount:(NSInteger)lineCount attributedStrings:(NSArray *)attributedStrings {
  for(NSInteger i = [attributedStrings count]-1; i >= 0; i--) {
    YKAttributedString *string = [attributedStrings objectAtIndex:i];
    if (string.lineNumber <= lineCount) return (string.rect.origin.y + string.rect.size.height);
  }
  return -1;
}

+ (NSArray *)formatForWidth:(CGFloat)width attributedStrings:(NSArray *)attributedStrings size:(CGSize *)size linePadding:(CGFloat)linePadding
            withDefaultFont:(UIFont *)defaultFont maxLineCount:(NSInteger)maxLineCount skipEmptyLines:(BOOL)skipEmptyLines {
  
  return [self _formatForWidth:width attributedStrings:attributedStrings withDefaultFont:defaultFont size:size linePadding:linePadding maxLineCount:maxLineCount 
                 lineBreakMode:UILineBreakModeTailTruncation skipEmptyLines:skipEmptyLines];  
}

- (NSArray *)formatForWidth:(CGFloat)width size:(CGSize*)size linePadding:(CGFloat)linePadding withDefaultFont:(UIFont *)defaultFont {
  return [YKAttributedString _formatForWidth:width attributedStrings:[NSArray arrayWithObject:self] withDefaultFont:defaultFont size:size linePadding:linePadding maxLineCount:-1 
                               lineBreakMode:UILineBreakModeTailTruncation skipEmptyLines:NO];
}

+ (NSArray *)formatString:(NSString *)string forWidth:(CGFloat)width font:(UIFont *)font size:(CGSize *)size {
  YKAttributedString *attributedString = [[YKAttributedString alloc] initWithString:string];
  NSArray *formatted = [attributedString formatForWidth:width size:size linePadding:0 withDefaultFont:font];
  [attributedString release];
  return formatted;
}

@end



@implementation YPStringAttributes

@synthesize font=_font, color=_color, rect=_rect, touchable=_touchable, lineNumber=_lineNumber, lineBreakMode=_lineBreakMode, linkURLString=_linkURLString, lineWidth=_lineWidth;

- (id)initWithFont:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect touchable:(BOOL)touchable lineNumber:(NSInteger)lineNumber
     lineBreakMode:(UILineBreakMode)lineBreakMode linkURLString:(NSString *)linkURLString {
  if ((self = [super init])) {
    _font = [font retain];
    _color = [color retain];
    _rect = rect;
    _touchable = touchable;
    _lineNumber = lineNumber;
    _lineBreakMode = lineBreakMode;
    _linkURLString = [linkURLString retain];
  }
  return self;
}

+ (YPStringAttributes *)font:(UIFont *)font {
  return [[[YPStringAttributes alloc] initWithFont:font color:nil rect:CGRectNull touchable:NO lineNumber:-1 lineBreakMode:-1 linkURLString:nil] autorelease];
}

+ (YPStringAttributes *)color:(UIColor *)color {
  return [[[YPStringAttributes alloc] initWithFont:nil color:color rect:CGRectNull touchable:NO lineNumber:-1 lineBreakMode:-1 linkURLString:nil] autorelease];
}

+ (YPStringAttributes *)font:(UIFont *)font color:(UIColor *)color {
  return [[[YPStringAttributes alloc] initWithFont:font color:color rect:CGRectNull touchable:NO lineNumber:-1 lineBreakMode:-1 linkURLString:nil] autorelease];
}

+ (YPStringAttributes *)font:(UIFont *)font color:(UIColor *)color rect:(CGRect)rect touchable:(BOOL)touchable lineNumber:(NSInteger)lineNumber
               lineBreakMode:(UILineBreakMode)lineBreakMode linkURLString:(NSString *)linkURLString {
  return [[[YPStringAttributes alloc] initWithFont:font color:color rect:rect touchable:touchable lineNumber:lineNumber lineBreakMode:lineBreakMode 
                                     linkURLString:linkURLString] autorelease];
}

- (void)dealloc {
  [_font release];
  [_color release];
  [_linkURLString release];
  [super dealloc];
}

- (NSString *)description {
  return YKDescription(@"font", @"color", @"rect", @"touchable", @"lineNumber", @"lineWidth", @"lineBreakMode", @"linkURLString");
}

@end