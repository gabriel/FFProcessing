//
//  YPDefines.h
//  YelpKit
//
//  Created by Gabriel Handford on 4/8/09.
//  Copyright 2009 Yelp. All rights reserved.
//

#define YPOrNSNull(obj) (obj ? obj : (id)[NSNull null])

/*!
 Generates description from key-value coding.
 For example,
 @code
 - (NSString *)description {
  return YPDescription(@"foo", @"bar", @"someInteger");
 }
 @endcode 
 */
#define YPDescription(...) [NSString stringWithFormat:@"%@; %@", [super description], [[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:__VA_ARGS__, nil]] description]]
#define YPDebugProps(obj, ...) [[obj dictionaryWithValuesForKeys:[NSArray arrayWithObjects:__VA_ARGS__, nil]] description]

#define YPIntervalToMillis(interval, defaultValue) (interval >= 0 ? (long long)round(interval * 1000) : defaultValue)

/*!
 Constants.
 */
#define YPTimeIntervalMinute (60)
#define YPTimeIntervalHour (YPTimeIntervalMinute * 60)
#define YPTimeIntervalDay (YPTimeIntervalHour * 24)
#define YPTimeIntervalWeek (YPTimeIntervalDay * 7)
#define YPTimeIntervalYear (YPTimeIntervalDay * 365.242199)


/*!
 Macro defaults.
 */
#define YPDebug(fmt, ...) do {} while(0)
#define YPDebugSelf(fmt, ...) do {} while(0)
#define YPException(e) do {} while(0)
#define YPWarn(fmt, ...) do {} while(0)
#define YPInfo(fmt, ...) do {} while(0)
#define YPError(fmt, ...) do {} while(0)
#define YPNSError(fmt, ...) do {} while(0)

/*!
 Logging macros.
 */
#if DEBUG
#import "GTMLogger.h"
#import "GTMStackTrace.h"
#undef YPDebug
#define YPDebug(fmt, ...) GTMLoggerDebug(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#undef YPDebugSelf
#define YPDebugSelf(fmt, ...) GTMLoggerDebug([@"%@ " stringByAppendingString:fmt], [self description], ##__VA_ARGS__)
#undef YPException
#define YPException(__EXCEPTION__) GTMLoggerDebug(@"%@", [NSString stringWithFormat:@"\n\n%@\n%@\n\n", [__EXCEPTION__ description], GTMExceptionStackTrace(__EXCEPTION__)])
#undef YPWarn
#define YPWarn(fmt, ...) GTMLoggerInfo(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#undef YPInfo
#define YPInfo(fmt, ...) GTMLoggerInfo(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#undef YPError
#define YPError(fmt, ...) GTMLoggerError(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#undef YPNSError
#define YPNSError(__ERROR__) do { if (__ERROR__) GTMLoggerError(@"%@", [__ERROR__ gh_fullDescription]); } while(0)
#endif

#if YP_DEBUG
#import "GTMLogger.h"
#import "GTMStackTrace.h"
#undef YPException
#define YPException(__EXCEPTION__) GTMLoggerDebug(@"%@", [NSString stringWithFormat:@"\n\n%@\n%@\n\n", [__EXCEPTION__ description], GTMExceptionStackTrace(__EXCEPTION__)])
#undef YPWarn
#define YPWarn(fmt, ...) GTMLoggerInfo(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#undef YPInfo
#define YPInfo(fmt, ...) GTMLoggerInfo(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#undef YPError
#define YPError(fmt, ...) GTMLoggerError(@"%@", [NSString stringWithFormat:fmt, ##__VA_ARGS__])
#undef YPNSError
#define YPNSError(__ERROR__) do { if (__ERROR__) GTMLoggerError(@"%@", [__ERROR__ gh_fullDescription]); } while(0)
#endif

#define YPIsEqualWithAccuracy(n1, n2, accuracy) (n1 >= (n2-accuracy) && n1 <= (n2+accuracy))

#define YPIsEqualObjects(obj1, obj2) ((obj1 == nil && obj2 == nil) || ([obj1 isEqual:obj2]))

#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif


#if YP_DEMO
#define YPDemoMode (YES)
#else
#define YPDemoMode (NO)
#endif


/*!
 This is pulled from GData obj-c API
 @see http://code.google.com/p/gdata-objectivec-client/source/browse/trunk/Source/Networking/GDataHTTPFetcher.m
 */
static inline void YPAssertSelectorNilOrImplementedWithArguments(id obj, SEL sel, ...) {
  
  // verify that the object's selector is implemented with the proper
  // number and type of arguments
#if YP_DEBUG
  va_list argList;
  va_start(argList, sel);
  
  if (obj && sel) {
    // check that the selector is implemented
    if (![obj respondsToSelector:sel]) {
      [NSException raise:NSInvalidArgumentException format:@"\"%@\" selector \"%@\" is unimplemented or misnamed", 
       NSStringFromClass([obj class]), 
       NSStringFromSelector(sel)];
    } else {
      const char *expectedArgType;
      unsigned int argCount = 2; // skip self and _cmd
      NSMethodSignature *sig = [obj methodSignatureForSelector:sel];
      
      // check that each expected argument is present and of the correct type
      while ((expectedArgType = va_arg(argList, const char*)) != 0) {
        
        if ([sig numberOfArguments] > argCount) {
          const char *foundArgType = [sig getArgumentTypeAtIndex:argCount];
          
          if(0 != strncmp(foundArgType, expectedArgType, strlen(expectedArgType))) {
            [NSException raise:NSInvalidArgumentException format:@"\"%@\" selector \"%@\" argument %d should be type %s", 
             NSStringFromClass([obj class]), 
             NSStringFromSelector(sel), (argCount - 2), expectedArgType];
          }
        }
        argCount++;
      }
      
      // check that the proper number of arguments are present in the selector
      if (argCount != [sig numberOfArguments]) {
        [NSException raise:NSInvalidArgumentException format:@"\"%@\" selector \"%@\" should have %d arguments",
         NSStringFromClass([obj class]), 
         NSStringFromSelector(sel), (argCount - 2)];
      }
    }
  }
  
  va_end(argList);
#endif
}

