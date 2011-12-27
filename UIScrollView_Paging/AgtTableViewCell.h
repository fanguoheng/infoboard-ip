//
//  AgtTableViewCell.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgtTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel* nameLabel;
@property (nonatomic, retain) IBOutlet UILabel* agtidLabel;
@property (nonatomic, retain) IBOutlet UILabel* agtcallcntLabel;
@property (nonatomic, retain) IBOutlet UILabel* agtanswerrateLabel;
@property (nonatomic, retain) IBOutlet UILabel* statusLabel;
@end
