//
//  UIScrollView_PagingViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDInfoBoardUIUpdate.h"
#define kViewGap 20.0f


@interface UIScrollView_PagingViewController : UIViewController<UIScrollViewDelegate,UIPickerViewDataSource,SDInfoBoardUpdateUI>{
    bool allowRotationLanscape;
    
    UIView *welcomeView;
    UIView *settingView;
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    NSArray *viewBoardControllers;
    
    NSInteger viewBoardControllersCount;//此值应保持于viewBoardControllers的元素个数相等
    
}

@property (nonatomic, retain) IBOutlet UIView *welcomeView;
@property (nonatomic, retain) IBOutlet UIView *settingView;
@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (nonatomic, retain) IBOutlet UIButton* showAllViewBoardsAndSettingButton;
@property (nonatomic, retain) IBOutlet UILabel* pageRefreshTimeLabel;
@property (nonatomic, retain) NSArray *viewBoardControllers;
@property (nonatomic, retain) NSMutableArray *viewBoardFrontViews;

@property (nonatomic, retain) IBOutlet UILabel* hostAddrTextField;
@property (nonatomic, retain) IBOutlet UILabel* hostReachResultLabel;
@property (nonatomic, copy) NSString* hostAddr;
@property (nonatomic, copy) NSString* addrPrefix;
@property (nonatomic, copy) NSString* addrPostfix;

@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableDictionary *provincesShops;
@property (nonatomic, retain) NSMutableArray *provinces;
@property (nonatomic, retain) NSMutableArray *shops;
@property (nonatomic, retain) IBOutlet UIImageView *allViewsPicView;

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) NSArray *navBarTitles;
@property (nonatomic, retain) NSMutableArray *updateTimeStrArray;
- (void)startTimersPaged;
- (IBAction)showAllViewBoards:(id)sender;
- (void)jumpToCurrentPage;


- (void) loadAllViewBoardsWithAddrPrefix:(NSString*)addrPrefix AddrPostfix:(NSString*)AddrPostfix;

- (IBAction)textFieldEditing:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)requestAllShopsFromHostAddr:(id)sender;
- (void )didFinishAllShopsRequest:(ASIHTTPRequest*)request;
- (void )didFailAllShopsRequest:(ASIHTTPRequest*)request;
- (IBAction)shopsSelectionConfirm:(id)sender;
- (IBAction)backOrForward:(id)sender;

@end

