//
//  UnUsualRootTableViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnUsualRootTableViewController : UITableViewController< UITableViewDataSource>

@property (nonatomic, retain) NSArray *dataDictArray;

- (id)initWithStyle:(UITableViewStyle)style dataDictArray:(NSArray*)dataDictArraySet delegate:(id<UITableViewDelegate>)delegateSet;

@end

