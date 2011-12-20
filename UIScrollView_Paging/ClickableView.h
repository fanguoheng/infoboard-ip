//
//  ClickableView.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickableHeaderViewDelegate;//此类声明它自己实现了一个协议QQSectionHeaderViewDelegate。注意它塞一个视图类，而且包含一个遵守此协议的delegate成员

@interface ClickableView : UIView
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL opened;

@property (nonatomic, assign) id <ClickableHeaderViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id<ClickableHeaderViewDelegate>)delegate;
@end

@protocol ClickableHeaderViewDelegate <NSObject> //协议QQSectionHeaderViewDelegate的实现

@optional
-(void)sectionHeaderView:(ClickableView*)sectionHeaderView sectionClosed:(NSInteger)section;

-(void)sectionHeaderView:(ClickableView*)sectionHeaderView sectionOpened:(NSInteger)section;
@end