//
//  UIColor+commom_use.m
//  LeitzIcon
//
//  Created by Leonid 100500 on 7/24/13.
//  Copyright (c) 2013 Esselte. All rights reserved.
//

#import "UIColor+commom_use.h"

@implementation UIColor (commom_use)

+ (UIImage *)patternImage {
	return [UIImage imageNamed:@"grayscalepattern.png"];
}

+ (UIColor *)patternColorAtIndex:(NSUInteger)index {
	if (index > 9) {
		index = 9;
	}
	UIImage * patWholeImg = [self patternImage];
	if (!patWholeImg) {
		NSLog(@"cannot load pattern image!");
		return nil;
	}
	CGRect rect = CGRectMake(3*index, 0, 3, 3);
	CGImageRef cgimg = CGImageCreateWithImageInRect([patWholeImg CGImage], rect);
	UIImage * patImg = [UIImage imageWithCGImage:cgimg];
	CGImageRelease(cgimg);
	return [UIColor colorWithPatternImage:patImg];
}

@end
