//
//  FiltersListViewController.m
//  TestCoreImage
//
//  Created by 100500 on 12/19/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "FiltersListViewController.h"
#import "FiltersInCategoryVC.h"


@interface FiltersListViewController ()
@property (nonatomic, retain) NSArray	*allItems;
@end

@implementation FiltersListViewController


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}


- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Categories";
	NSArray *keys = @[kCICategoryDistortionEffect, kCICategoryGeometryAdjustment, kCICategoryCompositeOperation, kCICategoryHalftoneEffect, kCICategoryColorAdjustment, kCICategoryColorEffect, kCICategoryTransition, kCICategoryTileEffect, kCICategoryReduction, kCICategoryGradient, kCICategoryStylize, kCICategorySharpen, kCICategoryBlur, kCICategoryVideo, kCICategoryStillImage, kCICategoryInterlaced, kCICategoryNonSquarePixels, kCICategoryHighDynamicRange,kCICategoryBuiltIn];self.allItems = [keys sortedArrayUsingSelector:@selector(compare:)];
	self.title = [NSString stringWithFormat:@"Categories [%d]", (int)self.allItems.count];
	[self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"id"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
	}
	NSString *categoryID = self.allItems[indexPath.row];
	cell.textLabel.text = categoryID;
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.allItems count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *categoryID = self.allItems[indexPath.row];
	FiltersInCategoryVC *ctr = [FiltersInCategoryVC new];
	ctr.categoryID = categoryID;
	[self.navigationController pushViewController:ctr animated:YES];
}

@end
