//
//  YKAttributedTextParser.m
//  YelpKit
//
//  Created by Gabriel Handford on 6/8/09.
//  Copyright 2009. All rights reserved.
//

#import "YKAttributedTextParser.h"

#import "YKAttributedText.h"
#import "YKDefines.h"

@implementation YKAttributedTextParser

- (id)initWithColor:(UIColor *)color linkColor:(UIColor *)linkColor {
  return [self initWithColor:color linkColor:linkColor font:nil boldFont:nil];
}

- (id)initWithColor:(UIColor *)color linkColor:(UIColor *)linkColor font:(UIFont *)font boldFont:(UIFont *)boldFont {
  if ((self = [self init])) {
    _xmlAttributeColor = [color retain];
    _xmlAttributeLinkColor = [linkColor retain];
    _xmlAttributeFont = [font retain];
    _xmlAttributeBoldFont = [boldFont retain];
  }
  return self;
}

- (void)dealloc {
  [_xmlAttributeColor release];
  [_xmlAttributeLinkColor release];
  [_xmlAttributeFont release];
  [_xmlAttributeBoldFont release];
  [super dealloc];
}

- (NSArray */*of YKAttributedString*/)parseXML:(NSString *)XMLString error:(NSError **)error {
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
  [self parseXML:XMLString attributedStrings:&array error:error];
  return array;
}

- (NSString *)parseXMLToString:(NSString *)XMLString error:(NSError **)error {
  NSParameterAssert(XMLString);
  NSString *document = [NSString stringWithFormat:@"<y>%@</y>", XMLString];
  _parseToPlaintext = YES;
  // Arbitrarily decide XMLString is 90% string data
  _xmlBuffer = [NSMutableString stringWithCapacity:[XMLString length]];
  NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[document dataUsingEncoding:XMLString.fastestEncoding]];
  xmlParser.delegate = self;
  [xmlParser setShouldResolveExternalEntities:YES];
  [xmlParser parse];
  _parseToPlaintext = NO;
  [xmlParser release];
  return _xmlBuffer;
}

- (BOOL)parseXML:(NSString *)XMLString attributedStrings:(NSMutableArray **)attributedStrings error:(NSError **)error {
  NSParameterAssert(attributedStrings);
  NSString *document = [NSString stringWithFormat:@"<y>%@</y>", XMLString]; // TODO(gabe): Do we need to wrap in element?
  _xmlBuffer = [[NSMutableString alloc] init];

  _xmlAttributesStack = [[NSMutableArray alloc] initWithCapacity:10];
  _xmlAttributedStrings = [[NSMutableArray alloc] initWithCapacity:10];
  _parseToPlaintext = NO;
  NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[document dataUsingEncoding:XMLString.fastestEncoding]];
  xmlParser.delegate = self;
  [xmlParser setShouldResolveExternalEntities:YES];
  [xmlParser parse];
  
  NSError *parseError = [xmlParser parserError];
  if (parseError) YPError(@"Parse error:\n%@\non\n%@", parseError, XMLString);
    
  if (parseError) {
    // On error, fail gracefully
    [*attributedStrings addObject:[YKAttributedString string:XMLString]];
  } else {
    [*attributedStrings addObjectsFromArray:_xmlAttributedStrings];
  }

  [xmlParser release];
    
  [_xmlBuffer release]; 
  [_xmlAttributesStack release];
  [_xmlAttributedStrings release];
  
  if (error) *error = parseError;
  return (parseError == nil);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributes {
  if (_parseToPlaintext) return;
  [_xmlAttributesStack addObject:attributes];
  if ([_xmlBuffer length] > 0) {
    [_xmlAttributedStrings addObject:[YKAttributedString string:[[_xmlBuffer copy] autorelease] color:_xmlAttributeColor]];
    [_xmlBuffer setString:@""];
  }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName {
  if (_parseToPlaintext) {
    // Convert <br> to newline, ignore all other XML tags for plaintext
    if ([elementName compare:@"br" options:NSCaseInsensitiveSearch] == NSOrderedSame)
      [_xmlBuffer appendString:@"\n"]; 
    return;
  }
  else if (_parseToPlaintext) return;
  NSDictionary *attributes = [[_xmlAttributesStack lastObject] retain];
  [_xmlAttributesStack removeLastObject]; 
  if ([elementName compare:@"a" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    NSString *linkURLString = [attributes objectForKey:@"href"];
    [_xmlAttributedStrings addObject:[YKAttributedString string:[[_xmlBuffer copy] autorelease] font:_xmlAttributeFont color:_xmlAttributeLinkColor touchable:YES linkURLString:linkURLString]];
    [_xmlBuffer setString:@""];
  } else if ([elementName compare:@"b" options:NSCaseInsensitiveSearch] == NSOrderedSame) {    
    [_xmlAttributedStrings addObject:[YKAttributedString string:[[_xmlBuffer copy] autorelease] font:_xmlAttributeBoldFont color:_xmlAttributeColor]];
    [_xmlBuffer setString:@""];    
  } else if ([elementName compare:@"br" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    [_xmlBuffer appendString:@"\n"];
  } else {
    [_xmlAttributedStrings addObject:[YKAttributedString string:[[_xmlBuffer copy] autorelease] font:_xmlAttributeFont color:_xmlAttributeColor]];
    [_xmlBuffer setString:@""];
  }
  [attributes release];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  [_xmlBuffer appendString:string];
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID {
  static NSDictionary* entityTable = nil;
  if (!entityTable) {
    entityTable = [[NSDictionary alloc] initWithObjectsAndKeys:
                   [NSData dataWithBytes:" " length:1], @"nbsp",
                   [NSData dataWithBytes:"&" length:1], @"amp",
                   [NSData dataWithBytes:"\"" length:1], @"quot",
                   [NSData dataWithBytes:"<" length:1], @"lt",
                   [NSData dataWithBytes:">" length:1], @"gt",
                   nil];
  }
  return [entityTable objectForKey:entityName];
}

@end
