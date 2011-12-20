//
//  PreferencesTableViewCell.m
//  UIScrollView_Paging
//
//  Created by Mac on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PreferencesTableViewCell.h"

@implementation PreferencesTableViewCell
@synthesize refreshIntervalLable,refreshIntervalSlider;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
