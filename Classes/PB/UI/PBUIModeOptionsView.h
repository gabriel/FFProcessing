//
//  PBUIModeOptionsView.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/23/10.
//  Copyright 2010. All rights reserved.
//

#import "YKUIGridView.h"


@interface PBUIModeOptionsView : YKUIGridView { }

- (void)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
