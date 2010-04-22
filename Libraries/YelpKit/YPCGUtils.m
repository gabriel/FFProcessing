//
//  YPCGUtils.m
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

#import "YPCGUtils.h"
#import "YPDefines.h"

const CGPoint YPCGPointNull = {CGFLOAT_MAX, CGFLOAT_MAX};

bool YPCGPointIsNull(CGPoint point) {
  return point.x == YPCGPointNull.x && point.y == YPCGPointNull.y;
}

const CGSize YPCGSizeNull = {CGFLOAT_MAX, CGFLOAT_MAX};

bool YPCGSizeIsNull(CGSize size) {
  return size.width == YPCGSizeNull.width && size.height == YPCGSizeNull.height;
}

CGPathRef YPCreateRoundedRect(CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius) { 
  
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

void YPContextAddRoundedRect(CGContextRef context, CGRect rect, CGFloat strokeWidth, CGFloat cornerRadius) {      
  CGPathRef path = YPCreateRoundedRect(rect, strokeWidth, cornerRadius);
  CGContextAddPath(context, path);  
  CGPathRelease(path);
}

void YPContextDrawPath(CGContextRef context, CGPathRef path, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth) { 
  if (fillColor != NULL) CGContextSetFillColorWithColor(context, fillColor);  
  if (strokeColor != NULL) CGContextSetStrokeColorWithColor(context, strokeColor);    
  CGContextSetLineWidth(context, strokeWidth);
  CGContextAddPath(context, path);
  if (strokeColor != NULL && fillColor != NULL) CGContextDrawPath(context, kCGPathFillStroke);
  else if (strokeColor == NULL && fillColor != NULL) CGContextDrawPath(context, kCGPathFill);
  else if (strokeColor != NULL && fillColor == NULL) CGContextDrawPath(context, kCGPathStroke);
}

void YPContextDrawRoundedRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius) {   
  CGPathRef path = YPCreateRoundedRect(rect, strokeWidth, cornerRadius);
  YPContextDrawPath(context, path, fillColor, strokeColor, strokeWidth);
  CGPathRelease(path);
}

void YPContextAddLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2) {
  CGContextMoveToPoint(context, x, y);
  CGContextAddLineToPoint(context, x2, y2);
}

void YPContextDrawLine(CGContextRef context, CGFloat x, CGFloat y, CGFloat x2, CGFloat y2, CGColorRef strokeColor, CGFloat strokeWidth) {
  CGContextBeginPath(context);  
  YPContextAddLine(context, x, y, x2, y2);
  if (strokeColor != NULL) CGContextSetStrokeColorWithColor(context, strokeColor);
  CGContextSetLineWidth(context, strokeWidth);
  CGContextStrokePath(context);   
}

void _YPContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL maintainAspectRatio, CGColorRef backgroundColor);

void YPContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, BOOL maintainAspectRatio, CGColorRef backgroundColor) { 
  _YPContextDrawImage(context, image, rect, strokeColor, strokeWidth, 0.0, maintainAspectRatio, backgroundColor);
}

void YPContextDrawRoundedRectImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL maintainAspectRatio, CGColorRef backgroundColor) {  
  _YPContextDrawImage(context, image, rect, strokeColor, strokeWidth, cornerRadius, maintainAspectRatio, backgroundColor);
}

void _YPContextDrawImage(CGContextRef context, CGImageRef image, CGRect rect, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius, BOOL maintainAspectRatio, CGColorRef backgroundColor) {  
  CGContextSaveGState(context);
  
  // TODO(gabe): Fails if cornerRadius = 0
  if (strokeWidth > 0 && cornerRadius > 0) {
    YPContextAddRoundedRect(context, rect, strokeWidth, cornerRadius);
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
    imageBounds = YPScaleToFillAndCenter(CGSizeMake(imageWidth, imageHeight), rect.size);
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
    YPContextDrawRoundedRect(context, rect, NULL, strokeColor, strokeWidth, cornerRadius);
  CGContextRestoreGState(context);
}

CGRect YPScaleToFillAndCenter(CGSize size, CGSize sizeToFill) {
  if (YPCGSizeIsEmpty(size)) return CGRectZero;
  
  CGRect rect;
  CGFloat widthScaleRatio = sizeToFill.width / size.width;
  CGFloat heightScaleRatio = sizeToFill.height / size.height;
    
  if (widthScaleRatio < heightScaleRatio) {
    CGFloat height = size.height * widthScaleRatio;
    CGFloat y = sizeToFill.height / 2.0 - height / 2.0;
    rect = CGRectMake(0, y, sizeToFill.width, height);
  } else {
    CGFloat width = size.width * heightScaleRatio;
    CGFloat x = sizeToFill.width / 2.0 - width / 2.0;
    rect = CGRectMake(x, 0, width, sizeToFill.height);
  }
  return rect;
}

BOOL YPCGPointIsZero(CGPoint p) {
  return (YPIsEqualWithAccuracy(p.x, 0, 0.0001) && YPIsEqualWithAccuracy(p.y, 0, 0.0001));
}

BOOL YPCGPointIsEqual(CGPoint p1, CGPoint p2) {
  return (YPIsEqualWithAccuracy(p1.x, p2.x, 0.0001) && YPIsEqualWithAccuracy(p1.y, p2.y, 0.0001));
}

BOOL YPCGRectIsEqual(CGRect rect1, CGRect rect2) {
  return (YPCGPointIsEqual(rect1.origin, rect2.origin) && YPCGSizeIsEqual(rect1.size, rect2.size));  
}
                      
CGRect YPCGRectToCenterY(CGRect rect, CGRect inRect) {
  CGPoint centeredPoint = YPPointToCenter(rect.size, inRect.size);
  return YPCGRectSetY(rect, centeredPoint.y);
}

CGPoint YPCGPointToCenterY(CGSize size, CGSize inSize) {
  CGPoint p = CGPointMake(0, roundf((inSize.height - size.height) / 2.0));
  if (p.y < 0) p.y = 0;
  return p;
}

CGPoint YPPointToCenter(CGSize size, CGSize inSize) {
  // We round otherwise views will anti-alias
  CGPoint p = CGPointMake(roundf((inSize.width - size.width) / 2.0), roundf((inSize.height - size.height) / 2.0));
  if (p.x < 0) p.x = 0;
  if (p.y < 0) p.y = 0;
  return p;
}

CGPoint YPPointToRight(CGSize size, CGSize inSize) {
  CGPoint p = CGPointMake(inSize.width - size.width, roundf(inSize.height / 2.0 - size.height / 2.0));
  if (p.x < 0) p.x = 0;
  if (p.y < 0) p.y = 0;
  return p;
}

BOOL YPCGSizeIsEqual(CGSize size1, CGSize size2) {
  return (YPIsEqualWithAccuracy(size1.height, size2.height, 0.0001) && YPIsEqualWithAccuracy(size1.width, size2.width, 0.0001));
}


BOOL YPCGSizeIsEmpty(CGSize size) {
  return (YPIsEqualWithAccuracy(size.height, 0, 0.0001) && YPIsEqualWithAccuracy(size.width, 0, 0.0001));
}

CGRect YPSizeToCenterRect(CGSize size, CGSize inSize) {
  CGPoint p = YPPointToCenter(size, inSize);
  return CGRectMake(p.x, p.y, size.width, size.height);
}

CGRect YPRectToCenterRect(CGSize size, CGRect inRect) {
  CGPoint p = YPPointToCenter(size, inRect.size);
  return CGRectMake(p.x + inRect.origin.x, p.y + inRect.origin.y, size.width, size.height);
}

CGFloat YPPositionToCenter(CGFloat length, CGFloat inLength, CGFloat min) {
  CGFloat pos = roundf(inLength / 2.0 - length / 2.0);
  if (pos < min) pos = min;
  return pos;
}

CGRect YPCGRectAdd(CGRect rect1, CGRect rect2) {
  return CGRectMake(rect1.origin.x + rect2.origin.x, rect1.origin.y + rect2.origin.y, rect1.size.width + rect2.size.width, rect1.size.height + rect2.size.height);
}

CGRect YPCGRectRightAlign(CGFloat y, CGFloat width, CGFloat inWidth, CGFloat maxWidth, CGFloat padRight, CGFloat height) {
  if (width > maxWidth) width = maxWidth;
  CGFloat x = (inWidth - width - padRight);
  return CGRectMake(x, y, width, height);
}

CGRect YPCGRectZeroOrigin(CGRect rect) {
  return CGRectMake(0, 0, rect.size.width, rect.size.height);
}

CGRect YPCGRectSetSize(CGRect rect, CGSize size) {
  rect.size = size;
  return rect;
}

CGRect YPCGRectSetHeight(CGRect rect, CGFloat height) {
  rect.size.height = height;
  return rect;  
}

CGRect YPCGRectAddHeight(CGRect rect, CGFloat add) {
  rect.size.height += add;
  return rect;  
}

CGRect YPCGRectAddX(CGRect rect, CGFloat add) {
  rect.origin.x += add;
  return rect;  
}

CGRect YPCGRectAddY(CGRect rect, CGFloat add) {
  rect.origin.y += add;
  return rect;  
}

CGRect YPCGRectSetWidth(CGRect rect, CGFloat width) {
  rect.size.width = width;
  return rect;  
}

CGRect YPCGRectSetOrigin(CGRect rect, CGFloat x, CGFloat y) {
  rect.origin = CGPointMake(x, y);
  return rect;
}

CGRect YPCGRectSetX(CGRect rect, CGFloat x) {
  rect.origin.x = x;
  return rect;
}

CGRect YPCGRectSetY(CGRect rect, CGFloat y) {
  rect.origin.y = y;
  return rect;
}

CGRect YPCGRectSetOriginPoint(CGRect rect, CGPoint p) {
  rect.origin = p;
  return rect;
}

CGRect YPCGRectOriginSize(CGPoint origin, CGSize size) {
  CGRect rect;
  rect.origin = origin;
  rect.size = size;
  return rect;
}

CGRect YPCGRectAddPoint(CGRect rect, CGPoint p) {
  rect.origin.x += p.x;
  rect.origin.y += p.y;
  return rect;
}

CGPoint YPBottomRight(CGRect rect) {
  return CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
}

#pragma mark Border Styles

void YPContextAddStyledRect(CGContextRef context, CGRect rect, YPUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius) {  
  CGPathRef path = YPCreateStyledRect(rect, style, strokeWidth, alternateStrokeWidth, cornerRadius);
  CGContextAddPath(context, path);  
  CGPathRelease(path);
}

CGPathRef YPCreateStyledRect(CGRect rect, YPUIBorderStyle style, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius) {  
  
  CGFloat fw, fh;
  CGFloat cornerWidth = cornerRadius, cornerHeight = cornerRadius;
  assert(cornerWidth > 0 && cornerHeight > 0);
  
  if (style == YPUIBorderStyleRounded)
    return YPCreateRoundedRect(rect, strokeWidth, cornerRadius);
  
  CGFloat strokeInset = strokeWidth/2.0;
  CGFloat alternateStrokeInset = alternateStrokeWidth/2.0;
  
  // Need to adjust path rect to inset (since the stroke is drawn from the middle of the path)
  CGRect insetBounds;
  switch(style) {
    case YPUIBorderStyleRoundedBottomWithAlternateTop:
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + alternateStrokeInset, rect.size.width-(strokeInset * 2), rect.size.height-alternateStrokeInset-strokeInset);
      break;
      
    case YPUIBorderStyleLeftRightWithAlternateTop:
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + alternateStrokeInset, rect.size.width-(strokeInset * 2), rect.size.height-alternateStrokeInset);
      break;
      
    case YPUIBorderStyleRoundedTop:
      // Inset stroke width except for bottom border
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + strokeInset, rect.size.width-(strokeInset * 2), rect.size.height-strokeInset);
      break;
      
    case YPUIBorderStyleNormal:
      insetBounds = CGRectMake(rect.origin.x + strokeInset, rect.origin.y + strokeInset, rect.size.width - (strokeInset * 2), rect.size.height - (strokeInset * 2));
      break;
  }
  rect = insetBounds;
  
  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformTranslate(transform, CGRectGetMinX(rect), CGRectGetMinY(rect));
  transform = CGAffineTransformScale(transform, cornerWidth, cornerHeight);
  
  fw = CGRectGetWidth(rect) / cornerWidth;
  fh = CGRectGetHeight(rect) / cornerHeight;
  
  CGMutablePathRef path = CGPathCreateMutable();
  
  switch(style) {
    case YPUIBorderStyleRoundedBottomWithAlternateTop:
      CGPathMoveToPoint(path, &transform, fw, 0); 
      CGPathAddLineToPoint(path, &transform, fw, fh/2);
      CGPathAddArcToPoint(path, &transform, fw, fh, fw/2, fh, 1);
      CGPathAddArcToPoint(path, &transform, 0, fh, 0, fh/2, 1);
      CGPathAddLineToPoint(path, &transform, 0, 0);
      CGPathMoveToPoint(path, &transform, fw, 0); // Don't draw top border
      break;
      
    case YPUIBorderStyleRoundedTop:
      CGPathMoveToPoint(path, &transform, 0, fh);
      CGPathAddLineToPoint(path, &transform, 0, fh/2);
      CGPathAddArcToPoint(path, &transform, 0, 0, fw/2, 0, 1);
      CGPathAddArcToPoint(path, &transform, fw, 0, fw, fh/2, 1);      
      CGPathAddLineToPoint(path, &transform, fw, fh);
      CGPathMoveToPoint(path, &transform, 0, fh); // Don't draw bottom border
      break;
      
    case YPUIBorderStyleLeftRightWithAlternateTop:
      // Go +/- 2 in order to clip the top and bottom border; Only draw left, right border
      CGPathMoveToPoint(path, &transform, 0, fh + 2);
      CGPathAddLineToPoint(path, &transform, 0, -2);
      CGPathAddLineToPoint(path, &transform, fw, -2);
      CGPathAddLineToPoint(path, &transform, fw, fh + 2);
      CGPathAddLineToPoint(path, &transform, 0, fh + 2);
      break;
      
    case YPUIBorderStyleNormal:
      CGPathMoveToPoint(path, &transform, 0, fh);
      CGPathAddLineToPoint(path, &transform, 0, 0);
      CGPathAddLineToPoint(path, &transform, fw, 0);      
      CGPathAddLineToPoint(path, &transform, fw, fh);
      CGPathAddLineToPoint(path, &transform, 0, fh);
      break;
  }
  
  return path;
}

BOOL YPAddAlternateBorderToPath(CGContextRef context, CGRect rect, YPUIBorderStyle style) {
  CGFloat cornerWidth = 10, cornerHeight = 10;
  
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextScaleCTM (context, cornerWidth, cornerHeight);
  CGFloat fw = CGRectGetWidth(rect) / cornerWidth;
  
  BOOL hasPath = NO;
  
  switch(style) {
    case YPUIBorderStyleRoundedBottomWithAlternateTop:
    case YPUIBorderStyleLeftRightWithAlternateTop:
      CGContextMoveToPoint(context, 0, 0);
      CGContextAddLineToPoint(context, fw, 0);
      hasPath = YES;
      break;
      
    default:
      // Other styles don't use alternate stroke
      break;
  }
  
  CGContextRestoreGState(context);
  return hasPath;
}

void _YPContextDrawStyledRect(CGContextRef context, CGRect rect, YPUIBorderStyle style, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat cornerRadius) {
  CGContextSetLineWidth(context, strokeWidth);
  
  YPContextAddStyledRect(context, rect, style, strokeWidth, 0, cornerRadius); 
  
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

void YPDrawBorder(CGContextRef context, CGRect rect, YPUIBorderStyle style, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth, CGFloat alternateStrokeWidth, CGFloat cornerRadius) {

  _YPContextDrawStyledRect(context, rect, style, fillColor, strokeColor, strokeWidth, cornerRadius);
  
  if (alternateStrokeWidth > 0) {
    CGContextSetLineWidth(context, alternateStrokeWidth);
    CGContextBeginPath(context);
    if (YPAddAlternateBorderToPath(context, rect, style))
      CGContextDrawPath(context, kCGPathStroke);
  }
}

void YPContextDrawRect(CGContextRef context, CGRect rect, CGColorRef fillColor, CGColorRef strokeColor, CGFloat strokeWidth) {
  _YPContextDrawStyledRect(context, rect, YPUIBorderStyleNormal, fillColor, strokeColor, strokeWidth, 1);
}

#pragma mark Colors

void YPGetColorComponents(CGColorRef color, CGFloat *red, CGFloat *green, CGFloat *blue, CGFloat *alpha) {
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
} _YPUIButtonTwoColors;

// Only uses main color
void _horizontalEdgeColorBlendFunctionImpl(void *info, const float *in, float *out, BOOL reverse) {
  _YPUIButtonTwoColors *twoColors = (_YPUIButtonTwoColors *)info;
  
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

void _horizontalEdgeColorBlendFunction(void *info, const float *in, float *out) {
  _horizontalEdgeColorBlendFunctionImpl(info, in, out, NO);
}

void _horizontalReverseEdgeColorBlendFunction(void *info, const float *in, float *out) {
  _horizontalEdgeColorBlendFunctionImpl(info, in, out, YES);
}

void _linearColorBlendFunction(void *info, const float *in, float *out) {
  _YPUIButtonTwoColors *twoColors = info;
  
  out[0] = (1.0 - *in) * twoColors->red1 + *in * twoColors->red2;
  out[1] = (1.0 - *in) * twoColors->green1 + *in * twoColors->green2;
  out[2] = (1.0 - *in) * twoColors->blue1 + *in * twoColors->blue2;
  out[3] = (1.0 - *in) * twoColors->alpha1 + *in * twoColors->alpha2;
}

void _exponentialColorBlendFunction(void *info, const float *in, float *out) {
  _YPUIButtonTwoColors *twoColors = info;
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


void YPContextDrawShadingWithHeight(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGFloat height, YPUIShadingType shadingType) {
  YPContextDrawShading(context, color, alternateColor, CGPointMake(0, 0), CGPointMake(0, height), shadingType, YES, YES);
}

void YPContextDrawShading(CGContextRef context, CGColorRef color, CGColorRef alternateColor, CGPoint start, CGPoint end, YPUIShadingType shadingType, 
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
  
  _YPUIButtonTwoColors *twoColors = malloc(sizeof(_YPUIButtonTwoColors));
  
  YPGetColorComponents(color, &twoColors->red1, &twoColors->green1, &twoColors->blue1, &twoColors->alpha1);
  YPGetColorComponents((alternateColor != NULL ? alternateColor : color), &twoColors->red2, &twoColors->green2, &twoColors->blue2, &twoColors->alpha2);
  
  static const float domainAndRange[8] = {0.0, 1.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0};
  
  CGFunctionRef blendFunctionRef = CGFunctionCreate(twoColors, 1, domainAndRange, 4, domainAndRange, callbacks);
  CGShadingRef shading = CGShadingCreateAxial(colorSpace, start, end, blendFunctionRef, extendStart, extendEnd);
  CGContextDrawShading(context, shading);
  CGShadingRelease(shading);
  CGFunctionRelease(blendFunctionRef);
  CGColorSpaceRelease(colorSpace);
}
