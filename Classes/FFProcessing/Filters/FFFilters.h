//
//  FFFilters.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/30/10.
//  Copyright 2010. All rights reserved.
//

#import "FFFilter.h"

@interface FFFilters : NSObject <FFFilter> {
  NSArray *_filters;
}

- (id)initWithFilters:(NSArray */*of id<FFFilter>*/)filters;

@end
