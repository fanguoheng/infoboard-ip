//
//  QQSectionHeaderView.h
//  TQQTableView
//
//  Created by Futao on 11-6-22.
//  Copyright 2011 ftkey.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QQSectionHeaderViewDelegate;//此类声明它自己实现了一个协议QQSectionHeaderViewDelegate

@interface QQSectionHeaderView : UIView {

}
//@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic,retain)  UILabel *grpName;
@property (nonatomic,retain)  UILabel *login;
@property (nonatomic,retain)  UILabel *transAgt;
@property (nonatomic,retain)  UILabel *agtAnswer;
@property (nonatomic,retain)  UILabel *answerRate;
@property (nonatomic,retain)  UILabel *queueLen;
@property (nonatomic,retain)  UILabel *percentSign;

@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL opened;

@property (nonatomic, assign) id <QQSectionHeaderViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id<QQSectionHeaderViewDelegate>)delegate;

@end

@protocol QQSectionHeaderViewDelegate <NSObject> //协议QQSectionHeaderViewDelegate的实现

@optional
-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
@end
