//
//  Paper.m
//  TestCoreImage
//
//  Created by 100500 on 13/01/15.
//  Copyright (c) 2015 Leonid 100500. All rights reserved.
//

#import "PIPaperInfo.h"

@implementation PIPaperInfo (extra_dbg)

+ (PIPaperInfo *)paper88x28 {
	PIPaperInfo *paper = [self new];
	paper.paperSize = CGSizeMake(249.4, 79.4);
	paper.margins = UIEdgeInsetsMake(3.6, 9.5, 3.6, 9.5);
	return paper;
}

+ (PIPaperInfo *)paper39A {
	PIPaperInfo *paper = [self new];
	paper.paperSize = CGSizeMake(103.4, 537.1);
	paper.margins = UIEdgeInsetsMake(3.6, 3.6, 3.6, 3.6);
	return paper;
}

+ (PIPaperInfo *)paper39B {
	PIPaperInfo *paper = [self new];
	paper.paperSize = CGSizeMake(103.4, 800.7);
	paper.margins = UIEdgeInsetsMake(3.6, 3.6, 3.6, 3.6);
	return paper;
}

+ (PIPaperInfo *)paperForSimulatorLabel {
	PIPaperInfo *paper = [self new];
	paper.paperSize = CGSizeMake(72, 252);
	return paper;
}

+ (PIPaperInfo *)paper88x50 {
	PIPaperInfo *paper = [self new];
	paper.paperSize = CGSizeMake(141.7, 249.4);
	paper.margins = UIEdgeInsetsMake(9.5, 3.6, 9.5, 3.6);
	return paper;
}

+ (PIPaperInfo *)paper19A {
	PIPaperInfo *paper = [self new];
	paper.paperSize = CGSizeMake(46.7, 136.8);
	paper.margins = UIEdgeInsetsMake(3.6, 3.6, 3.6, 3.6);
	return paper;
}

+ (PIPaperInfo *)paper19B {
	PIPaperInfo *paper = [self new];
	paper.paperSize = CGSizeMake(46.7, 172.8);
	paper.margins = UIEdgeInsetsMake(3.6, 3.6, 3.6, 3.6);
	return paper;
}

- (BOOL)isEqualToUIPrintPaper:(UIPrintPaper *)pp {
	assert(nil != pp);

	//	normalize both and then compare by paperSize
	CGSize ppSize = pp.paperSize;
	if (ppSize.width < ppSize.height) {
		SWAP(ppSize.width, ppSize.height);
	}
	CGSize thisSize = self.paperSize;
	if (thisSize.width < thisSize.height) {
		SWAP(thisSize.width, thisSize.height);
	}
	const CGFloat precision = 1;
	return	(fabsf(ppSize.width - thisSize.width)	< precision) &&
			(fabsf(ppSize.height - thisSize.height) < precision);
}

- (PIPaperInfo *)copyRotated90 {
	PIPaperInfo *paper = [[self class] new];
	paper.paperSize = CGSizeMake(self.paperSize.height, self.paperSize.width);
	UIEdgeInsets margins = self.margins;
	SWAP(margins.top, margins.left);
	SWAP(margins.bottom, margins.right);
	paper.margins = margins;
	paper.paperName = self.paperName;
	paper.widthInMillimeters = self.widthInMillimeters;
	paper.heightInMillimeters = self.heightInMillimeters;
	return paper;
}

- (PIPaperInfo *)copyBorderless {
	PIPaperInfo *paper = [[self class] new];
	paper.paperSize = self.printableRect.size;
	paper.paperName = self.paperName;
	paper.widthInMillimeters = self.widthInMillimeters;
	paper.heightInMillimeters = self.heightInMillimeters;
	return paper;
}

- (NSString *)shortDescription {
	return [NSString stringWithFormat:@"%03.1f %03.1fpt %@ '%@'",
			self.paperSize.width, self.paperSize.height,
			self.localizedSizeString,
			self.paperName];
}

- (NSString *)description {
	CGRect printableRect = self.printableRect;
	return [NSString stringWithFormat:@"<%@ %p> [%03.1fx%03.1f]  {%2.1f, %2.1f; %03.1fx%03.1f}", [self class], self,
			self.paperSize.width, self.paperSize.height,
			printableRect.origin.x, printableRect.origin.y, printableRect.size.width, printableRect.size.height];
}

@end
