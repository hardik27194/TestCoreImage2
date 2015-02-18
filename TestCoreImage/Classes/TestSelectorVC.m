//
//  TestSelectorVC.m
//  TestCoreImage
//
//  Created by 100500 on 12/01/15.
//  Copyright (c) 2015 Leonid 100500. All rights reserved.
//

#import "TestSelectorVC.h"
#import "UIColor+commom_use.h"
#include "CGGeometryFunctions.h"
#import "PIPaperInfo.h"
#import "Paper.h"
#import "SettingsModel.h"

@interface TestSelectorVC ()
<UIPrintInteractionControllerDelegate>
@property (nonatomic, retain) NSString	*namePrefix;
@property (nonatomic, retain) NSString	*text;
@property (nonatomic, retain) NSDictionary	*textAttributes;
@end

@implementation TestSelectorVC


- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor patternColorAtIndex:2];
	NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
	paragraph.alignment = NSTextAlignmentCenter;
	SettingsModel *settings = [SettingsModel shared];
	self.textAttributes = @{
							 NSFontAttributeName : [UIFont boldSystemFontOfSize:13 * settings.scaleFactor],
							 NSForegroundColorAttributeName : [UIColor blackColor],
							 NSBackgroundColorAttributeName : [UIColor clearColor],
							 NSStrokeColorAttributeName : [UIColor whiteColor],
							 NSStrokeWidthAttributeName : @(-settings.scaleFactor),
							 NSParagraphStyleAttributeName : paragraph
							 };
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	PIPaperInfo *paper = self.paper;
	if (paper.isContinuous) {
		//	update continuous length from settings
		SettingsModel *settings = [SettingsModel shared];
		CGSize sz = paper.paperSize;
		sz.height = settings.continuousLength;
		paper.paperSize = sz;
	}
}

- (NSURL *)createPdfWithPaper:(PIPaperInfo *)paper {
	assert(nil != paper);

	NSURL *dirURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask | NSLocalDomainMask][0];
	NSString *dir = [dirURL path];
	if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
		const BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
		if (!success) {
			NSLog(@"wrong dir");
			return nil;
		}
	}
	NSString *name = [NSString stringWithFormat:@"%@_%2.0fx%2.0f.pdf",
					  self.namePrefix, paper.paperSize.width, paper.paperSize.height];
	NSString *path = [dir stringByAppendingPathComponent:name];
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
	NSLog(@"path:'%@'", path);

	CGRect bounds = { CGPointZero, paper.paperSize };
	UIGraphicsBeginPDFContextToFile(path, bounds, NULL);
	CGRect printableRect = paper.printableRect;
	UIGraphicsBeginPDFPageWithInfo(bounds, NULL);
	[self drawGrayscaleInRect:printableRect];
//	[[UIColor whiteColor] set];
//	UIRectFill(bounds);
	[[UIColor blackColor] set];
	UIRectFrame(printableRect);
	UIGraphicsEndPDFContext();

	return [NSURL fileURLWithPath:path];
}

- (NSURL *)createImageWithPaper:(PIPaperInfo *)paper {
	assert(nil != paper);

	SettingsModel *settings = [SettingsModel shared];
	const CGRect printableRect = CGRectScale(paper.printableRect, settings.scaleFactor) ;
	const CGSize paperSize = CGSizeScale(paper.paperSize, settings.scaleFactor);

	UIGraphicsBeginImageContextWithOptions(paperSize, YES, 1);
	[[UIColor whiteColor] set];
	CGRect bounds = {CGPointZero, paperSize};
	UIRectFill(bounds);
	[self drawGrayscaleInRect:printableRect];
	CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 1);
	[[UIColor blackColor] set];
	UIRectFrame(printableRect);
	//	text
	if (self.text) {
		CGRect textRect = printableRect;
		if (printableRect.size.width < printableRect.size.height) {
			CGContextRef cx = UIGraphicsGetCurrentContext();
			CGContextTranslateCTM(cx, CGRectGetMidX(printableRect), CGRectGetMidY(printableRect));
			CGContextRotateCTM(cx, -M_PI_2);
			CGContextTranslateCTM(cx, -CGRectGetMidY(printableRect), -CGRectGetMidX(printableRect));
			SWAP(textRect.size.width, textRect.size.height);
			SWAP(textRect.origin.x, textRect.origin.y);
		}
		NSAttributedString *drawText = [[NSAttributedString alloc] initWithString:self.text attributes:self.textAttributes];
		[drawText drawInRect:textRect];
	}
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	NSData *imgData = UIImageJPEGRepresentation(img, 0.9);
	UIGraphicsEndImageContext();


	NSURL *dirURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask | NSLocalDomainMask][0];
	NSString *dir = [dirURL path];
	if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
		const BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:NULL];
		if (!success) {
			NSLog(@"wrong dir");
			return nil;
		}
	}
	NSString *name = [NSString stringWithFormat:@"%@_%2.0fx%2.0f.jpg",
					  self.namePrefix, paper.paperSize.width, paper.paperSize.height];
	NSString *path = [dir stringByAppendingPathComponent:name];
	[[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
	NSLog(@"path:'%@'", path);

	return [imgData writeToFile:path atomically:YES] ? [NSURL fileURLWithPath:path] : nil;
}

- (void)drawGrayscaleInRect:(CGRect)rect {
	const int colorCount = 10;
	const CGFloat itemWidth = rect.size.width / (CGFloat)colorCount;
	CGRect itemRect = rect;
	itemRect.size.width = itemWidth;
	for (int ii=0; ii<colorCount; ++ii, itemRect.origin.x += itemWidth)
	{
		UIColor *color = [UIColor patternColorAtIndex:ii];
		[color set];
		UIRectFill(itemRect);
	}
}

- (IBAction)actPrint2:(UIButton*)sender
{
	UIPrintInteractionController *prnCtr = [UIPrintInteractionController sharedPrintController];
	prnCtr.delegate = self;

	SettingsModel *settings = [SettingsModel shared];

	PIPaperInfo *paper = self.paper;
	if (paper.isContinuous) {
		CGSize sz = paper.paperSize;
		sz.height = settings.continuousLength;
		paper.paperSize = sz;
	}
	if (settings.isPortrait) {
		paper = [paper copyRotated90];
	}
	PIPaperInfo *paper2 = [paper copyBorderless];
	NSMutableArray *printItems = [NSMutableArray array];
	NSURL *item = nil;

	if (settings.bitmapFormat == BitmapFormatJpg) {
//		self.namePrefix = @"paper";
//		self.text = [NSString stringWithFormat:@"%@ +b", [paper shortDescription]];
//		item = [self createImageWithPaper:self.paper];

		self.namePrefix = @"bdless";
		self.text = [NSString stringWithFormat:@"%@ -b", [paper2 shortDescription]];
		item = [self createImageWithPaper:paper2];

		[printItems addObject:item];
	}
	else {
//		self.namePrefix = @"paper";
//		self.text = [NSString stringWithFormat:@"%@ +b", [paper shortDescription]];
//		item = [self createPdfWithPaper:self.paper];

		self.namePrefix = @"bdless";
		self.text = [NSString stringWithFormat:@"%@ -b", [paper2 shortDescription]];
		item = [self createPdfWithPaper:paper2];

		[printItems addObject:item];
	}
	prnCtr.printingItems = printItems;


	UIPrintInteractionCompletionHandler completion = ^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
		;
		NSLog(@"completed");
	};
	if (IsIpad) {
		[prnCtr presentFromRect:sender.frame inView:sender.superview animated:YES completionHandler:completion];
	}
	else {
		[prnCtr presentAnimated:YES completionHandler:completion];
	}
}

#pragma mark - UIPrintInteractionControllerDelegate

//- (UIViewController *)printInteractionControllerParentViewController:(UIPrintInteractionController *)printInteractionController;
//- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController;
//- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController;
//- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController;
//- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController;
//
//- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController;
//- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController;

- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList {
	NSLog(@"%@", paperList);
	for (UIPrintPaper *p in paperList) {
		if ([self.paper isEqualToUIPrintPaper:p]) {
			NSLog(@">>>>%@", p);
			return p;
		}
	}
	return nil;
}

- (CGFloat)printInteractionController:(UIPrintInteractionController *)printInteractionController cutLengthForPaper:(UIPrintPaper *)paper {
	const CGFloat height = self.paper.paperSize.height;
	NSLog(@"leng; %@; %2.1f", paper, height);
	return height;
}

@end



@implementation UIPrintPaper (debug)

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ %p> [%03.1fx%03.1f]  {%2.1f, %2.1f; %03.1fx%03.1f}", [self class], self,
			self.paperSize.width, self.paperSize.height,
			self.printableRect.origin.x, self.printableRect.origin.y, self.printableRect.size.width, self.printableRect.size.height];
}

@end
