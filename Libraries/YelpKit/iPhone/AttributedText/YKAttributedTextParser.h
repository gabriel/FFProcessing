//
//  YKAttributedTextParser.h
//  YelpKit
//
//  Created by Gabriel Handford on 6/8/09.
//  Copyright 2009. All rights reserved.
//

@interface YKAttributedTextParser : NSObject <NSXMLParserDelegate> {
  NSMutableString *_xmlBuffer;
  NSDictionary *_xmlAttributesBuffer;
  
  NSMutableArray *_xmlAttributesStack;
  
  NSMutableArray *_xmlAttributedStrings;
  UIColor *_xmlAttributeColor;
  UIColor *_xmlAttributeLinkColor;  
  UIFont *_xmlAttributeFont;
  UIFont *_xmlAttributeBoldFont;
  // If YES, parser will ignore all XML elements except br and just append their bodies to _xmlBuffer. <br /> will be converted to newlines
  BOOL _parseToPlaintext;
}

/*!
 @param color Color for text (can be nil)
 @param linkColor Color for links
 @param font Font for text (can be nil)
 @param boldFont Font for bold text (can be nil)
 */
- (id)initWithColor:(UIColor *)color linkColor:(UIColor *)linkColor font:(UIFont *)font boldFont:(UIFont *)boldFont;
- (id)initWithColor:(UIColor *)color linkColor:(UIColor *)linkColor;

/*!
 Parse XML attributed text.
 @param XMLString
 @param error Out error
 */
- (NSArray */*of YKAttributedString*/)parseXML:(NSString *)XMLString error:(NSError **)error;

/*!
 Parse XML attributed text, stripping all XML attributes.
 Returns the plaintext version of the supplied XMLString.
 @param XMLString
 @param error
 */
- (NSString *)parseXMLToString:(NSString *)XMLString error:(NSError **)error;

/*!
 Parse XML attributed text.
 
 The text:
 @code
 This is a <a href="/somepath?foo=bar">link</a>.
 @endcode 
 
 @param XMLString
 @param attributedStrings If set will place the attributed strings there
 @param error Out error
 */
- (BOOL)parseXML:(NSString *)XMLString attributedStrings:(NSMutableArray **)attributedStrings error:(NSError **)error;

@end
