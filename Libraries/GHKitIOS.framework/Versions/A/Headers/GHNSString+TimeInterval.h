//
//  GHNSString+TimeInterval.h
//
//  Created by Gabe on 6/6/08.
//  Copyright 2008 Gabriel Handford
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//


/*!
 Utilities for generating time ago in words.
 */
@interface NSString(GHTimeInterval)

/*!
 Time ago in words.
 @param interval
 @param includeSeconds If YES, will say 'less than N seconds', otherwise will show 'less than a minute'
 @result Time ago in words
 
 For localized values see the localization keys below. 
 This method calls gh_localizedStringForTimeInterval with nil tableName and [NSBundle mainBundle] bundle.
 */
+ (NSString *)gh_stringForTimeInterval:(NSTimeInterval)interval includeSeconds:(BOOL)includeSeconds;

/*! 
 Time ago in words (localized).
 @param interval
 @param includeSeconds If YES, will say 'less than N seconds', otherwise will show 'less than a minute'
 @param tableName Table name for localized string
 @param bundle Bundle for localized string
 @result Time ago in words
 
 These are the localized defaults, that you can override:
 
 @verbatim
 LessThanAMinute = "less than a minute";
 LessThanXSeconds = "less than %d seconds";
 HalfMinute = "half a minute";
 1Minute = "1 minute";
 XMinutes = "%.0f minutes";
 About1Hour = "about 1 hour";
 AboutXHours = "about %.0f hours";
 1Day = "1 day";
 XDays = "%.0f days";
 About1Month = "about 1 month";
 XMonths = "%.0f months";
 About1Year = "about 1 year";
 OverXYears = "over %.0f years";
 @endverbatim
 */
+ (NSString *)gh_localizedStringForTimeInterval:(NSTimeInterval)interval includeSeconds:(BOOL)includeSeconds tableName:(NSString *)tableName bundle:(NSBundle *)bundle;

@end
