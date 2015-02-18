//
//  PaperCatalogTableVC.m
//  TestCoreImage
//
//  Created by 100500 on 13/01/15.
//  Copyright (c) 2015 Leonid 100500. All rights reserved.
//

#import "PaperCatalogTableVC.h"
#import "PIPaperInfo.h"
#import "TestSelectorVC.h"
#import "SettingsVC.h"

@interface PaperCatalogTableVC ()
@property (nonatomic, retain) NSDictionary	*paperInfoCatalog;
@property (nonatomic, retain) NSArray		*allPaperIDs;
@property (nonatomic, retain) NSArray		*allPaperContinuousIDs;
@end

@implementation PaperCatalogTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Paper Catalog";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(actSettings:)];
	[self loadPaperCatalog];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return section == 0 ? self.allPaperIDs.count : self.allPaperContinuousIDs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell-id"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell-id"];
	}
	PIPaperInfo *pi = [self paperInfoAtIndexPath:indexPath];
	cell.textLabel.text = pi.paperName;
	cell.detailTextLabel.text = [pi localizedSizeString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PIPaperInfo *pi = [self paperInfoAtIndexPath:indexPath];
	TestSelectorVC *ctr = [TestSelectorVC new];
	ctr.paper = pi;
	ctr.title = pi.paperName;
	[self.navigationController pushViewController:ctr animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return 0 == section ? @"Die Cut" : @"Continuous";
}

- (PIPaperInfo *)paperInfoAtIndexPath:(NSIndexPath *)indexPath {
	NSString *paperID = 0 == indexPath.section ? self.allPaperIDs[indexPath.row] : self.allPaperContinuousIDs[indexPath.row];
	return self.paperInfoCatalog[paperID];
}

- (void)loadPaperCatalog
{
	NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PaperCatalog" ofType:@"plist"];
	NSDictionary *paperInfoDB = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	NSDictionary *allRawPapers = paperInfoDB[@"PaperCatalog"];

	if (allRawPapers.count) {
		NSMutableDictionary *dictPaper = [NSMutableDictionary dictionaryWithCapacity:allRawPapers.count];
		for (NSString *ID in allRawPapers) {
			NSDictionary *args = allRawPapers[ID];
			PIPaperInfo *pi = [[PIPaperInfo alloc] initWithID:ID andDictionary:args];
			if (pi) {
				[pi normalizeSizesToApp];
				dictPaper[ID] = pi;
			}
			else {
				LLog(@"Cannot load paper with ID '%@'", ID);
			}
		}
		_paperInfoCatalog = dictPaper;
	}
	else {
		_paperInfoCatalog = nil;
	}

	NSArray *allDieCut = [[self.paperInfoCatalog allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *ID, NSDictionary *bindings) {
		return ![[ID lowercaseString] hasPrefix:@"continuous"];
	}]];
	self.allPaperIDs = [allDieCut sortedArrayUsingSelector:@selector(compare:)];
	NSArray *allCont = [[self.paperInfoCatalog allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *ID, NSDictionary *bindings) {
		return [[ID lowercaseString] hasPrefix:@"continuous"];
	}]];
	self.allPaperContinuousIDs = [allCont sortedArrayUsingComparator:^NSComparisonResult(NSString *ID1, NSString *ID2) {
		PIPaperInfo *pi1 = _paperInfoCatalog[ID1];
		PIPaperInfo *pi2 = _paperInfoCatalog[ID2];
		if (pi1.paperSize.width < pi2.paperSize.width) {
			return NSOrderedAscending;
		}
		else if (pi1.paperSize.width > pi2.paperSize.width) {
			return NSOrderedDescending;
		}
		return NSOrderedSame;
	}];
}

- (IBAction)actSettings:(id)sender {
	SettingsVC *ctr = [SettingsVC new];
	[self.navigationController pushViewController:ctr animated:YES];
}

@end
