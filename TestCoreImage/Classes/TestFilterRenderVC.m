//
//  TestFilterRenderVC.m
//  TestCoreImage
//
//  Created by 100500 on 12/20/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "TestFilterRenderVC.h"
#import "ZPageRenderer.h"

@interface TestFilterRenderVC ()
<UIScrollViewDelegate, UIPrintInteractionControllerDelegate>
@property (nonatomic, retain) UIImageView *iv;
@property (nonatomic, retain) UIScrollView	*scroll;
@end

@implementation TestFilterRenderVC

- (void)loadView {
	CGRect frame = CGRectMake(0, 0, 320, 480);
	self.scroll = [[UIScrollView alloc] initWithFrame:frame];
	self.scroll.contentSize = frame.size;
	self.scroll.backgroundColor = [UIColor blueColor];
	self.scroll.minimumZoomScale = 0.5;
	self.scroll.maximumZoomScale = 5;
	self.scroll.autoresizesSubviews = YES;
	self.scroll.autoresizingMask = 0x3F;
	self.view = self.scroll;
	self.iv = [[UIImageView alloc] initWithFrame:self.scroll.bounds];
	[self.scroll addSubview:self.iv];
	self.iv.autoresizingMask = 0x3F;
	self.scroll.delegate = self;
	self.iv.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Dither" style:UIBarButtonItemStylePlain target:self action:@selector(actApplyFilter:)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.title = NSStringFromCGSize(self.image.size);
	self.iv.image = self.image;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.iv;
}

- (IBAction)actApplyFilter:(id)sender {
	NSLog(@"apply filter");

	CIContext *context = [CIContext contextWithOptions:nil];//@{kCIContextUseSoftwareRenderer : @(YES)}];
	CIImage *image = [CIImage imageWithCGImage:self.image.CGImage];
	NSString *filterID = @"CIDotScreen";
	CIFilter *filter = [CIFilter filterWithName:filterID keysAndValues:
						kCIInputImageKey, image,
						kCIInputWidthKey, @(self.filterWidthValue),
						kCIInputSharpnessKey, @(1.0f),
						nil];

	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGRect extent = [result extent];
	CGImageRef cgImage = [context createCGImage:result fromRect:extent];

	self.iv.image = [UIImage imageWithCGImage:cgImage];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStylePlain target:self action:@selector(actPrint:)];

}

#define IsIpad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsIphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

- (IBAction)actPrint:(id)sender {
	UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
	controller.delegate = self;
	controller.showsNumberOfCopies = NO;
	controller.showsPageRange = NO;
	if(!controller) {
		NSLog(@"Couldn't get shared UIPrintInteractionController!");
		return ;
	}

	// Obtain a printInfo so that we can set our printing defaults.
	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.duplex = UIPrintInfoDuplexNone;
	//	modes: UIPrintInfoOutputGrayscale UIPrintInfoOutputPhotoGrayscale UIPrintInfoOutputPhoto
	printInfo.outputType = UIPrintInfoOutputGrayscale;
	printInfo.jobName = @"Dithering";
	printInfo.orientation = UIPrintInfoOrientationPortrait;
	controller.printInfo = printInfo;

	ZPageRenderer *printPageRenderer = [ZPageRenderer new];
	controller.printPageRenderer = printPageRenderer;
	printPageRenderer.image = self.iv.image;

	if (IsIphone) {
		[controller presentAnimated:YES completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
			NSLog(@"-OK-");
		}];
	}
	else {
		[controller presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
			NSLog(@"-OK-");
		}];
	}




	return;

	//	iOS-8
	UIPrinter *printer = nil;
	[controller printToPrinter:printer completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {
		NSLog(@"-OK-");
	}];
}

#pragma  mark - UIPrintInteractionControllerDelegate

const CGFloat	paperLength = 222;

- (CGFloat)printInteractionController:(UIPrintInteractionController *)printInteractionController cutLengthForPaper:(UIPrintPaper *)paper
{
	return paperLength;
}

- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)printInteractionController choosePaper:(NSArray *)paperList
{
	for (UIPrintPaper *paper in paperList) {
		NSLog(@"pp.sz:%@; prn.rect:%@;", NSStringFromCGSize(paper.paperSize), NSStringFromCGRect(paper.printableRect));
		if (fabsf(paper.paperSize.height - paperLength) < 1) {
			return paper;
		}
	}

	UIPrintPaper *thePaper = nil;
	if (!thePaper) {
		//	pick up the max size paper
		double area = 0;
		for (UIPrintPaper *paper in paperList) {
			const double a2 = paper.paperSize.width * paper.paperSize.height;
			if (a2 > area) {
				area = a2;
				thePaper = paper;
			}
		}
	}

	return thePaper;
}



@end
