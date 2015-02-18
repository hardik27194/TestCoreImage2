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
@property (nonatomic, retain) IBOutlet	UIImageView		*imageVieew;
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

	[self.resultImgView removeFromSuperview];
	self.resultImgView = nil;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//	return self.resultImgView;

	return self.imageVieew;
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

	CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"team1" ofType:@"JPG"];
	NSURL *myURL = [NSURL fileURLWithPath:path];
	CIImage *image = [CIImage imageWithContentsOfURL:myURL];
	CIFilter *filter = [CIFilter filterWithName:@"CIDotScreen" keysAndValues:
						kCIInputImageKey, image,
						kCIInputWidthKey, @(6.0f),
						kCIInputSharpnessKey, @(1.0f),
						kCIInputAngleKey, @(0.2),
						nil];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGRect extent = [result extent];
	CGImageRef cgImage = [context createCGImage:result fromRect:extent];

	self.resultImgView.CGImage = cgImage;

	self.imageVieew.image = [UIImage imageWithCGImage:cgImage];

	CGImageRelease(cgImage), cgImage = NULL;
}


- (IBAction)actShowFilters:(id)sender {
	FiltersListViewController *listVC = [FiltersListViewController new];
	[self.navigationController pushViewController:listVC animated:YES];
}

- (IBAction)actApplyFilter:(id)sender {
	NSLog(@"apply filter");

	CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"team1" ofType:@"JPG"];
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
