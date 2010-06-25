//
//  YKLocalized.m
//  YelpIPhone
//
//  Created by Gabriel Handford on 11/18/08.
//  Copyright 2008. All rights reserved.
//

#import "YKLocalized.h"
#import "YKDefines.h"

#include <math.h>

#define kDefaultTableName @"Localizable"
static NSString *gDefaultTableName = kDefaultTableName;

@implementation NSBundle (YKLocalized)

static NSMutableDictionary *gLocalizationResourceCache = nil;
static NSString *LocaleIdentifier = nil;

// Get resource cache
+ (NSMutableDictionary *)yelp_localizationResourceCache {
  @synchronized([YKLocalized class]) {
    if (!gLocalizationResourceCache) gLocalizationResourceCache = [[NSMutableDictionary alloc] init];
  }
  return gLocalizationResourceCache;
}

// Clear resource cache
+ (void)yelp_clearCache {
  [[self yelp_localizationResourceCache] removeAllObjects];
  [LocaleIdentifier release];
  LocaleIdentifier = nil;
}

- (NSDictionary *)yelp_loadResourceForTableName:(NSString *)tableName localization:(NSString *)localization {
  NSString *resource = [self pathForResource:tableName ofType:@"strings" inDirectory:nil forLocalization:localization];
  if (!resource) return nil;
  
  NSDictionary *dict = nil;
  
  @synchronized([YKLocalized class]) {
    dict = [[NSBundle yelp_localizationResourceCache] objectForKey:resource];   
    if (!dict) {
      NSDictionary *newDict = [[NSDictionary alloc] initWithContentsOfFile:resource];
      [[NSBundle yelp_localizationResourceCache] setObject:newDict forKey:resource];
      dict = newDict;
      [newDict release]; // Retained by yelp_localizationResourceCache
    }
  }
  return dict;
}

// Look for string with localization string
- (NSString *)yelp_stringForKey:(NSString *)key tableName:(NSString *)tableName localization:(NSString *)localization {
  if (!localization || [localization isEqualToString:@"en_US"]) {
    localization = @"en";
  } else if ([localization hasPrefix:@"fr_"]) {
    // TODO(gabe): This logic shouldn't be in YelpKit
    localization = @"fr_FR"; 
  }
  
  NSString *value = [[YKLocalized localizationCache] objectForKey:key];
  if (value) return value;

  NSDictionary *dict = [self yelp_loadResourceForTableName:tableName localization:localization];
  value = [dict objectForKey:key];
  if (value) {
    [[YKLocalized localizationCache] setObject:value forKey:key];
  }
  return value;
}

- (NSString *)yelp_preferredLanguageForTableName:(NSString *)tableName {
  static NSString *LanguageCode = nil;
  if (LanguageCode) return LanguageCode;
  
  for (NSString *languageCode in [NSLocale preferredLanguages]) {
    // Check if we have a bundle with this preferred language code
    if (!![self yelp_loadResourceForTableName:tableName localization:languageCode]) {
      LanguageCode = [languageCode copy];
      break;
    }
  }
  if (!LanguageCode) LanguageCode = @"en";
  return LanguageCode;
}

// Patched localized string.
- (NSString *)yelp_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName {
  if (!key) {
    YPWarn(@"Trying to localize nil key, (with value=%@, tableName=%@)", value, tableName);
    return nil;
  }
  if (!tableName) tableName = gDefaultTableName; // Default file is Localizable.strings

  if (!LocaleIdentifier) {
    LocaleIdentifier = [[[NSLocale currentLocale] localeIdentifier] retain];
    YPDebug(@"LocaleIdentifier: %@", LocaleIdentifier);
  }

  NSString *localizedString = [self yelp_stringForKey:key tableName:tableName localization:LocaleIdentifier];

  // If not found, check preferredLanguages
  if (!localizedString)
    localizedString = [self yelp_stringForKey:key tableName:tableName localization:[self yelp_preferredLanguageForTableName:tableName]];

  if (!localizedString) {
    YPWarn(@"\n\n\nNo localized string for key: %@, using default: %@\n\n", key, value);
    localizedString = value;
  }
  if (!localizedString) {
    YPWarn(@"\n\n\nNo localized string for key: %@\n\n", key);
    localizedString = key;
  }
  return localizedString;
}

@end

@implementation YKLocalized

static NSMutableDictionary *gLocalizationCache = nil;

+ (NSMutableDictionary *)localizationCache {
  @synchronized([YKLocalized class]) {
    if (!gLocalizationCache) gLocalizationCache = [[NSMutableDictionary alloc] init];
  }
  return gLocalizationCache;
}


+ (void)clearCache {
  [[self localizationCache] removeAllObjects];
  [NSBundle yelp_clearCache];
}

+ (NSString *)localize:(NSString *)key table:(NSString *)table value:(NSString *)value {
  return NSLocalizedStringWithDefaultValue(key, table, [NSBundle bundleForClass:[self class]], value, @"");
}

+ (void)setDefaultTableName:(NSString *)defaultTableName {
  [gDefaultTableName release];
  gDefaultTableName = (defaultTableName ? [defaultTableName copy] : kDefaultTableName);
}

+ (BOOL)isMetric {
  return [self isMetric:[NSLocale currentLocale]];
}

+ (BOOL)isMetric:(id)locale {
  // Override metric for GB (use miles)
  if ([[self countryCode] isEqualToString:@"GB"]) return NO;
  
  return [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
}

+ (NSString *)currencySymbol {
  return [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

+ (NSString *)countryCode {
  return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString *)languageCode {
  return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

+ (BOOL)isCountryCode:(NSString *)code {
  NSString *countryCode = [self countryCode];
  return ([countryCode compare:code options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

+ (NSString *)localizedPath:(NSString *)name ofType:(NSString *)type {
  NSString *localeIdentifier = [[NSLocale currentLocale] localeIdentifier];

  // TODO(gabe): This is a temporary setting for all fr
  if ([localeIdentifier hasPrefix:@"fr_"]) localeIdentifier = @"fr_FR";
  
  NSString *resourcePath = [[NSBundle mainBundle] pathForResource:name ofType:type inDirectory:nil forLocalization:localeIdentifier];
  // Default to 'en'; TODO(alex): for Ireland, fall back on GB, not en
  if (!resourcePath) resourcePath = [[NSBundle mainBundle] pathForResource:name ofType:type inDirectory:nil forLocalization:@"en"];
  if (!resourcePath) {
    resourcePath = [NSString stringWithFormat:@"%@.%@", name, type];
  } else {
    NSString *baseResourcePath = [[NSBundle mainBundle] resourcePath];
    resourcePath = [resourcePath substringFromIndex:[baseResourcePath length] + 1];
  }
  return resourcePath;
}

+ (NSString *)localizedListFromStrings:(NSArray */*of NSString*/)strings {
  if (!strings || ([strings count] <= 0)) return nil;
  if ([strings count] == 1) return [strings objectAtIndex:0];
  if ([strings count] == 2) {
    return [NSString stringWithFormat:@"%@ %@ %@", [strings objectAtIndex:0], YKLocalizedString(@"and"), [strings objectAtIndex:1], nil];
  }
  NSMutableString *localizedList = [[[NSMutableString alloc] initWithString:[strings objectAtIndex:0]] autorelease];
  for (NSInteger i = 1; i < [strings count]; i++) {
    if (i == ([strings count] - 1)) [localizedList appendFormat:@" %@ ", YKLocalizedString(@"and"), nil];
    else [localizedList appendString:@", "];
    [localizedList appendString:[strings objectAtIndex:i]];
  }
  return localizedList;
}

@end

