//
//  Detail.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DetailHeaderView.h"

@implementation DetailHeaderView
@synthesize titleLabel;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
        [self addSubview:titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self 
																					  action:@selector(Viewclicked:)] autorelease];
		[self addGestureRecognizer:tapGesture];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame title:(NSString*)titleSet delegate:(id)delegateSet
{
    [self initWithFrame:frame];
    titleLabel.text = titleSet;
    delegate = delegateSet;
    return self;
}

- (void)dealloc
{
    [titleLabel release];
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

- (IBAction)Viewclicked:(id)sender
{
    if ([delegate respondsToSelector:@selector(viewClicked)]) {
        [delegate viewClicked];
    }
}
@end
