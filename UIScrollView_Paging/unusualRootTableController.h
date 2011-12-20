//
//  unusualRootTableController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface unusualRootTableController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSDictionary *dataDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataDict:(NSDictionary*)dataDictSet;
@end
