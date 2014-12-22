//
//  ZPageRenderer.m
//  TestCoreImage
//
//  Created by 100500 on 12/20/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "ZPageRenderer.h"
#import "ZPatternView.h"
#include "CGGeometryFunctions.h"

@implementation ZPageRenderer

- (CGFloat)headerHeight {
	return 0;
}

- (CGFloat)footerHeight {
	return 0;
}

- (NSInteger)numberOfPages {
	//	how many different copies (aka pages) a label needs to render
	return 1;
}

- (void)prepareForDrawingPages:(NSRange)range {
}

#define ROUND(x) x=roundf(x)

- (void)drawPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)printableRect
{
	const CGRect rect = printableRect;
	CGContextRef cx = UIGraphicsGetCurrentContext();

	if (1) {
		CGContextSaveGState(cx);
		const CGFloat scaleFactor = 4.16666666666667;
		CGRect grayRect = CGRectScale(rect, 1);
		CGContextScaleCTM(cx, scaleFactor, scaleFactor);
		ZPatternView *pv = [ZPatternView new];
		[pv drawRect:grayRect];
		CGContextRestoreGState(cx);
	}


	if (self.image) {
		const CGSize imageSize = self.image.size;
		CGRect imgRect = CGRectZero;
		imgRect.origin = printableRect.origin;
		imgRect.size = CGSizeMake(160, 160);//self.image.size;
		const CGFloat imgRatio = imgRect.size.width/imgRect.size.height;
		if (imgRect.size.width > rect.size.width) {
			imgRect.size.width = rect.size.width;
			imgRect.size.height = imgRect.size.width/imgRatio;
		}
		imgRect = CGRectIntegral(imgRect);
		//	crop central area
//		CGRect cropRect = imgRect;
//		if (cropRect.size.width < imageSize.width) {
//			cropRect.origin.x = 0.5*(imageSize.width - cropRect.size.width);
//		}
//		if (cropRect.size.height < imageSize.height) {
//			cropRect.origin.y = 0.5*(imageSize.height - cropRect.size.height);
//		}
		CGImageRef img2 = self.image.CGImage;
//		img2 = CGImageCreateWithImageInRect(img2, cropRect);
		CGContextDrawImage(cx, imgRect, img2);
	}
	{
		//	draw a cross
		CGContextMoveToPoint(cx, CGRectGetMinX(rect), CGRectGetMinY(rect));
		CGContextAddLineToPoint(cx, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
		CGContextMoveToPoint(cx, CGRectGetMinX(rect), CGRectGetMaxY(rect));
		CGContextAddLineToPoint(cx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
		CGContextClosePath(cx);
		CGContextSetLineWidth(cx, 2);
		CGContextSetStrokeColorWithColor(cx, [UIColor blackColor].CGColor);
		CGContextStrokePath(cx);
	}
}

@end
