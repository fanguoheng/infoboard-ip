//
//  AgtTableViewCell.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AgtTableViewCell.h"

@implementation AgtTableViewCell
@synthesize nameLabel,agtidLabel,agtcallcntLabel,agtanswerrateLabel,statusLabel;
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
