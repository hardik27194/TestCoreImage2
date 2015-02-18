//
//  SettingsModel.h
//  TestCoreImage
//
//  Created by 100500 on 13/01/15.
//  Copyright (c) 2015 Leonid 100500. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum BitmapFormat : NSUInteger {
	BitmapFormatJpg = 0,
	BitmapFormatPdf = 1
} BitmapFormat;

@interface SettingsModel : NSObject
@property (nonatomic, assign) BOOL			isPortrait;
@property (nonatomic, assign) CGFloat		scaleFactor;
@property (nonatomic, assign) CGFloat		continuousLength;
@property (nonatomic, assign) BitmapFormat	bitmapFormat;
+ (SettingsModel *)shared;
@end
