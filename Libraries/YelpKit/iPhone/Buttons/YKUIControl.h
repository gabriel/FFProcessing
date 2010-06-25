//
//  YKUIControl.h
//  YelpKit
//
//  Created by Gabriel Handford on 10/27/09.
//  Copyright 2009. All rights reserved.
//

@interface YKUIControl : UIControl {
  id _target; // weak
  SEL _action;
  
  BOOL _highlightedEnabled;
  BOOL _selectedEnabled;
}

@property (readonly, nonatomic) id target;
@property (readonly, nonatomic) SEL action;
@property (assign, nonatomic, getter=isHighlightedEnabled) BOOL highlightedEnabled; // If YES, will set highlighted state while in between touch begin/end (or cancel); Default is NO
@property (assign, nonatomic, getter=isSelectedEnabled) BOOL selectedEnabled; // If YES, will set selected state when touch (ended); Default is NO

/*!
 Removes all targets.
 Does NOT remove or clear the setTarget:action:.
 */
- (void)removeAllTargets;

/*!
 Removes all targets.
 Does NOT remove targets that the control has set for itself.
 */
+ (void)removeAllTargets:(UIControl *)control;

/*!
 Check if touches are all inside the view.
 @param touches
 @param event
 @result YES if all touches are inside control
 */
- (BOOL)touchesAllInView:(NSSet */*of UITouch*/)touches withEvent:(UIEvent *)event;

/*!
 Set target and action.
 @param target
 @param action
 */
- (void)setTarget:(id)target action:(SEL)action;

/*!
 Notification of touch (for subclasses).
 */
- (void)didTouchUpInside;

@end