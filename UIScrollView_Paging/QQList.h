//
//  QQList.h
//  TQQTableView
//
//  Created by Futao on 11-6-21.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface QQPerson : NSObject {
	int m_nQQNumber; 
	int m_nListID;
	BOOL m_bIsOnline;
	//NSString *m_strRemarkName;
	//NSString *m_strNickName;
	//NSString *m_strLongNickInfo;
	//NSString *m_strHeadImageURLString;
	 
	//NSString *xxxx;
    NSString *nameStr;
    NSString *agtIDStr;
    NSString *agtGroupsStr;
    NSString *agtLogonGrpsStr;   

    NSString *loginStr;
    NSString *pauseStr;
    NSString *workStatusStr;
    NSString *occupyStr;
    
    NSString *logonTimeStr;
    NSString *stationIDStr;
}
@property (nonatomic, assign) int m_nQQNumber;
@property (nonatomic, assign) int m_nListID;
@property (nonatomic, assign, getter=isOnline) BOOL m_bIsOnline;

//@property (nonatomic, retain) NSString *m_strRemarkName;
//@property (nonatomic, retain) NSString *m_strNickName;
//@property (nonatomic, retain) NSString *m_strLongNickInfo;
//@property (nonatomic, retain) NSString *m_strHeadImageURLString;

@property (nonatomic, retain) NSString *nameStr;
@property (nonatomic, retain) NSString *agtIDStr;
@property (nonatomic, retain) NSString *agtGroupsStr;
@property (nonatomic, retain) NSString *agtLogonGrpsStr;   

@property (nonatomic, retain) NSString *loginStr;
@property (nonatomic, retain) NSString *pauseStr;
@property (nonatomic, retain) NSString *workStatusStr;
@property (nonatomic, retain) NSString *occupyStr;

@property (nonatomic, retain) NSString *logonTimeStr;
@property (nonatomic, retain) NSString *stationIDStr;
@end

@interface QQListBase : NSObject {
	int m_nID;
	NSString *m_strName;
    NSString *grpID;
    NSInteger login;
    
    NSInteger transAgt;
    NSInteger agtAnswer;
    float answerRate;
    NSInteger queueLen;
    
	NSMutableArray * m_arrayPersons;
}
@property (nonatomic, assign) int m_nID;
@property (copy) NSString *m_strName;
@property (copy) NSString *grpID;
@property  NSInteger login;

@property NSInteger transAgt;
@property NSInteger agtAnswer;
@property float answerRate;
@property NSInteger queueLen;

@property (nonatomic, retain) NSMutableArray *m_arrayPersons;
@end


@interface QQList : QQListBase {
	BOOL opened;
	NSMutableArray *indexPaths;
}
@property (assign) BOOL opened; // 是否为展开
@property (nonatomic,retain) NSMutableArray *indexPaths; // 临时保存indexpaths

- (NSComparisonResult)compareListByAnswerRate:(QQList *)otherlist;


@end