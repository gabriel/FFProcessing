//
//  YPCGUtils.h
//  YelpKit
//
//  Created by Gabriel Handford on 12/30/08.
//  Copyright 2008 Yelp. All rights reserved.
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


// Represents NULL point (CoreGraphics only has CGRectNull)
extern const CGPoint YPCGPointNull;

// Check if point is Null (CoreGraphics only has CGRectIsNull)
extern bool YPCGPointIsNull(CGPoint point);

// Represents NULL size (CoreGraphics only has CGRectNull)
extern const CGSize YPCGSizeNull;

// Check if size is Null (CoreGraphics only has CGRectIsNull)
extern bool YPCGSizeIsNull(CGSize size);

/*!
 Add rounded rect to current context path.
 @param context
 @param rect
 @param strokeWidth Width of stroke (so that we can inset the rect); Since stroke occurs from center of path we need to inset by half the strong amount otherwise the stroke gets clipped.
 @param cornerRadius Corner radius
 */
void YPContextAddRoundedRect(CGContextRef context, CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius);

/*!
 Draw rounded rect to current context.
 @param context
 @param rect
 @param fillColor If not NULL, will fill in rounded rect with color
 @param strokeColor Color of stroke
 @param strokeWidth Width of stroke
 @param cornerRadius Radius of rounded corners
 */
void YPContextDrawRoundedRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius);

/*!
 Draw (fill and/or stroke) path.
 @param context
 @param path
 @param fillColor If not NULL, will fill in rounded rect with color
 @param strokeColor Color of stroke
 @param strokeWidth Width of stroke
 
 */
void YPContextDrawPath(CGContextRef context, CGPathRef path, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth);

/*!
 Create rounded rect path.
 @param rect
 @param strokeWidth Width of stroke
 @param cornerRadius Radius of rounded corners
 */
CGPathRef YPCreateRoundedRect(CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius);

/*!
 Add line from (x, y) to (x2, y2) to context path.
 @param context
 @param x
 @param y
 @param x2
 @param y2
 */
void YPContextAddLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2);

/*!
 Draw line from (x, y) to (x2, y2).
 @param context
 @param x
 @param y
 @param x2
 @param y2
 @param strokeColor Line color
 @param strokeWidth Line width (draw from center of width (x+(strokeWidth/2), y+(strokeWidth/2)))
 */
void YPContextDrawLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2, CGColorRef strokeColor, CGFloat strokeWidth);

/*!
 Draws image inside rounded rect.
 
 If the rect is larger than the image size, the image is centered in 
 rect and maintains its aspect ratio. 
 
 @param context Context
 @param image Image to draw
 @param rect Rect to draw
 @param strokeColor Stroke color
 @param strokeWidth Stroke size
 @param cornerRadius Corner radius for rounded rect
 @param maintainAspectRatio If NO, image fills the rect (background color may be visible)
 @param backgroundColor If image is smaller than rect (and not scaling image), this background color is used.
 */
void YPContextDrawRoundedRectImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL scaleImage, CGColorRef backgroundColor);

/*!
 Draws image.
 @param context Context
 @param image Image to draw
 @param rect Rect to draw
 @param strokeColor Stroke color
 @param strokeWidth Stroke size
 @param maintainAspectRatio If NO, image fills the rect (background color may be visible)
 @param backgroundColor If image is smaller than rect (and not scaling image), this background color is used. 
 */
void YPContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, BOOL maintainAspectRatio, CGColorRef backgroundColor);

/*!
 Figure out the rectangle to fit 'size' into 'sizeToFill'.
 @param size
 @param sizeToFill
 */
CGRect YPScaleToFillAndCenter(CGSize size, CGSize sizeToFill);

/*!
 Point to place region of size1 into size2, so that its centered.
 @param size1
 @param size2
 */
CGPoint YPPointToCenter(CGSize size1, CGSize size2);

/*!
 Point to place region of size1 into size2, so that its centered in Y position.
 */
CGPoint YPCGPointToCenterY(CGSize size, CGSize inSize);

/*!
 Returns if point is zero origin.
 */
BOOL YPCGPointIsZero(CGPoint p);

/*!
 Check if equal within some accuracy.
 @param p1
 @param p2
 */
BOOL YPCGPointIsEqual(CGPoint p1, CGPoint p2);

/*!
 Check if equal within some accuracy.
 @param size1
 @param size2
*/
BOOL YPCGSizeIsEqual(CGSize size1, CGSize size2);

/*!
 Check if equal within some accuracy.
 @param rect1
 @param rect2
 */
BOOL YPCGRectIsEqual(CGRect rect1, CGRect rect2);

/*!
 Returns a rect that is centered vertically in inRect but horizontally unchanged
 @param rect The inner rect
 @param inRect The rect to center inside of
 */
CGRect YPCGRectToCenterY(CGRect rect, CGRect inRect);

/*!
 TODO(gabe): Document
 */
CGPoint YPPointToRight(CGSize size, CGSize inSize);

/*!
 TODO(gabe): Document
 */
CGRect YPSizeToCenterRect(CGSize size, CGSize inSize);

BOOL YPCGSizeIsEmpty(CGSize size);

/*!
 TODO(gabe): Document
 */
CGRect YPRectToCenterRect(CGSize size, CGRect inRect);

/*!
 TODO(gabe): Document
 */
CGFloat YPPositionToCenter(CGFloat width, CGFloat inWidth, CGFloat minPosition);

/*!
 Adds two rectangles.
 TODO(gabe): Document
 */
CGRect YPCGRectAdd(CGRect rect1, CGRect rect2);


/*!
 Get rect to right align width inside inWidth with maxWidth and padding on the right.
 */
CGRect YPCGRectRightAlign(CGFloat y, CGFloat width, CGFloat inWidth, CGFloat maxWidth, CGFloat padRight, CGFloat height);

/*!
 Copy of CGRect with (x, y) origin set to 0.
 */
CGRect YPCGRectZeroOrigin(CGRect rect);

/*!
 Set size on rect.
 */
CGRect YPCGRectSetSize(CGRect rect, CGSize size);

/*!
 Set height on rect.
 */
CGRect YPCGRectSetHeight(CGRect rect, CGFloat height);

/*
 Set width on rect.
 */
CGRect YPCGRectSetWidth(CGRect rect, CGFloat width);

/*!
 Set x on rect.
 */
CGRect YPCGRectSetX(CGRect rect, CGFloat x);

/*!
 Set y on rect.
 */
CGRect YPCGRectSetY(CGRect rect, CGFloat y);
  

CGRect YPCGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y);

CGRect YPCGRectSetOriginPoint(CGRect rect, CGPoint p);

CGRect YPCGRectOriginSize(CGPoint origin, CGSize size);

CGRect YPCGRectAddPoint(CGRect rect, CGPoint p);

CGRect YPCGRectAddHeight(CGRect rect, CGFloat height);

CGRect YPCGRectAddX(CGRect rect, CGFloat add);

CGRect YPCGRectAddY(CGRect rect, CGFloat add);

/*!
 Bottom right point in rect. (x + width, y + height).
 */
CGPoint YPBottomRight(CGRect rect);

#pragma mark Border Styles

// Border styles:
// So far only borders for the group text field; And allow you to have top, middle, middle, middle, bottom.
//
//   YPUIBorderStyleNormal
//   -------
//   |     |
//   -------
//
//   YPUIBorderStyleRoundedTop:
//   ╭----╮
//   |     |
//
//
//   YPUIBorderStyleLeftRightWithAlternateTop
//   -------  (alternate stroke on top)
//   |     |
//
//  
//   YPUIBorderStyleRoundedBottomWithAlternateTop
//   -------  (alternate stroke on top)
//   |     |
//   ╰----╯
//
typedef enum {
  YPUIBorderStyleNone = 0,
  YPUIBorderStyleNormal,
  YPUIBorderStyleRounded, // Rounded top, right, bottom, left
  YPUIBorderStyleRoundedTop, // Rounded top with left and right sides (no bottom); Uses strokeWidth for all sides
  YPUIBorderStyleLeftRightWithAlternateTop, // Left and right sides (no bottom) in strokeWidth; Top in alternateStrokeWidth
  YPUIBorderStyleRoundedBottomWithAlternateTop, // Rounded bottom with left and right sides in strokeWidth; Top in alternateStrokeWidth
} YPUIBorderStyle;

CGPathRef YPCreateStyledRect(CGRect rect, YPUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius);

void YPContextAddStyledRect(CGContextRef context, CGRect rect, YPUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius);

BOOL YPAddAlternateBorderToPath(CGContextRef context, CGRect rect, YPUIBorderStyle style);

void YPDrawBorder(CGContextRef context, CGRect rect, YPUIBorderStyle style, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius);

void YPContextDrawRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth);

#pragma mark Colors

void YPGetColorComponents(CGColorRef color, CGFloat *red, CGFloat *green, CGFloat *blue, CGFloat *alpha);

#pragma mark Shading

typedef enum {
  YPUIShadingTypeNone,
  YPUIShadingTypeLinear, // Linear color blend
  YPUIShadingTypeHorizontalEdge, // Horizontal edge (only uses color)
  YPUIShadingTypeHorizontalReverseEdge, // Horizontal edge (only uses color) reversed
  YPUIShadingTypeExponential,
} YPUIShadingType;

void YPContextDrawShadingWithHeight(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGFloat height, YPUIShadingType shadingType);

void YPContextDrawShading(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGPoint start, CGPoint end, YPUIShadingType shadingType, 
                          BOOL extendStart, BOOL extendEnd);
