//
//  Detail.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClickableViewDelegate;
@interface DetailHeaderView : UIView
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, assign) id <ClickableViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame title:(NSString*)titleSet delegate:(id)delegateSet;
@end

@protocol ClickableViewDelegate <NSObject>
@required
- (void) viewClicked;
@end