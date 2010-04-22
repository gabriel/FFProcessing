//
//  YPLocalized.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 11/18/08.
//  Copyright 2008 Yelp. All rights reserved.
//

// Patches localization call.
#undef NSLocalizedStringFromTableInBundle
#define NSLocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
[bundle yelp_localizedStringForKey:(key) value:nil table:(tbl)]

#undef NSLocalizedStringWithDefaultValue
#define NSLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
[bundle yelp_localizedStringForKey:(key) value:val table:(tbl)]


// Use instead of NSLocalizedString
#ifdef YPLocalizedString
#undef YPLocalizedString
#endif
#define YPLocalizedString(key, ...) [YPLocalized localize:[NSString stringWithFormat:key, ##__VA_ARGS__] table:nil value:nil]
#define YPLocalizedFormat(key, ...) [NSString stringWithFormat:[YPLocalized localize:key table:nil value:nil], ##__VA_ARGS__]
#define YPLocalizedStringWithDefaultValue(key, tbl, val) [YPLocalized localize:key table:tbl value:[YPLocalized localize:val table:tbl value:nil]]
#define YPLocalizedSharedString(key, ...) [YPLocalized localize:[NSString stringWithFormat:key, ##__VA_ARGS__] table:@"Shared" value:nil]

/*!
 Single/plural localized formats.
 For example:
 @code
   XMobilePhoto = "%d Photo";
   XMobilePhotos = "%d Photos";
   header = YPLocalizedCount(@"XMobilePhoto", @"XMobilePhotos", YES, [item.bizLargePhotoURLs count]);
 @endcode
 or:
 @code
   MobilePhoto = "Photo"; // Does not include %d (so includeSingularFormat is NO below)
   XMobilePhotos = "%d Photos";
   header = YPLocalizedCount(@"MobilePhoto", @"XMobilePhotos", NO, [item.bizLargePhotoURLs count]);
 @endcode
 */
#define YPLocalizedCount(singularKey, pluralKey, includeSingularFormat, n, ...) (n == 1 ? \
  (includeSingularFormat ? \
    [NSString stringWithFormat:[YPLocalized localize:singularKey table:nil value:nil], n, ##__VA_ARGS__] : \
    [NSString stringWithFormat:[YPLocalized localize:singularKey table:nil value:nil], ##__VA_ARGS__]) : \
  [NSString stringWithFormat:[YPLocalized localize:pluralKey table:nil value:nil], n, ##__VA_ARGS__])

/*!
 Single/plural localized formats.
 Does not automatically include number in format, for when you need custom formats for both singular and plural.
 @code
 MobilePhoto = "%@'s only photo";
 MobilePhotos = "%@ has more than 1 photo";
 header = YPLocalizedCountWithFormat(@"UserHasMobilePhoto", @"UserHasMobilePhotos", [item.bizLargePhotoURLs count], @"Bob");
 @endcode
 */
#define YPLocalizedCountWithFormat(singularKey, pluralKey, n, ...) (n == 1 ? \
  [NSString stringWithFormat:[YPLocalized localize:singularKey table:nil value:nil], ##__VA_ARGS__] : \
  [NSString stringWithFormat:[YPLocalized localize:pluralKey table:nil value:nil], ##__VA_ARGS__])

/*!
 Male/Female localized strings
 Different strings with format for YPGenderMale and YPGenderFemale
 Defaults to YPGenderFemale
 */
#define YPLocalizedStringWithGender(maleKey, femaleKey, gender, ...) (gender == YPGenderMale ? \
  [NSString stringWithFormat:[YPLocalized localize:maleKey table:nil value:nil], ##__VA_ARGS__] : \
  [NSString stringWithFormat:[YPLocalized localize:femaleKey table:nil value:nil], ##__VA_ARGS__])

/*!
 Localized language name (English, German, French, etc) from two-letter language code (en, de, fr, etc)
 */
#define YPLocalizedLanguageNameFromCode(languageCode) [YPLocalized localize:[languageCode lowercaseString] table:nil value:nil]

// Mixin for patched localizedStringForKey method.
// There seem to be issues with locales and localized resources not being picked up correctly.
// @see https://devforums.apple.com/thread/3210?tstart=0
@interface NSBundle (YPLocalized)

/*!
 Localize string with key.
 
 Uses localized resource in order of: 
 - locale identifier (language_region): "en_CA"
 - language: "en"
 - no locale: nil
 
 If still not found will return the specified (default) value and finally will return the key as a last resort.
 
 @param key
 @param value Default if key not found
 @param table Resource name; Defaults to Localizable
*/
- (NSString *)yelp_localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;

// Get string for key based on localization string.
- (NSString *)yelp_stringForKey:(NSString *)key tableName:(NSString *)tableName localization:(NSString *)localization;

/*!
 Load resource bundle for table name and localization.
 @param tableName Localizable
 @param localization en, es, en_US, en_GB
 */
- (NSDictionary *)yelp_loadResourceForTableName:(NSString *)tableName localization:(NSString *)localization;

/*!
 Find useable language for table name.
 Falls back to @"en" if no language bundles found.
 */
- (NSString *)yelp_preferredLanguageForTableName:(NSString *)tableName;

+ (void)yelp_clearCache;

@end

// Obj-C wrapper for localize call. Also caches localized key/value pairs.
@interface YPLocalized : NSObject { }

// Cache for localized strings
+ (NSMutableDictionary *)localizationCache;
// Clears the localization cache
+ (void)clearCache;

/*!
 Get localized string
 @param key 
 @param table The strings file to lookup. Defaults to Localizable (which uses Localizable.strings)
 @param value Default if key is not present
 */
+ (NSString *)localize:(NSString *)key table:(NSString *)table value:(NSString *)value;

// Shortcut for determining if current locale is metric
+ (BOOL)isMetric;
+ (BOOL)isMetric:(id)locale;

// Shortcut for determining currency symbol
+ (NSString *)currencySymbol;

// Get the country code (for phone locale region format)
+ (NSString *)countryCode;

//! Current language code
+ (NSString *)languageCode;

// If country code (for phone locale region format)
+ (BOOL)isCountryCode:(NSString *)code;

/*!
 Get localized path.
 (1) Checks specific localized bundle directory (en_GB).
 (2) Otherwise, checks default localized  bundle directory (en).
 (3) Otherwise checks default bundle directory.
 
 @param name
 @param type
 @result Path to localized file
 */
+ (NSString *)localizedPath:(NSString *)name ofType:(NSString *)type;


+ (NSString *)localizedListFromStrings:(NSArray */*of NSString*/)strings;

@end
