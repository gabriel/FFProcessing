//
//  main.m
//  FFProcessing
//
//  Created by Gabriel Handford on 3/19/10.
//  Copyright 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {    
  NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, @"PBAppDelegate"); //@"FFPlayerAppDelegate";
  [pool release];
  return retVal;
}
