//
//  GHGLUtilsTest.m
//  FFProcessing
//
//  Created by Gabriel Handford on 5/10/10.
//  Copyright 2010. All rights reserved.
//


#import "GHUnit.h"

#import "GHGLUtils.h"

@interface GHGLUtilsTest : GHTestCase { }
@end

@implementation GHGLUtilsTest

- (void)testNextPOT {
  GHAssertEquals(GHGLNextPOT(255), 256, nil);
}

@end
