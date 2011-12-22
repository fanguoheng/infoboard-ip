//
//  ClickableView.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickableHeaderViewDelegate;

@interface ClickableView : UIView
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) BOOL opened;

@property (nonatomic, assign) id <ClickableHeaderViewDelegate> delegate;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber opened:(BOOL)isOpened delegate:(id<ClickableHeaderViewDelegate>)delegate;
@end

@protocol ClickableHeaderViewDelegate <NSObject> 

@optional
-(void)sectionHeaderView:(ClickableView*)sectionHeaderView sectionClosed:(NSInteger)section;

-(void)sectionHeaderView:(ClickableView*)sectionHeaderView sectionOpened:(NSInteger)section;
@end