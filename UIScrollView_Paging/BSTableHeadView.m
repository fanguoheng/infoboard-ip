//
//  BSTableHeadView.m
//  UIScrollView_Paging
//
//  Created by 国恒 范 on 11-12-22.
//  Copyright (c) 2011年 Guangzhou Sandi. All rights reserved.
//

#import "BSTableHeadView.h"

@implementation BSTableHeadView
@synthesize headLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        headLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0,320.0, 30.0)];
        [self addSubview:headLabel];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame headStr:(NSString *)str
{
    [self initWithFrame:frame];
    headLabel.text=str;
    headLabel.backgroundColor=[UIColor clearColor];
    headLabel.textColor=[UIColor whiteColor];
    headLabel.font=[UIFont boldSystemFontOfSize:18];
    self.backgroundColor=[UIColor clearColor];
    return self;
}

- (void)dealloc
{
    [headLabel release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
