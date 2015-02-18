//
//  SettingsVC.m
//  TestCoreImage
//
//  Created by 100500 on 13/01/15.
//  Copyright (c) 2015 Leonid 100500. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()
@property (nonatomic, retain) IBOutlet UISegmentedControl	*segmBitmapMode;
@property (nonatomic, retain) IBOutlet UISegmentedControl	*segmOrientation;
@property (nonatomic, retain) IBOutlet UISegmentedControl	*segmScale;
@property (nonatomic, retain) IBOutlet UISegmentedControl	*segmContLeng;
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Settings";
	self.settingsModel = [SettingsModel shared];

	self.segmBitmapMode.selectedSegmentIndex = self.settingsModel.bitmapFormat;
	self.segmOrientation.selectedSegmentIndex = self.settingsModel.isPortrait ? 0 : 1;
	self.segmScale.selectedSegmentIndex = fabsf(self.settingsModel.scaleFactor - 1.0) < 0.1 ? 0 : 1;
	self.segmContLeng.selectedSegmentIndex = self.settingsModel.continuousLength > 100 ? 1 : 0;
}


- (IBAction)actChangeBitmapMode:(id)sender {
	self.settingsModel.bitmapFormat = self.segmBitmapMode.selectedSegmentIndex;
}

- (IBAction)actChangeOrientation:(id)sender {
	self.settingsModel.isPortrait = self.segmOrientation.selectedSegmentIndex == 0 ? 1 : 0;
}

- (IBAction)actChangeScale:(id)sender {
	self.settingsModel.scaleFactor = self.segmScale.selectedSegmentIndex == 0 ? 1 : 4.16666667;
}

- (IBAction)actChangeContinuousLeng:(id)sender {
	self.settingsModel.continuousLength = self.segmContLeng.selectedSegmentIndex == 0 ? 100 : 200;
}


@end
