//
//  CustomCellPortrait.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-9-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CustomCellPortrait.h"


@implementation CustomCellPortrait
@synthesize grpName, transAgt,agtAnswer,answerRate,groupIcon,percentSign;

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
    [grpName release];
    [login release];
    [transAgt release];
    [agtAnswer release];
    [answerRate release];
    [queueLen release];
    [groupIcon release];
    [percentSign release];
    [super dealloc];
}

@end
