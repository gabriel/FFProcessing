//
//  FFNotifications.m
//  Steer
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#import "FFNotifications.h"

NSString *const FFDisplayNotification = @"FFDisplayNotification";
NSString *const FFOpenNotification = @"FFOpenNotification";

@implementation FFNotifications

+ (FFNotifications *)sharedNotifications {
  static FFNotifications *gSharedNotifications = nil;
  @synchronized([FFNotifications class]) {
    gSharedNotifications = [[FFNotifications alloc] init];
  }
  return gSharedNotifications;
}

- (void)_postDisplayNotification:(id)object {
  [[NSNotificationCenter defaultCenter] postNotificationName:FFDisplayNotification object:object];
}

+ (void)postDisplayNotificationNameOnMainThread:(id)object {
  [[FFNotifications sharedNotifications] performSelectorOnMainThread:@selector(_postDisplayNotification:) withObject:object waitUntilDone:NO];
}

@end