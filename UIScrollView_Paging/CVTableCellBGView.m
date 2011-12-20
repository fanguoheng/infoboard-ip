//
//  CVTableCellBGView.m
//  Restaurant
//
//  Created by Kesalin on 6/21/11.
//  Copyright 2011 kesalin@gmail.com. All rights reserved.
//

#import "CVTableCellBGView.h"

#define kArcRadius          10
#define kShadowBlur         1.0
#define kShadowOffsetX      2.0
#define kShadowOffsetY      2.0
#define kShadowColor        [UIColor blackColor]
#define kFillColor          [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0]

float* getGradientColor(int type)
{
#define kGradientColorComponentsLen     16
    static const float components[] = {
        0.860, 0.860, 0.860, 1.0,
        0.900, 0.900, 0.900, 1.0,
        0.940, 0.940, 0.940, 1.0,
        1.000, 1.000, 1.000, 1.0,//white

        0.250, 0.250, 0.250, 1.0,
        0.205, 0.205, 0.205, 1.0,
        0.155, 0.155, 0.155, 1.0,
        0.050, 0.050, 0.050, 1.0,//black
        
        0.843, 0.843, 0.843, 1.0,
        0.549, 0.549, 0.549, 1.0,
        0.302, 0.302, 0.302, 1.0,
        0.200, 0.200, 0.200, 1.0,//gray
        
        0.999, 0.984, 0.976, 1.0,
        0.925, 0.800, 0.706, 1.0,
        0.876, 0.658, 0.500, 1.0,
        0.863, 0.625, 0.447, 1.0,//red
        
        0.984, 0.999, 0.976, 1.0,
        0.800, 0.925, 0.706, 1.0,
        0.658, 0.876, 0.500, 1.0,
        0.625, 0.863, 0.447, 1.0,//green
        
        0.976, 0.984, 0.999, 1.0,
        0.706, 0.800, 0.925, 1.0,
        0.500, 0.658, 0.876, 1.0,
        0.447, 0.625, 0.863, 1.0,//blue
        
        0.984, 0.950, 0.920, 1.0,
        0.972, 0.850, 0.880, 1.0,
        0.966, 0.775, 0.840, 1.0,
        0.960, 0.725, 0.796, 1.0,//pink
    };

    if (type >= GradientColorCount || type <= GradientColorNone)
        return NULL;
    
    static float colors[kGradientColorComponentsLen];
    memcpy(colors, (float *)(&components[(type - 1) * kGradientColorComponentsLen]), kGradientColorComponentsLen * sizeof(float));
    return colors;
    
#undef kGradientColorComponentsLen
}

@interface CVTableCellBGView(PrivateMethods)

- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count;

- (void)contextTopPathWith:(CGContextRef)context rec:(CGRect)rect;
- (void)contextMiddlePathWith:(CGContextRef)context rec:(CGRect)rect;
- (void)contextBottomPathWith:(CGContextRef)context rec:(CGRect)rect;
- (void)contextSinglePathWith:(CGContextRef)context rec:(CGRect)rect;

- (void)drawRoundShadowWith:(CGContextRef)context rect:(CGRect)rect cellStyle:(CellStyle)style;
- (void)drawGradientWith:(CGContextRef)context rect:(CGRect)rect cellStyle:(CellStyle)style;

@end


@implementation CVTableCellBGView

@synthesize cellStyle, gradientColor;

#pragma mark -
#pragma mark init & dealloc

- (id)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        gradientColor = GradientColorNone;//Blue;
    }
  
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Drawing

- (void)contextTopPathWith:(CGContextRef)contextRef rec:(CGRect)rect
{
	rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - kShadowOffsetX, rect.size.height - 1.0);
	
	CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;	
	
	CGContextMoveToPoint(contextRef, minx, maxy);
	CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, kArcRadius);
	CGContextAddArcToPoint(contextRef, maxx, miny, maxx, maxy, kArcRadius);
	CGContextAddLineToPoint(contextRef, maxx, maxy);
	
	CGContextClosePath(contextRef);
}

- (void)contextMiddlePathWith:(CGContextRef)contextRef rec:(CGRect)rect
{
	rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - kShadowOffsetX, rect.size.height - 1.0);
	
	CGFloat minx = CGRectGetMinX(rect) , maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
	
	CGContextMoveToPoint(contextRef, minx, miny);
	CGContextAddLineToPoint(contextRef, maxx, miny);
	CGContextAddLineToPoint(contextRef, maxx, maxy);
	CGContextAddLineToPoint(contextRef, minx, maxy);
	
	CGContextClosePath(contextRef);
}

- (void)contextBottomPathWith:(CGContextRef)contextRef rec:(CGRect)rect
{
	rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - kShadowOffsetX, rect.size.height - kShadowOffsetY);
	
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect);
	
	CGContextMoveToPoint(contextRef, minx, miny);
	CGContextAddArcToPoint(contextRef, minx, maxy, midx, maxy, kArcRadius);
	CGContextAddArcToPoint(contextRef, maxx, maxy, maxx, miny, kArcRadius);
	CGContextAddLineToPoint(contextRef, maxx, miny);
	
	CGContextClosePath(contextRef);
}

- (void)contextSinglePathWith:(CGContextRef)contextRef rec:(CGRect)rect
{
	rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - kShadowOffsetX, rect.size.height - kShadowOffsetY);
	
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect) ;
	
	CGContextSetLineWidth(contextRef, 1.0);
	CGContextMoveToPoint(contextRef, minx, midy);
	CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, kArcRadius);
	CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, kArcRadius);
	CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, kArcRadius);
	CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, kArcRadius);
	
	CGContextClosePath(contextRef);
}

- (void)drawRoundShadowWith:(CGContextRef)contextRef rect:(CGRect)rect cellStyle:(CellStyle)style
{
	CGContextSaveGState(contextRef);
	
	CGContextSetFillColorWithColor(contextRef, kFillColor.CGColor);
	// Shadow
	CGContextSetShadowWithColor(contextRef, CGSizeMake(kShadowOffsetX, kShadowOffsetY), kShadowBlur, kShadowColor.CGColor);
	
	switch (style) {
		case CellStyleTop:
			[self contextTopPathWith:contextRef rec:rect];
			break;
		case CellStyleMiddle:
			[self contextMiddlePathWith:contextRef rec:rect];
			break;
		case CellStyleBottom:
			[self contextBottomPathWith:contextRef rec:rect];
			break;
		case CellStyleSingle:
			[self contextSinglePathWith:contextRef rec:rect];
			break;
		default:
			CGContextRestoreGState(contextRef);
			return;
	}

	// Draw Fill Path
	CGContextDrawPath(contextRef, kCGPathFill);
	
	CGContextRestoreGState(contextRef);
}

- (void)drawGradientWith:(CGContextRef)contextRef rect:(CGRect)rect cellStyle:(CellStyle)style
{
	CGContextSaveGState(contextRef);
	
	switch (style) {
		case CellStyleTop:
			[self contextTopPathWith:contextRef rec:rect];
			break;
		case CellStyleMiddle:
			[self contextMiddlePathWith:contextRef rec:rect];
			break;
		case CellStyleBottom:
			[self contextBottomPathWith:contextRef rec:rect];
			break;
		case CellStyleSingle:
			[self contextSinglePathWith:contextRef rec:rect];
			break;
		default:
			CGContextRestoreGState(contextRef);
			return;
	}
	
    CGContextClip(contextRef);
    
    // Draw gradient color
    float *components = getGradientColor(gradientColor);
    if (components)
    {
        size_t numLocations = 4;
        CGFloat locations[4] = { 0.0, 0.4, 0.6, 1.0 };
        CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
        CGPoint startPoint = CGPointZero;
        CGPoint endPoint = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);

        CGGradientRef gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, numLocations);
        CGContextDrawLinearGradient(contextRef, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient);
    }
	
    CGContextRestoreGState(contextRef);
}

- (void)drawRect:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
	[self drawRoundShadowWith:contextRef rect:rect cellStyle:self.cellStyle];
	[self drawGradientWith:contextRef rect:rect cellStyle:self.cellStyle];
    
    [super drawRect:rect];
}

@end
