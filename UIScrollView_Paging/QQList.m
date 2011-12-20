//
//  QQList.m
//  TQQTableView
//
//  Created by Futao on 11-6-21.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import "QQList.h"



@implementation QQPerson
@synthesize m_nQQNumber;
@synthesize m_nListID;
@synthesize m_bIsOnline;

//@synthesize m_strNickName;
//@synthesize m_strRemarkName;
//@synthesize m_strLongNickInfo;
//@synthesize m_strHeadImageURLString;

@synthesize nameStr;
@synthesize agtIDStr;
@synthesize agtGroupsStr;
@synthesize agtLogonGrpsStr;   

@synthesize loginStr;
@synthesize pauseStr;
@synthesize workStatusStr;
@synthesize occupyStr;

@synthesize logonTimeStr;
@synthesize stationIDStr;

- (void)dealloc
{
	//[m_strNickName release];
    //[m_strRemarkName release];
    //[m_strLongNickInfo release];
    //[m_strHeadImageURLString release];
	
    [nameStr release];
    [agtIDStr release];
    [agtGroupsStr release];
    [agtLogonGrpsStr release];   
    [workStatusStr release];
    [logonTimeStr release];
    [stationIDStr release];
    
    [super dealloc];
}
@end

@implementation QQListBase
@synthesize m_nID;
@synthesize m_strName;
@synthesize grpID;
@synthesize login;

@synthesize transAgt;
@synthesize agtAnswer;
@synthesize answerRate;
@synthesize queueLen;

@synthesize m_arrayPersons;

- (void)dealloc
{
    [m_strName release];
    [grpID release];
    
	[m_arrayPersons release];
    [super dealloc];
}
@end

@implementation QQList
@synthesize opened,indexPaths;
- (void)dealloc
{
	[indexPaths release];
    [super dealloc];
}
- (NSComparisonResult)compareListByAnswerRate:(QQList *)otherlist
{
    return (answerRate > otherlist.answerRate);
}
@end

