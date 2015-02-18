//
//  Paper.h
//  TestCoreImage
//
//  Created by 100500 on 13/01/15.
//  Copyright (c) 2015 Leonid 100500. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIPaperInfo.h"

@interface PIPaperInfo (extra_dbg)

@property (nonatomic, assign) CGSize		paperSize;
@property (nonatomic, assign) UIEdgeInsets	margins;
@property (nonatomic, readonly) CGRect		printableRect;
- (BOOL)isEqualToUIPrintPaper:(UIPrintPaper *)pp;

+ (PIPaperInfo *)paper88x28;
+ (PIPaperInfo *)paper39A;
+ (PIPaperInfo *)paper39B;
+ (PIPaperInfo *)paperForSimulatorLabel;
+ (PIPaperInfo *)paper88x50;
/*	19mm
 "<UIPrintPaper 0x16ef0640> [53.9x144.0]  {3.6, 3.6; 46.7x136.8}",
 "<UIPrintPaper 0x16ec2a10> [53.9x180.0]  {3.6, 3.6; 46.7x172.8}",
*/
+ (PIPaperInfo *)paper19A;
+ (PIPaperInfo *)paper19B;

- (PIPaperInfo *)copyRotated90;
- (PIPaperInfo *)copyBorderless;

- (NSString *)shortDescription;

@end
