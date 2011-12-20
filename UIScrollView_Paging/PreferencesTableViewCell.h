//
//  PreferencesTableViewCell.h
//  UIScrollView_Paging
//
//  Created by Mac on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferencesTableViewCell : UITableViewCell
{
    UILabel *refreshIntervalLable;
    UISlider *refreshIntervalSlider;
}

@property (nonatomic,retain)IBOutlet UILabel *refreshIntervalLable;
@property (nonatomic,retain)IBOutlet UISlider *refreshIntervalSlider;
@end
