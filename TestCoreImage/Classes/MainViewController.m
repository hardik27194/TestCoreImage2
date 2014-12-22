//
//  MainViewController.m
//  TestCoreImage
//
//  Created by 100500 on 12/20/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "MainViewController.h"
#import "TestFilterRenderVC.h"
#import "ZPatternViewController.h"

@interface MainViewController ()
@property (nonatomic,retain) NSArray *allItems;
@property (nonatomic, retain) UISlider	*sliderFilterWidth;
@property (nonatomic, retain) UITableViewCell	*cellFilterWidth;
@property (nonatomic, assign) CGFloat	filterWidthValue;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.allItems = @[@"team1.JPG", @"team2.JPG", @"team3.JPG"];
	self.title = @"select an image";
	self.filterWidthValue = 5;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:	return self.allItems.count;
		default:	break;
	}
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
			if (!cell) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
			}
			cell.imageView.image = [UIImage imageNamed:@"icon@2x.png"];
			UIImage *imgBig = [UIImage imageNamed:self.allItems[indexPath.row]];
			cell.textLabel.text = NSStringFromCGSize(imgBig.size);
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			return cell;
		}

		case 1: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"slider.width"];
			if (!cell) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"slider.width"];
				if (!self.sliderFilterWidth) {
					cell.frame = CGRectMake(0, 0, 320, 44);
					self.sliderFilterWidth = [[UISlider alloc] initWithFrame:cell.contentView.bounds];
					[cell addSubview:self.sliderFilterWidth];
					self.sliderFilterWidth.minimumValue = 0;
					self.sliderFilterWidth.maximumValue = 10;
					[self.sliderFilterWidth addTarget:self action:@selector(actFilterWidthChanged:) forControlEvents:UIControlEventValueChanged];
					self.cellFilterWidth = cell;
				}
				self.sliderFilterWidth.value = self.filterWidthValue;
				cell.textLabel.text = [NSString stringWithFormat:@"Filter Width %2.2f", self.sliderFilterWidth.value];
				cell.detailTextLabel.text = @"adjust filter wdith value";
			}
			return cell;
		}

		case 2: {
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gradient"];
			if (!cell) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"gradient"];
			}
			cell.textLabel.text = @"gradient";
			return cell;
		}
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			UIImage *imgBig = [UIImage imageNamed:self.allItems[indexPath.row]];
			TestFilterRenderVC *ctr = [TestFilterRenderVC new];
			ctr.image = imgBig;
			ctr.filterWidthValue = self.filterWidthValue;
			[self.navigationController pushViewController:ctr animated:YES];
			break;
		}

		case 2: {
			ZPatternViewController *ctr = [ZPatternViewController new];
			[self.navigationController pushViewController:ctr animated:YES];
			break;
		}

		default:	break;
	}
}

- (IBAction)actFilterWidthChanged:(UISlider *)sender {
	self.filterWidthValue = self.sliderFilterWidth.value;
	self.cellFilterWidth.textLabel.text = [NSString stringWithFormat:@"Filter Width %2.2f", self.sliderFilterWidth.value];
}

@end
