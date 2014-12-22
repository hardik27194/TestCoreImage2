//
//  FilterConstructorVC.m
//  TestCoreImage
//
//  Created by 100500 on 12/19/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import "FilterConstructorVC.h"

@interface FilterConstructorVC ()
@end

@implementation FilterConstructorVC

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	self.theFilter = [CIFilter filterWithName:self.filterID];
	self.title = [self.theFilter name];
}

#pragma mark - Table view data source

typedef NS_OPTIONS(NSUInteger, FilterSection) {
    FilterSectionHeader,
	FilterSectionPropertiesIn,
    FilterSectionPropertiesOut,
    FilterSectionCOUNT
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return FilterSectionCOUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
  case FilterSectionHeader:				return 2;
  case FilterSectionPropertiesIn:		return self.theFilter.inputKeys.count;
  case FilterSectionPropertiesOut:		return self.theFilter.outputKeys.count;
  default:	break;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	switch (indexPath.section) {
  case FilterSectionHeader: {
	  NSString *cellID = @"headID";
	  cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	  if (!cell) {
		  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
	  }
	  switch (indexPath.row) {
		  case 0:
			  cell.textLabel.text = self.categoryID;
			  break;

		  case 1:
			  cell.detailTextLabel.text = self.filterID;
			  cell.textLabel.text = self.theFilter.attributes[kCIAttributeFilterDisplayName];
			  break;
	  }
	  break;
  }

  case FilterSectionPropertiesIn: {
	  NSString *cellID = @"propID-in";
	  cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	  if (!cell) {
		  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
	  }
	  NSString *key = self.theFilter.inputKeys[indexPath.row];
	  cell.textLabel.text = key;
	  cell.detailTextLabel.text = [self descriptionForAttributeID:key];
	  break;
  }

  case FilterSectionPropertiesOut: {
	  NSString *cellID = @"propID-out";
	  cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	  if (!cell) {
		  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
	  }
	  NSString *key = self.theFilter.outputKeys[indexPath.row];
	  cell.textLabel.text = key;
	  cell.detailTextLabel.text = [self descriptionForAttributeID:key];
	  break;
  }

  default:	break;
	}

	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
  case FilterSectionHeader:				return @"Filter";
  case FilterSectionPropertiesIn:		return @"Input keys";
  case FilterSectionPropertiesOut:		return @"Output keys";
  default:	break;
	}
	return 0;
}

- (NSString *)descriptionForAttributeID:(NSString *)attributeID {
	NSDictionary *attributes = self.theFilter.attributes;
	NSDictionary *attrib = attributes[attributeID];
	NSString *attrClass = attrib[kCIAttributeClass];
	NSString *attrType = attrib[kCIAttributeType];
	return attrib.count ? [NSString stringWithFormat:@"%@/%@[%d]", attrClass, attrType, (int)attrib.count] : @"";
}

@end
