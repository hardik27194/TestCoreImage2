//
//  FiltersInCategoryVC.m
//  TestCoreImage
//
//  Created by 100500 on 12/19/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "FiltersInCategoryVC.h"
#import "FilterConstructorVC.h"

@interface FiltersInCategoryVC ()
@property (nonatomic, retain) NSArray	*allItems;
@end

@implementation FiltersInCategoryVC

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSArray *catArray = [CIFilter filterNamesInCategory:self.categoryID];
	self.allItems = catArray;
	self.title = [NSString stringWithFormat:@"%@ [%d]", self.categoryID, (int)self.allItems.count];
	[self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"id"];
	}
	NSString *filterID = self.allItems[indexPath.row];
	cell.textLabel.text = filterID;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *filterID = self.allItems[indexPath.row];
	FilterConstructorVC *ctr = [FilterConstructorVC new];
	ctr.categoryID = self.categoryID;
	ctr.filterID = filterID;
	[self.navigationController pushViewController:ctr animated:YES];
}

@end
