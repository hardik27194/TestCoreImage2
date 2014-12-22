//
//  ViewController.m
//  TestCoreImage
//
//  Created by 100500 on 12/19/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "ViewController.h"
#import "MyImageView.h"
#import "FiltersListViewController.h"

@interface ViewController ()
<UIScrollViewDelegate>
@property (nonatomic, retain) IBOutlet	MyImageView		*resultImgView;
@property (nonatomic, retain) IBOutlet	UIScrollView	*scrollView;
@property (nonatomic, retain) IBOutlet	UISlider		*sliderWidth;
@property (nonatomic, retain) IBOutlet	UISlider		*sliderSharp;
@property (nonatomic, retain) IBOutlet	UILabel			*labWidth;
@property (nonatomic, retain) IBOutlet	UILabel			*labSharp;
@end


@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setDefaultImage];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return self.resultImgView;
}

- (void)setDefaultImage {
	UIImage *img = [UIImage imageNamed:@"2.jpg"];
	self.resultImgView.CGImage = img.CGImage;
	self.scrollView.zoomScale = 1;
}


- (IBAction)actShowSrcImage:(id)sender {
	[self setDefaultImage];
}

- (IBAction)actTest1:(id)sender {
	NSLog(@"1");

	CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"];
	NSURL *myURL = [NSURL fileURLWithPath:path];
	CIImage *image = [CIImage imageWithContentsOfURL:myURL];
	CIFilter *filter = [CIFilter filterWithName:@"CIDotScreen" keysAndValues:
						kCIInputImageKey, image,
						kCIInputWidthKey, @(6.0f),
						kCIInputSharpnessKey, @(1.0f),
						nil];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGRect extent = [result extent];
	CGImageRef cgImage = [context createCGImage:result fromRect:extent];

	self.resultImgView.CGImage = cgImage;
}


- (IBAction)actShowFilters:(id)sender {
	FiltersListViewController *listVC = [FiltersListViewController new];
	[self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)actApplyFilter:(id)sender {
	NSLog(@"apply filter");

	CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"];
	NSURL *myURL = [NSURL fileURLWithPath:path];
	CIImage *image = [CIImage imageWithContentsOfURL:myURL];
	NSString *filterID = @"CICircularScreen";///*@"CIDotScreen"*/ @"CIHatchedScreen"
	CIFilter *filter = [CIFilter filterWithName:filterID];
	[filter setValue:image forKey:kCIInputImageKey];
	CGFloat v1[] = {250, 150};
	[filter setValue:[CIVector vectorWithValues:v1 count:2] forKey:@"inputCenter"];
	[filter setValue:@(self.sliderWidth.value) forKey:@"inputWidth"];
//	[filter setValue:@(0.0) forKey:@"inputAngle"];
	[filter setValue:@(self.sliderSharp.value) forKey:@"inputSharpness"];

	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGRect extent = [result extent];
	CGImageRef cgImage = [context createCGImage:result fromRect:extent];

	self.resultImgView.CGImage = cgImage;
}

- (IBAction)actSlideWidth:(UISlider *)sender {
	self.labWidth.text = [NSString stringWithFormat:@"Width %2.2f", sender.value];
}

- (IBAction)actSlideSharp:(UISlider *)sender {
	self.labSharp.text = [NSString stringWithFormat:@"Sharpness %2.2f", sender.value];
}



@end
