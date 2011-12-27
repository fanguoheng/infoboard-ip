//
//  AgtTableViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgtTableViewController : UITableViewController
@property (nonatomic,retain) NSArray *dataDictArray;
@property (nonatomic,retain) NSArray *statusArray;
- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number;
@end
