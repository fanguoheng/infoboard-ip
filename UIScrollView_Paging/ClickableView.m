//
//  ClickableView.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ClickableView.h"

@implementation ClickableView
@synthesize titleLabel, disclosureButton, delegate, section , opened;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id)aDelegate{
    if (self = [super initWithFrame:frame]) {
		
		UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self 
																					  action:@selector(toggleAction:)] autorelease];
		[self addGestureRecognizer:tapGesture];
		self.userInteractionEnabled = YES;
		section = sectionNumber;
		delegate = aDelegate;
		opened = isOpened;
		CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 35.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.text = title;
        titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
		
		
		disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(0.0, 0.0, 35.0, 35.0);
		[disclosureButton setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
		[disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
		disclosureButton.userInteractionEnabled = NO;
		disclosureButton.selected = isOpened;
        [self addSubview:disclosureButton];
		
		self.backgroundColor = [UIColor blueColor];
	}
	return self;
}

-(IBAction)toggleAction:(id)sender {
	
	disclosureButton.selected = !disclosureButton.selected;
	
	if (disclosureButton.selected) {
        //if (!disclosureButton.selected) {
		if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
			[delegate sectionHeaderView:self sectionOpened:section];
		}
	}
	else {
		if ([delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
			[delegate sectionHeaderView:self sectionClosed:section];
		}
	}
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
	[titleLabel release];
    [disclosureButton release];
    [super dealloc];
}


@end
