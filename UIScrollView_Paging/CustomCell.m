//
//  CustomCell.m
//  ReachDownloadShow_3
//
//  Created by crazysnow on 11-5-16.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell
@synthesize nameLabel;
@synthesize agtIDLabel;
@synthesize agtGroupsLabel;
@synthesize agtLogonGrpsLabel;
@synthesize workStatusLabel;


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
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [nameLabel release];
    [agtIDLabel release];
    [agtGroupsLabel release];
    [agtLogonGrpsLabel release];
    [workStatusLabel release];
    [super dealloc];
}

@end
