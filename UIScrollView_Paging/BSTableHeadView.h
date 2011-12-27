//
//  BSTableHeadView.h
//  UIScrollView_Paging
//
//  Created by 国恒 范 on 11-12-22.
//  Copyright (c) 2011年 Guangzhou Sandi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSTableHeadView : UIView
@property (nonatomic, retain) UILabel *headLabel;
@property (nonatomic, copy) NSString *headStr;
- (id)initWithFrame:(CGRect)frame headStr:(NSString *)str;
@end
