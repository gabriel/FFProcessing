//
//  YKLocalized.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 11/18/08.
//  Copyright 2008. All rights reserved.
//

// Patches localization call.
#undef NSLocalizedStringFromTableInBundle
#define NSLocalizedStringFromTableInBundle(key, tbl, bundle, comment) \
[bundle yelp_localizedStringForKey:(key) value:nil table:(tbl)]

#undef NSLocalizedStringWithDefaultValue
#define NSLocalizedStringWithDefaultValue(key, tbl, bundle, val, comment) \
[bundle yelp_localizedStringForKey:(key) value:val table:(tbl)]


// Use instead of NSLocalizedString
#ifdef YKLocalizedString
#undef YKLocalizedString
#endif
#define YKLocalizedString(__KEY__) [YKLocalized localize:__KEY__ table:nil value:nil]
#define YKLocalizedFormat(__KEY__, ...) [NSString stringWithFormat:[YKLocalized localize:__KEY__ table:nil value:nil], ##__VA_ARGS__]
#define YKLocalizedStringWithDefaultValue(__KEY__, __TABLE__, __VALUE__) [YKLocalized localize:__KEY__ table:__TABLE__ value:[YKLocalized localize:__VALUE__ table:__TABLE__ value:nil]]
#define YKLocalizedStringForTable(__TABLE__, __KEY__) [YKLocalized localize:__KEY__ table:__TABLE__ value:nil]

/*!
 Single/plural localized formats.
 For example:
 @code
   XMobilePhoto = "%d Photo";
   XMobilePhotos = "%d Photos";
   header = YKLocalizedCount(@"XMobilePhoto", @"XMobilePhotos", [item.bizLargePhotoURLs count]);
 @endcode
 or:
 @code
   MobilePhoto = "a photo"; // Does not include %d
   XMobilePhotos = "%d photos";
   header = YKLocalizedCount(@"MobilePhoto", @"XMobilePhotos", [item.bizLargePhotoURLs count]);
 @endcode
 */
#define YKLocalizedCount(__SINGULAR_KEY__, __PLURAL_KEY__, __COUNT__) (__COUNT__ == 1 ? \
  [NSString stringWithFormat:[YKLocalized localize:__SINGULAR_KEY__ table:nil value:nil], __COUNT__] : \
  [NSString stringWithFormat:[YKLocalized localize:__PLURAL_KEY__ table:nil value:nil], __COUNT__])

/*!
 Localized string from choice.
 YKLocalizedChoice(@"This", @"That", YES) => YKLocalizedString(@"This")
 YKLocalizedChoice(@"This", @"That", NO) => YKLocalizedString(@"That")
 */
#define YKLocalizedChoice(__KEY_TRUE__, __KEY_FALSE__, __BOOL__) (__BOOL__ ? \
  [YKLocalized localize:__KEY_TRUE__ table:nil value:nil] : \
  [YKLocalized localize:__KEY_FALSE__ table:nil value:nil])

/*!
 Localized language name (English, German, French, etc) from two-letter language code (en, de, fr, etc)
 */
#define YKLocalizedLanguageNameFromCode(languageCode) [YKLocalized localize:[languageCode lowercaseString] table:nil value:nil]

// Mixin for patched localizedStringForKey method.
// There seem to be issues with locales and localized resources not being picked up correctly.
// @see https://devforums.apple.com/thread/3210?tstart=0
@interface NSBundle (YKLocalized)

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
@interface YKLocalized : NSObject { }

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

/*!
 Set default table name.
 Defaults to "Localizable".
 Set to nil to reset to default.
 */
+ (void)setDefaultTableName:(NSString *)defaultTableName;

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
