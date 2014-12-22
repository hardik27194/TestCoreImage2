//
//  MyImageView.m
//  TestCoreImage
//
//  Created by 100500 on 12/19/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "MyImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyImageView

- (void)dealloc {
	self.CGImage = NULL;
}

- (void)setCGImage:(CGImageRef)CGImage {
	if (_CGImage != CGImage) {
		if (_CGImage) {
			CFRelease(_CGImage);
		}
		_CGImage = CGImage;
		if (_CGImage) {
			CFRetain(_CGImage);
		}
	}
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	if (!self.CGImage) {
		return;
	}

	[[UIColor redColor] set];
	CGContextRef cx = UIGraphicsGetCurrentContext();
	CGRect imgRect = CGRectMake(20, 20, 350, 250);
	const CGFloat lineWidth = 1;
	UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:imgRect];
	bezier.lineWidth = lineWidth;
	CGContextAddPath(cx, bezier.CGPath);
	CGContextStrokePath(cx);
	imgRect = CGRectInset(imgRect, lineWidth, lineWidth);
	CGContextTranslateCTM(cx, imgRect.origin.x, imgRect.origin.y);
	imgRect.origin = CGPointZero;

	CGContextTranslateCTM(cx, 0, imgRect.size.height);
	CGContextScaleCTM(cx, 1, -1);

	CGRect tileRect = CGRectMake(950, 300, 600, 0);
	const CGFloat imageRatio = imgRect.size.width/imgRect.size.height;
	tileRect.size.height = tileRect.size.width / imageRatio;
	CGImageRef img2 = CGImageCreateWithImageInRect(self.CGImage, tileRect);
	CGContextDrawImage(cx, imgRect, img2);




	[[[UIColor greenColor] colorWithAlphaComponent:0.2] set];
	bezier = [UIBezierPath bezierPathWithRect:imgRect];
	bezier.lineWidth = lineWidth;
	const CGFloat dash[] = {15,15};
	[bezier setLineDash:dash count:2 phase:0];
	CGContextAddPath(cx, bezier.CGPath);
	CGContextStrokePath(cx);

}

@end
