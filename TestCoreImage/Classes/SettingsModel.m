//
//  SettingsModel.m
//  TestCoreImage
//
//  Created by 100500 on 13/01/15.
//  Copyright (c) 2015 Leonid 100500. All rights reserved.
//

#import "SettingsModel.h"

@implementation SettingsModel

static SettingsModel *sharedSettingsModel = nil;

+ (SettingsModel *)shared {
	if (!sharedSettingsModel) {
		sharedSettingsModel = [self new];
		[sharedSettingsModel setup];
	}
	return sharedSettingsModel;
}

- (void)setup {
	self.isPortrait = YES;
	self.scaleFactor = 1;
	self.bitmapFormat = BitmapFormatJpg;
	self.continuousLength = 100;
}

@end
