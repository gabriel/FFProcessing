//
//  YKCGUtils.m
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

#import "YKCGUtils.h"
#import "YKDefines.h"

const CGPoint YKCGPointNull = {CGFLOAT_MAX, CGFLOAT_MAX};

bool YKCGPointIsNull(CGPoint point) {
  return point.x == YKCGPointNull.x && point.y == YKCGPointNull.y;
}

const CGSize YKCGSizeNull = {CGFLOAT_MAX, CGFLOAT_MAX};

bool YKCGSizeIsNull(CGSize size) {
  return size.width == YKCGSizeNull.width && size.height == YKCGSizeNull.height;
}

CGPathRef YKCGPathCreateRoundedRect(CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius) { 
  
  CGMutablePathRef path = CGPathCreateMutable();

  CGFloat fw, fh;
  
  CGRect insetRect = CGRectInset(rect, strokeWidth/2.0, strokeWidth/2.0);
  CGFloat cornerWidth = cornerRadius, cornerHeight = cornerRadius;
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformTranslate(transform, CGRectGetMinX(insetRect), CGRectGetMinY(insetRect));
  transform = CGAffineTransformScale(transform, cornerWidth, cornerHeight);

  fw = CGRectGetWidth(insetRect) / cornerWidth;
  fh = CGRectGetHeight(insetRect) / cornerHeight;
  CGPathMoveToPoint(path, &transform, fw, fh/2); 
  CGPathAddArcToPoint(path, &transform, fw, fh, fw/2, fh, 1);
  CGPathAddArcToPoint(path, &transform, 0, fh, 0, fh/2, 1);
  CGPathAddArcToPoint(path, &transform, 0, 0, fw/2, 0, 1);
  CGPathAddArcToPoint(path, &transform, fw, 0, fw, fh/2, 1);  
  CGPathCloseSubpath(path);
  
  return path;
}

void YKCGContextAddRoundedRect(CGContextRef context, CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius) {      
  CGPathRef path = YKCGPathCreateRoundedRect(rect, strokeWidth, cornerRadius);
  CGContextAddPath(context, path);  
  CGPathRelease(path);
}

void YKCGContextDrawPath(CGContextRef context, CGPathRef path, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth) { 
  if (fillColor != NULL) CGContextSetFillColorWithColor(context, fillColor);  
  if (strokeColor != NULL) CGContextSetStrokeColorWithColor(context, strokeColor);    
  CGContextSetLineWidth(context, strokeWidth);
  CGContextAddPath(context, path);
  if (strokeColor != NULL && fillColor != NULL) CGContextDrawPath(context, kCGPathFillStroke);
  else if (strokeColor == NULL && fillColor != NULL) CGContextDrawPath(context, kCGPathFill);
  else if (strokeColor != NULL && fillColor == NULL) CGContextDrawPath(context, kCGPathStroke);
}

void YKCGContextDrawRoundedRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius) {   
  CGPathRef path = YKCGPathCreateRoundedRect(rect, strokeWidth, cornerRadius);
  YKCGContextDrawPath(context, path, fillColor, strokeColor, strokeWidth);
  CGPathRelease(path);
}

void YKCGContextAddLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2) {
  CGContextMoveToPoint(context, x, y);
  CGContextAddLineToPoint(context, x2, y2);
}

void YKCGContextDrawLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2, CGColorRef strokeColor, CGFloat strokeWidth) {
  CGContextBeginPath(context);  
  YKCGContextAddLine(context, x, y, x2, y2);
  if (strokeColor != NULL) CGContextSetStrokeColorWithColor(context, strokeColor);
  CGContextSetLineWidth(context, strokeWidth);
  CGContextStrokePath(context);   
}

void _YKCGContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL maintainAspectRatio, CGColorRef backgroundColor);

void YKCGContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, BOOL maintainAspectRatio, CGColorRef backgroundColor) { 
  _YKCGContextDrawImage(context, image, rect, strokeColor, strokeWidth, 0.0, maintainAspectRatio, backgroundColor);
}

void YKCGContextDrawRoundedRectImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL maintainAspectRatio, CGColorRef backgroundColor) {  
  _YKCGContextDrawImage(context, image, rect, strokeColor, strokeWidth, cornerRadius, maintainAspectRatio, backgroundColor);
}

void _YKCGContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL maintainAspectRatio, CGColorRef backgroundColor) {
  CGContextSaveGState(context);
  
  // TODO(gabe): Fails if cornerRadius = 0
  if (strokeWidth > 0 && cornerRadius > 0) {
    YKCGContextAddRoundedRect(context, rect, strokeWidth, cornerRadius);
    CGContextClip(context);
  }
  
  if (backgroundColor != NULL) {
    CGContextSetFillColorWithColor(context, backgroundColor);
    CGContextFillRect(context, rect);
  }
  
  // Reset maintainAspectRatio if image is NULL; forcing draw bounds to be same as rect
  if (image == NULL) maintainAspectRatio = NO;
  
  CGRect imageBounds;
  // If we are scaling image, then image bounds are rect
  // Otherwise figure out y, height (for squeezing horizontal) or x, width (for squeezing vertical)
  if (!maintainAspectRatio) {
    imageBounds = rect;
  } else {
    CGFloat imageHeight = (CGFloat)CGImageGetHeight(image);
    CGFloat imageWidth = (CGFloat)CGImageGetWidth(image);
    imageBounds = YKCGRectScaleToFillAndCenter(CGSizeMake(imageWidth, imageHeight), rect.size);
  }
  
  if (image != NULL) {
    CGContextSaveGState(context);
    // Flip coordinate system, otherwise image will be drawn upside down  
    CGContextTranslateCTM (context, rect.origin.x, imageBounds.size.height + rect.origin.y);
    CGContextScaleCTM (context, 1.0, -1.0);   
    imageBounds.origin.y *= -1; // Going opposite direction
    CGContextDrawImage(context, imageBounds, image);
    CGContextRestoreGState(context);
  }
  
  if (strokeColor != NULL && strokeWidth > 0 && cornerRadius > 0)
    YKCGContextDrawRoundedRect(context, rect, NULL, strokeColor, strokeWidth, cornerRadius);
  CGContextRestoreGState(context);
}

CGRect YKCGRectScaleToFillAndCenter(CGSize size, CGSize sizeToFill) {
  if (YKCGSizeIsEmpty(size)) return CGRectZero;
  
  CGRect rect;
  CGFloat widthScaleRatio = sizeToFill.width / size.width;
  CGFloat heightScaleRatio = sizeToFill.height / size.height;
    
  if (widthScaleRatio < heightScaleRatio) {
    CGFloat height = roundf(size.height * widthScaleRatio);
    CGFloat y = roundf((sizeToFill.height / 2.0) - (height / 2.0));
    rect = CGRectMake(0, y, sizeToFill.width, height);
  } else {
    CGFloat width = roundf(size.width * heightScaleRatio);
    CGFloat x = roundf((sizeToFill.width / 2.0) - (width / 2.0));
    rect = CGRectMake(x, 0, width, sizeToFill.height);
  }
  return rect;
}

BOOL YKCGPointIsZero(CGPoint p) {
  return (YKIsEqualWithAccuracy(p.x, 0, 0.0001) && YKIsEqualWithAccuracy(p.y, 0, 0.0001));
}

BOOL YKCGPointIsEqual(CGPoint p1, CGPoint p2) {
  return (YKIsEqualWithAccuracy(p1.x, p2.x, 0.0001) && YKIsEqualWithAccuracy(p1.y, p2.y, 0.0001));
}

BOOL YKCGRectIsEqual(CGRect rect1, CGRect rect2) {
  return (YKCGPointIsEqual(rect1.origin, rect2.origin) && YKCGSizeIsEqual(rect1.size, rect2.size));  
}
                      
CGRect YKCGRectToCenterY(CGRect rect, CGRect inRect) {
  CGPoint centeredPoint = YKCGPointToCenter(rect.size, inRect.size);
  return YKCGRectSetY(rect, centeredPoint.y);
}

CGPoint YKCGPointToCenterY(CGSize size, CGSize inSize) {
  CGPoint p = CGPointMake(0, roundf((inSize.height - size.height) / 2.0));
  if (p.y < 0) p.y = 0;
  return p;
}

CGPoint YKCGPointToCenter(CGSize size, CGSize inSize) {
  // We round otherwise views will anti-alias
  CGPoint p = CGPointMake(roundf((inSize.width - size.width) / 2.0), roundf((inSize.height - size.height) / 2.0));
  if (p.x < 0) p.x = 0;
  if (p.y < 0) p.y = 0;
  return p;
}

CGPoint YKCGPointToRight(CGSize size, CGSize inSize) {
  CGPoint p = CGPointMake(inSize.width - size.width, roundf(inSize.height / 2.0 - size.height / 2.0));
  if (p.x < 0) p.x = 0;
  if (p.y < 0) p.y = 0;
  return p;
}

BOOL YKCGSizeIsEqual(CGSize size1, CGSize size2) {
  return (YKIsEqualWithAccuracy(size1.height, size2.height, 0.0001) && YKIsEqualWithAccuracy(size1.width, size2.width, 0.0001));
}

BOOL YKCGSizeIsEmpty(CGSize size) {
  return (YKIsEqualWithAccuracy(size.height, 0, 0.0001) && YKIsEqualWithAccuracy(size.width, 0, 0.0001));
}

CGRect YKCGRectToCenter(CGSize size, CGSize inSize) {
  CGPoint p = YKCGPointToCenter(size, inSize);
  return CGRectMake(p.x, p.y, size.width, size.height);
}

CGRect YKCGRectToCenterInRect(CGSize size, CGRect inRect) {
  CGPoint p = YKCGPointToCenter(size, inRect.size);
  return CGRectMake(p.x + inRect.origin.x, p.y + inRect.origin.y, size.width, size.height);
}

CGFloat YKCGFloatToCenter(CGFloat length, CGFloat inLength, CGFloat min) {
  CGFloat pos = roundf(inLength / 2.0 - length / 2.0);
  if (pos < min) pos = min;
  return pos;
}

CGRect YKCGRectAdd(CGRect rect1, CGRect rect2) {
  return CGRectMake(rect1.origin.x + rect2.origin.x, rect1.origin.y + rect2.origin.y, rect1.size.width + rect2.size.width, rect1.size.height + rect2.size.height);
}

CGRect YKCGRectRightAlign(CGFloat y, CGFloat width, CGFloat inWidth, CGFloat maxWidth, CGFloat padRight, CGFloat height) {
  if (width > maxWidth) width = maxWidth;
  CGFloat x = (inWidth - width - padRight);
  return CGRectMake(x, y, width, height);
}

CGRect YKCGRectZeroOrigin(CGRect rect) {
  return CGRectMake(0, 0, rect.size.width, rect.size.height);
}

CGRect YKCGRectSetSize(CGRect rect, CGSize size) {
  rect.size = size;
  return rect;
}

CGRect YKCGRectSetHeight(CGRect rect, CGFloat height) {
  rect.size.height = height;
  return rect;  
}

CGRect YKCGRectAddHeight(CGRect rect, CGFloat add) {
  rect.size.height += add;
  return rect;  
}

CGRect YKCGRectAddX(CGRect rect, CGFloat add) {
  rect.origin.x += add;
  return rect;  
}

CGRect YKCGRectAddY(CGRect rect, CGFloat add) {
  rect.origin.y += add;
  return rect;  
}

CGRect YKCGRectSetWidth(CGRect rect, CGFloat width) {
  rect.size.width = width;
  return rect;  
}

CGRect YKCGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y) {
  rect.origin = CGPointMake(x, y);
  return rect;
}

CGRect YKCGRectSetX(CGRect rect, CGFloat x) {
  rect.origin.x = x;
  return rect;
}

CGRect YKCGRectSetY(CGRect rect, CGFloat y) {
  rect.origin.y = y;
  return rect;
}

CGRect YKCGRectSetOriginPoint(CGRect rect, CGPoint p) {
  rect.origin = p;
  return rect;
}

CGRect YKCGRectOriginSize(CGPoint origin, CGSize size) {
  CGRect rect;
  rect.origin = origin;
  rect.size = size;
  return rect;
}

CGRect YKCGRectAddPoint(CGRect rect, CGPoint p) {
  rect.origin.x += p.x;
  rect.origin.y += p.y;
  return rect;
}

CGPoint YKCGPointBottomRight(CGRect rect) {
  return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

#pragma mark Border Styles

void YKCGContextAddStyledRect(CGContextRef context, CGRect rect, YKUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius) {  
  CGPathRef path = YKCGPathCreateStyledRect(rect, style, strokeWidth, alternateStrokeWidth, cornerRadius);
  CGContextAddPath(context, path);  
  CGPathRelease(path);
}

CGPathRef YKCGPathCreateStyledRect(CGRect rect, YKUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius) {  
  
  CGFloat fw, fh;
  CGFloat cornerWidth = cornerRadius, cornerHeight = cornerRadius;  
  
  if (style == YKUIBorderStyleRounded) {
    assert(cornerRadius > 0);
    return YKCGPathCreateRoundedRect(rect, strokeWidth, cornerRadius);
  }
  
  CGFloat strokeInset = strokeWidth/2.0;
  CGFloat alternateStrokeInset = alternateStrokeWidth/2.0;
  
  // Need to adjust path rect to inset (since the stroke is drawn from the middle of the path)
  CGRect insetBounds;
  switch(style) {
    case YKUIBorderStyleRoundedBottomWithAlternateTop:
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + alternateStrokeInset, rect.size.width - (strokeInset * 2), rect.size.height - alternateStrokeInset - strokeInset);
      break;
      
    case YKUIBorderStyleLeftRightWithAlternateTop:
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + alternateStrokeInset, rect.size.width - (strokeInset * 2), rect.size.height - alternateStrokeInset);
      break;
      
    case YKUIBorderStyleRoundedTop:
      // Inset stroke width except for bottom border
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + strokeInset, rect.size.width - (strokeInset * 2), rect.size.height - strokeInset);
      break;

    case YKUIBorderStyleTopOnly:
      insetBounds = CGRectMake(rect.origin.x, rect.origin.y + strokeInset, rect.size.width, rect.size.height - strokeInset);
      break;

    case YKUIBorderStyleNormal:
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + strokeInset, rect.size.width - (strokeInset * 2), rect.size.height - (strokeInset * 2));
      break;

    default:
      insetBounds = CGRectMake(0, 0, 0, 0);
      break;
  }
  rect = insetBounds;
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformTranslate(transform, CGRectGetMinX(rect), CGRectGetMinY(rect));
  if (cornerWidth > 0 && cornerHeight > 0) {
    transform = CGAffineTransformScale(transform, cornerWidth, cornerHeight);
    fw = CGRectGetWidth(rect) / cornerWidth;
    fh = CGRectGetHeight(rect) / cornerHeight;
  } else {
    fw = CGRectGetWidth(rect);
    fh = CGRectGetHeight(rect);
  }
  
  CGMutablePathRef path = CGPathCreateMutable();
  
  switch(style) {
    case YKUIBorderStyleRoundedBottomWithAlternateTop:
      CGPathMoveToPoint(path, &transform, fw, 0); 
      CGPathAddLineToPoint(path, &transform, fw, fh/2);
      CGPathAddArcToPoint(path, &transform, fw, fh, fw/2, fh, 1);
      CGPathAddArcToPoint(path, &transform, 0, fh, 0, fh/2, 1);
      CGPathAddLineToPoint(path, &transform, 0, 0);
      CGPathMoveToPoint(path, &transform, fw, 0); // Don't draw top border
      break;
      
    case YKUIBorderStyleRoundedTop:
      CGPathMoveToPoint(path, &transform, 0, fh);
      CGPathAddLineToPoint(path, &transform, 0, fh/2);
      CGPathAddArcToPoint(path, &transform, 0, 0, fw/2, 0, 1);
      CGPathAddArcToPoint(path, &transform, fw, 0, fw, fh/2, 1);      
      CGPathAddLineToPoint(path, &transform, fw, fh);
      CGPathMoveToPoint(path, &transform, 0, fh); // Don't draw bottom border
      break;
      
    case YKUIBorderStyleTopOnly:
      CGPathMoveToPoint(path, &transform, 0, 0);
      CGPathAddLineToPoint(path, &transform, fw, 0);
      break;
      
    case YKUIBorderStyleLeftRightWithAlternateTop:
      // Go +/- 2 in order to clip the top and bottom border; Only draw left, right border
      CGPathMoveToPoint(path, &transform, 0, fh + 2);
      CGPathAddLineToPoint(path, &transform, 0, -2);
      CGPathAddLineToPoint(path, &transform, fw, -2);
      CGPathAddLineToPoint(path, &transform, fw, fh + 2);
      CGPathAddLineToPoint(path, &transform, 0, fh + 2);
      break;
      
    case YKUIBorderStyleNormal:
      CGPathMoveToPoint(path, &transform, 0, fh);
      CGPathAddLineToPoint(path, &transform, 0, 0);
      CGPathAddLineToPoint(path, &transform, fw, 0);      
      CGPathAddLineToPoint(path, &transform, fw, fh);
      CGPathAddLineToPoint(path, &transform, 0, fh);
      break;
  }
  
  return path;
}

BOOL YKCGContextAddAlternateBorderToPath(CGContextRef context, CGRect rect, YKUIBorderStyle style) {
  // Skip styles that don't have alternate border path
  if (style != YKUIBorderStyleRoundedBottomWithAlternateTop &&
      style != YKUIBorderStyleLeftRightWithAlternateTop) {
    return NO;
  }
  
  CGFloat cornerWidth = 10, cornerHeight = 10;
  
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM (context, cornerWidth, cornerHeight);
  CGFloat fw = CGRectGetWidth(rect) / cornerWidth;
  
  CGContextMoveToPoint(context, 0, 0);
  CGContextAddLineToPoint(context, fw, 0);
  CGContextRestoreGState(context);
  return YES;
}

void _YKCGContextDrawStyledRect(CGContextRef context, CGRect rect, YKUIBorderStyle style, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius) {
  CGContextSetLineWidth(context, strokeWidth);
  
  YKCGContextAddStyledRect(context, rect, style, strokeWidth, 0, cornerRadius); 
  
  if (strokeColor != NULL) CGContextSetStrokeColorWithColor(context, strokeColor);  
  if (fillColor != NULL) CGContextSetFillColorWithColor(context, fillColor);
  
  if (fillColor != NULL && strokeColor != NULL) {     
    CGContextDrawPath(context, kCGPathFillStroke);
  } else if (strokeColor != NULL) {
    CGContextDrawPath(context, kCGPathStroke);
  } else if (fillColor != NULL) {
    CGContextDrawPath(context, kCGPathFill);
  } 
}

void YKCGContextDrawBorder(CGContextRef context, CGRect rect, YKUIBorderStyle style, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius) {

  _YKCGContextDrawStyledRect(context, rect, style, fillColor, strokeColor, strokeWidth, cornerRadius);
  
  if (alternateStrokeWidth > 0) {
    CGContextSetLineWidth(context, alternateStrokeWidth);
    CGContextBeginPath(context);
    if (YKCGContextAddAlternateBorderToPath(context, rect, style))
      CGContextDrawPath(context, kCGPathStroke);
  }
}

void YKCGContextDrawRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth) {
  _YKCGContextDrawStyledRect(context, rect, YKUIBorderStyleNormal, fillColor, strokeColor, strokeWidth, 1);
}

#pragma mark Colors

void YKCGColorGetComponents(CGColorRef color, CGFloat *red, CGFloat *green, CGFloat *blue, CGFloat *alpha) {
  const CGFloat *components = CGColorGetComponents(color);
  *red = *green = *blue = 0.0;
  *alpha = 1.0;
  size_t num = CGColorGetNumberOfComponents(color);
  if (num <= 2) {
    *red = components[0];
    *green = components[0];
    *blue = components[0];
    if (num == 2) *alpha = components[1];
  } else if (num >= 3) {
    *red = components[0];
    *green = components[1];
    *blue = components[2];
    if (num >= 4) *alpha = components[3];
  } 
}

#pragma mark Shading

//
// Portions adapted from:
// http://wilshipley.com/blog/2005/07/pimp-my-code-part-3-gradient.html
//


// For shading
typedef struct {
  CGFloat red1, green1, blue1, alpha1;
  CGFloat red2, green2, blue2, alpha2;
} _YKUIButtonTwoColors;

// Only uses main color
void _horizontalEdgeColorBlendFunctionImpl(void *info, const CGFloat *in, CGFloat *out, BOOL reverse) {
  _YKUIButtonTwoColors *twoColors = (_YKUIButtonTwoColors *)info;
  
  float v = *in;
  if ((!reverse && v < 0.5) || (reverse && v >= 0.5)) {
    v = (v * 2.0) * 0.3 + 0.6222;
    *out++ = 1.0 - v + twoColors->red1 * v;
    *out++ = 1.0 - v + twoColors->green1 * v;
    *out++ = 1.0 - v + twoColors->blue1 * v;
    *out++ = 1.0 - v + twoColors->alpha1 * v; *out;
  } else {
    *out++ = twoColors->red2;
    *out++ = twoColors->green2;
    *out++ = twoColors->blue2;
    *out++ = twoColors->alpha2; *out;
  }
}

void _horizontalEdgeColorBlendFunction(void *info, const CGFloat *in, CGFloat *out) {
  _horizontalEdgeColorBlendFunctionImpl(info, in, out, NO);
}

void _horizontalReverseEdgeColorBlendFunction(void *info, const CGFloat *in, CGFloat *out) {
  _horizontalEdgeColorBlendFunctionImpl(info, in, out, YES);
}

void _linearColorBlendFunction(void *info, const CGFloat *in, CGFloat *out) {
  _YKUIButtonTwoColors *twoColors = info;
  
  out[0] = (1.0 - *in) * twoColors->red1 + *in * twoColors->red2;
  out[1] = (1.0 - *in) * twoColors->green1 + *in * twoColors->green2;
  out[2] = (1.0 - *in) * twoColors->blue1 + *in * twoColors->blue2;
  out[3] = (1.0 - *in) * twoColors->alpha1 + *in * twoColors->alpha2;
}

void _exponentialColorBlendFunction(void *info, const CGFloat *in, CGFloat *out) {
  _YKUIButtonTwoColors *twoColors = info;
  float amount1 = (1.0 - powf(*in, 2));
  float amount2 = (1.0 - amount1);
  
  out[0] = (amount1 * twoColors->red1) + (amount2 * twoColors->red2);
  out[1] = (amount1 * twoColors->green1) + (amount2 * twoColors->green2);
  out[2] = (amount1 * twoColors->blue1) + (amount2 * twoColors->blue2);
  out[3] = (amount1 * twoColors->alpha1) + (amount2 * twoColors->alpha2);
}

void _colorReleaseInfoFunction(void *info) {
  free(info);
}

static const CGFunctionCallbacks linearFunctionCallbacks = {0, &_linearColorBlendFunction, &_colorReleaseInfoFunction};
static const CGFunctionCallbacks horizontalEdgeFunctionCallbacks = {0, &_horizontalEdgeColorBlendFunction, &_colorReleaseInfoFunction};
static const CGFunctionCallbacks horizontalReverseEdgeFunctionCallbacks = {0, &_horizontalReverseEdgeColorBlendFunction, &_colorReleaseInfoFunction};
static const CGFunctionCallbacks exponentialFunctionCallbacks = {0, &_exponentialColorBlendFunction, &_colorReleaseInfoFunction};


void YKCGContextDrawShadingWithHeight(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGFloat height, YPUIShadingType shadingType) {
  YKCGContextDrawShading(context, color, alternateColor, CGPointMake(0, 0), CGPointMake(0, height), shadingType, YES, YES);
}

void YKCGContextDrawShading(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGPoint start, CGPoint end, YPUIShadingType shadingType, 
                          BOOL extendStart, BOOL extendEnd) {

  const CGFunctionCallbacks *callbacks;
  
  switch (shadingType) {
    case YPUIShadingTypeHorizontalEdge:
      callbacks = &horizontalEdgeFunctionCallbacks;
      break;      
    case YPUIShadingTypeHorizontalReverseEdge:
      callbacks = &horizontalReverseEdgeFunctionCallbacks;
      break;
    case YPUIShadingTypeLinear:
      callbacks = &linearFunctionCallbacks;
      break;
    case YPUIShadingTypeExponential:
      callbacks = &exponentialFunctionCallbacks;
      break;
    default:
      return;
  }  
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  _YKUIButtonTwoColors *twoColors = malloc(sizeof(_YKUIButtonTwoColors));
  
  YKCGColorGetComponents(color, &twoColors->red1, &twoColors->green1, &twoColors->blue1, &twoColors->alpha1);
  YKCGColorGetComponents((alternateColor != NULL ? alternateColor : color), &twoColors->red2, &twoColors->green2, &twoColors->blue2, &twoColors->alpha2);
  
  static const CGFloat domainAndRange[8] = {0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0};
  
  CGFunctionRef blendFunctionRef = CGFunctionCreate(twoColors, 1, domainAndRange, 4, domainAndRange, callbacks);
  CGShadingRef shading = CGShadingCreateAxial(colorSpace, start, end, blendFunctionRef, extendStart, extendEnd);
  CGContextDrawShading(context, shading);
  CGShadingRelease(shading);
  CGFunctionRelease(blendFunctionRef);
  CGColorSpaceRelease(colorSpace);
}
