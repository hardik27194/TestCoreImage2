//
//  ZPatternView.m
//  DrawPatternTest1
//
//  Created by 100500 on 12/22/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "ZPatternView.h"

@implementation ZPatternView

void GrayscalePatternReleaseInfoCallback ( void * info ) {
}

//	10 patterns 'Halftoning Lecture Slides copy.pdf', chapter 5.4
void GrayscalePatternDrawPatternCallback (void *info, CGContextRef myContext)
{
	const int index = (int)info;
	const unsigned char DitherPatterns[10][9] = {
		{0,0,0,0,0,0,0,0,0},{0,0,0,0,1,0,0,0,0},{0,0,0,1,1,0,0,0,0},{0,0,0,1,1,0,0,1,0},{0,0,0,1,1,1,0,1,0},
		{0,0,1,1,1,1,0,1,0},{0,0,1,1,1,1,1,1,0},{1,0,1,1,1,1,1,1,0},{1,0,1,1,1,1,1,1,1},{1,1,1,1,1,1,1,1,1}};
	const unsigned char *ditherPattern = DitherPatterns[index];
	size_t ii = 0;
	size_t pointsCount = 0;
	CGRect rects[9] = {0};
	for (size_t ix = 0; ix < 3; ++ix) {
		for (size_t iy = 0; iy < 3; ++iy) {
			if (!ditherPattern[ii++]) {
				rects[pointsCount++] = CGRectMake(ix, iy, 1, 1);
			}
		}
	}
	CGContextSetFillColorWithColor(myContext, [UIColor whiteColor].CGColor);
	CGContextFillRect(myContext, CGRectMake(0, 0, 3, 3));
	if (pointsCount) {
		CGContextSetFillColorWithColor(myContext, [UIColor blackColor].CGColor);
		CGContextFillRects(myContext, rects, pointsCount);
	}
}

const CGPatternCallbacks GrayPatternCallbacks = {0, &GrayscalePatternDrawPatternCallback, &GrayscalePatternReleaseInfoCallback};


- (void)drawRect:(CGRect)rect {

	CGContextRef cx = UIGraphicsGetCurrentContext();
	CGColorSpaceRef deviceGray = CGColorSpaceCreateDeviceGray();
	CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern (deviceGray);
	CGContextSetFillColorSpace (cx, patternSpace);
	CGColorSpaceRelease (patternSpace);
	CGColorSpaceRelease (deviceGray);

	CGContextSetStrokeColorWithColor(cx, [UIColor redColor].CGColor);
	CGContextSetLineWidth(cx, 5);

	const CGFloat patternColorComponents[] = {1,1,1,1};
	CGRect fillRect = rect;
	const CGFloat stepH = rect.size.height/10.0;
	fillRect.size.height = stepH;
	for (int index = 9; index >= 0; --index) {
		CGPatternRef myPattern = CGPatternCreate((void*)index, CGRectMake(0, 0, 3, 3), CGAffineTransformIdentity, 3, 3, kCGPatternTilingConstantSpacing, NO, &GrayPatternCallbacks);
		CGContextSetFillPattern (cx, myPattern, patternColorComponents);
		CGContextFillRect(cx, fillRect);
		CGContextStrokeRect(cx, CGRectInset(fillRect, 5, 5));
		fillRect.origin.y += stepH;
	}
}

@end
