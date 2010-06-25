//
//  YKCGUtils.h
//  YelpKit
//
//  Created by Gabriel Handford on 12/30/08.
//  Copyright 2008. All rights reserved.
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
extern const CGPoint YKCGPointNull;

// Check if point is Null (CoreGraphics only has CGRectIsNull)
extern bool YKCGPointIsNull(CGPoint point);

// Represents NULL size (CoreGraphics only has CGRectNull)
extern const CGSize YKCGSizeNull;

// Check if size is Null (CoreGraphics only has CGRectIsNull)
extern bool YKCGSizeIsNull(CGSize size);

/*!
 Add rounded rect to current context path.
 @param context
 @param rect
 @param strokeWidth Width of stroke (so that we can inset the rect); Since stroke occurs from center of path we need to inset by half the strong amount otherwise the stroke gets clipped.
 @param cornerRadius Corner radius
 */
void YKCGContextAddRoundedRect(CGContextRef context, CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius);

/*!
 Draw rounded rect to current context.
 @param context
 @param rect
 @param fillColor If not NULL, will fill in rounded rect with color
 @param strokeColor Color of stroke
 @param strokeWidth Width of stroke
 @param cornerRadius Radius of rounded corners
 */
void YKCGContextDrawRoundedRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius);

/*!
 Draw (fill and/or stroke) path.
 @param context
 @param path
 @param fillColor If not NULL, will fill in rounded rect with color
 @param strokeColor Color of stroke
 @param strokeWidth Width of stroke
 
 */
void YKCGContextDrawPath(CGContextRef context, CGPathRef path, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth);

/*!
 Create rounded rect path.
 @param rect
 @param strokeWidth Width of stroke
 @param cornerRadius Radius of rounded corners
 */
CGPathRef YKCGPathCreateRoundedRect(CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius);

/*!
 Add line from (x, y) to (x2, y2) to context path.
 @param context
 @param x
 @param y
 @param x2
 @param y2
 */
void YKCGContextAddLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2);

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
void YKCGContextDrawLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2, CGColorRef strokeColor, CGFloat strokeWidth);

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
void YKCGContextDrawRoundedRectImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL scaleImage, CGColorRef backgroundColor);

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
void YKCGContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, BOOL maintainAspectRatio, CGColorRef backgroundColor);

/*!
 Figure out the rectangle to fit 'size' into 'sizeToFill'.
 @param size
 @param sizeToFill
 */
CGRect YKCGRectScaleToFillAndCenter(CGSize size, CGSize sizeToFill);

/*!
 Point to place region of size1 into size2, so that its centered.
 @param size1
 @param size2
 */
CGPoint YKCGPointToCenter(CGSize size1, CGSize size2);

/*!
 Point to place region of size1 into size2, so that its centered in Y position.
 */
CGPoint YKCGPointToCenterY(CGSize size, CGSize inSize);

/*!
 Returns if point is zero origin.
 */
BOOL YKCGPointIsZero(CGPoint p);

/*!
 Check if equal within some accuracy.
 @param p1
 @param p2
 */
BOOL YKCGPointIsEqual(CGPoint p1, CGPoint p2);

/*!
 Check if equal within some accuracy.
 @param size1
 @param size2
*/
BOOL YKCGSizeIsEqual(CGSize size1, CGSize size2);

/*!
 Check if equal within some accuracy.
 @param rect1
 @param rect2
 */
BOOL YKCGRectIsEqual(CGRect rect1, CGRect rect2);

/*!
 Returns a rect that is centered vertically in inRect but horizontally unchanged
 @param rect The inner rect
 @param inRect The rect to center inside of
 */
CGRect YKCGRectToCenterY(CGRect rect, CGRect inRect);

/*!
 TODO(gabe): Document
 */
CGPoint YKCGPointToRight(CGSize size, CGSize inSize);

/*!
 TODO(gabe): Document
 */
CGRect YKCGRectToCenter(CGSize size, CGSize inSize);

BOOL YKCGSizeIsEmpty(CGSize size);

/*!
 TODO(gabe): Document
 */
CGRect YKCGRectToCenterInRect(CGSize size, CGRect inRect);

/*!
 TODO(gabe): Document
 */
CGFloat YKCGFloatToCenter(CGFloat width, CGFloat inWidth, CGFloat minPosition);

/*!
 Adds two rectangles.
 TODO(gabe): Document
 */
CGRect YKCGRectAdd(CGRect rect1, CGRect rect2);


/*!
 Get rect to right align width inside inWidth with maxWidth and padding on the right.
 */
CGRect YKCGRectRightAlign(CGFloat y, CGFloat width, CGFloat inWidth, CGFloat maxWidth, CGFloat padRight, CGFloat height);

/*!
 Copy of CGRect with (x, y) origin set to 0.
 */
CGRect YKCGRectZeroOrigin(CGRect rect);

/*!
 Set size on rect.
 */
CGRect YKCGRectSetSize(CGRect rect, CGSize size);

/*!
 Set height on rect.
 */
CGRect YKCGRectSetHeight(CGRect rect, CGFloat height);

/*
 Set width on rect.
 */
CGRect YKCGRectSetWidth(CGRect rect, CGFloat width);

/*!
 Set x on rect.
 */
CGRect YKCGRectSetX(CGRect rect, CGFloat x);

/*!
 Set y on rect.
 */
CGRect YKCGRectSetY(CGRect rect, CGFloat y);
  

CGRect YKCGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y);

CGRect YKCGRectSetOriginPoint(CGRect rect, CGPoint p);

CGRect YKCGRectOriginSize(CGPoint origin, CGSize size);

CGRect YKCGRectAddPoint(CGRect rect, CGPoint p);

CGRect YKCGRectAddHeight(CGRect rect, CGFloat height);

CGRect YKCGRectAddX(CGRect rect, CGFloat add);

CGRect YKCGRectAddY(CGRect rect, CGFloat add);

/*!
 Bottom right point in rect. (x + width, y + height).
 */
CGPoint YKCGPointBottomRight(CGRect rect);

#pragma mark Border Styles

// Border styles:
// So far only borders for the group text field; And allow you to have top, middle, middle, middle, bottom.
//
//   YKUIBorderStyleNormal
//   -------
//   |     |
//   -------
//
//   YKUIBorderStyleRoundedTop:
//   ╭----╮
//   |     |
//
//
//   YKUIBorderStyleLeftRightWithAlternateTop
//   -------  (alternate stroke on top)
//   |     |
//
//  
//   YKUIBorderStyleRoundedBottomWithAlternateTop
//   -------  (alternate stroke on top)
//   |     |
//   ╰----╯
//
//   YKUIBorderStyleTopOnly
//   -------- (topn only)
//
typedef enum {
  YKUIBorderStyleNone = 0,
  YKUIBorderStyleNormal,
  YKUIBorderStyleTopOnly, // Straight top only
  YKUIBorderStyleRounded, // Rounded top, right, bottom, left
  YKUIBorderStyleRoundedTop, // Rounded top with left and right sides (no bottom); Uses strokeWidth for all sides
  YKUIBorderStyleLeftRightWithAlternateTop, // Left and right sides (no bottom) in strokeWidth; Top in alternateStrokeWidth
  YKUIBorderStyleRoundedBottomWithAlternateTop, // Rounded bottom with left and right sides in strokeWidth; Top in alternateStrokeWidth  
} YKUIBorderStyle;

CGPathRef YKCGPathCreateStyledRect(CGRect rect, YKUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius);

void YKCGContextAddStyledRect(CGContextRef context, CGRect rect, YKUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius);

BOOL YKCGContextAddAlternateBorderToPath(CGContextRef context, CGRect rect, YKUIBorderStyle style);

void YKCGContextDrawBorder(CGContextRef context, CGRect rect, YKUIBorderStyle style, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius);

void YKCGContextDrawRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth);

#pragma mark Colors

void YKCGColorGetComponents(CGColorRef color, CGFloat *red, CGFloat *green, CGFloat *blue, CGFloat *alpha);

#pragma mark Shading

typedef enum {
  YPUIShadingTypeNone,
  YPUIShadingTypeLinear, // Linear color blend
  YPUIShadingTypeHorizontalEdge, // Horizontal edge (only uses color)
  YPUIShadingTypeHorizontalReverseEdge, // Horizontal edge (only uses color) reversed
  YPUIShadingTypeExponential,
} YPUIShadingType;

void YKCGContextDrawShadingWithHeight(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGFloat height, YPUIShadingType shadingType);

void YKCGContextDrawShading(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGPoint start, CGPoint end, YPUIShadingType shadingType, 
                          BOOL extendStart, BOOL extendEnd);

