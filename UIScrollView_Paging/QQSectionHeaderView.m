//
//  QQSectionHeaderView.m
//  TQQTableView
//
//  Created by Futao on 11-6-22.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import "QQSectionHeaderView.h"


@implementation QQSectionHeaderView
@synthesize disclosureButton, delegate, section , opened;
@synthesize grpName, login,transAgt,agtAnswer,answerRate,queueLen,percentSign;


-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id)aDelegate{
    if (self = [super initWithFrame:frame]) {
		
		UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self 
																					  action:@selector(toggleAction:)] autorelease];
		[self addGestureRecognizer:tapGesture];
		self.userInteractionEnabled = YES;
		section = sectionNumber;
		delegate = aDelegate;
		opened = isOpened;
        
        disclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        disclosureButton.frame = CGRectMake(0.0, 0.0, 34.0, 34.0);
		[disclosureButton setImage:[UIImage imageNamed:@"carat.png"] forState:UIControlStateNormal];
		[disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
		disclosureButton.userInteractionEnabled = NO;
		disclosureButton.selected = isOpened;
        [self addSubview:disclosureButton];
        
        grpName = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, 7.0f, 100.0f, 20.0f)];
        grpName.text = title;
        grpName.font = [UIFont boldSystemFontOfSize:18.0];
        grpName.backgroundColor = [UIColor clearColor];
        [self addSubview:grpName];
        
        login = [[UILabel alloc] initWithFrame:CGRectMake(140.0f, 7.0f, 50.0f, 20.0f)];
        login.font = [UIFont boldSystemFontOfSize:16.0];
        login.textColor = [UIColor whiteColor];
        login.backgroundColor = [UIColor clearColor];
        login.textAlignment = UITextAlignmentRight;
        [self addSubview:login];
        
        queueLen = [[UILabel alloc] initWithFrame:CGRectMake(195.0f, 7.0f, 50.0f, 20.0f)];
        queueLen.font = [UIFont boldSystemFontOfSize:16.0];
        queueLen.textColor = [UIColor lightGrayColor];
        queueLen.backgroundColor = [UIColor clearColor];
        queueLen.textAlignment = UITextAlignmentRight;
        [self addSubview:queueLen];
        
        transAgt = [[UILabel alloc] initWithFrame:CGRectMake(250.0f, 7.0f, 70.0f, 20.0f)];
        transAgt.font = [UIFont boldSystemFontOfSize:16.0];
        transAgt.textColor = [UIColor lightGrayColor];
        transAgt.backgroundColor = [UIColor clearColor];
        transAgt.textAlignment = UITextAlignmentRight;
        [self addSubview:transAgt];
        
        agtAnswer = [[UILabel alloc] initWithFrame:CGRectMake(325.0f, 7.0f, 70.0f, 20.0f)];
        agtAnswer.font = [UIFont boldSystemFontOfSize:16.0];
        agtAnswer.textColor = [UIColor lightGrayColor];
        agtAnswer.backgroundColor = [UIColor clearColor];
        agtAnswer.textAlignment = UITextAlignmentRight;
        [self addSubview:agtAnswer];
        
        answerRate = [[UILabel alloc] initWithFrame:CGRectMake(400.0f, 7.0f, 50.0f, 20.0f)];
        answerRate.font = [UIFont boldSystemFontOfSize:16.0];
        answerRate.backgroundColor = [UIColor clearColor];
        answerRate.textAlignment = UITextAlignmentRight;
        [self addSubview:answerRate];
        
        percentSign = [[UILabel alloc] initWithFrame:CGRectMake(455.0f, 7.0f, 20.0f, 20.0f)];
        percentSign.text = [NSString stringWithString:@"%"];
        percentSign.font = [UIFont boldSystemFontOfSize:16.0];
        percentSign.backgroundColor = [UIColor clearColor];
        [self addSubview:percentSign];
		
		//self.backgroundColor = [UIColor brownColor];
        //self.backgroundColor = [UIColor colorWithRed:0.20f green:0.27f blue:0.43f alpha:1.0f];
        self.backgroundColor = [UIColor colorWithRed:0.18f green:0.243f blue:0.387f alpha:1.0f];

	}
	return self;
}

-(IBAction)toggleAction:(id)sender {
	
	disclosureButton.selected = !disclosureButton.selected;
	
	if (disclosureButton.selected) {
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
	//[titleLabel release];
    [grpName release];
    [login release];
    [transAgt release];
    [agtAnswer release];
    [answerRate release];
    [queueLen release];
    [percentSign release];
    [disclosureButton release];
    [super dealloc];
}


@end
