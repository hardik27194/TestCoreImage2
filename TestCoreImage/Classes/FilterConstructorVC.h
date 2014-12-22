//
//  FilterConstructorVC.h
//  TestCoreImage
//
//  Created by 100500 on 12/19/14.
//  Copyright (c) 2014 Leonid 100500. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterConstructorVC : UITableViewController
@property (nonatomic, retain) NSString	*categoryID;
@property (nonatomic, retain) NSString	*filterID;
@property (nonatomic, retain) CIFilter	*theFilter;
@end
