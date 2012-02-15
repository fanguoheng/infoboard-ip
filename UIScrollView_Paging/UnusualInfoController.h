//
//  UnusualInfoController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "CorePlot-CocoaTouch.h"
#import "SDInfoBoardUIUpdate.h"
#import "BSTableHeadView.h"
#import <UIKit/UIKit.h>
@class UnUsualRootTableViewController;
@class UnUsualLeafTableViewController;
@interface UnusualInfoController : UIViewController<UITableViewDelegate,UINavigationControllerDelegate,CPTPlotDataSource>
{
    NSInteger refreshInterval;
    UINavigationController *navController;
    
    bool firstLoad;
    
    NSInteger veryBadNum;
    NSInteger badNum;
    NSInteger lostCntNum;
    NSInteger agtCntNum;
    NSInteger agtLostNum;
    NSInteger cusLostNum;
    NSInteger sysLostNum;
    NSInteger offLostNum;
    NSInteger othLostNum;
    
    NSInteger waitDurSecondNum;
    NSInteger requestFailedCount;
}
@property (nonatomic, assign) id <SDInfoBoardUpdateUI> delegate;
@property (nonatomic,retain) UINavigationController *navController;
@property (nonatomic,retain) UnUsualRootTableViewController *rootTableViewController;
@property (nonatomic,retain) UnUsualLeafTableViewController *leafTableViewController;

@property (nonatomic) NSInteger refreshInterval;
@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;
@property (nonatomic, copy) NSString *rootWebAddr;
@property (nonatomic, copy) NSString *leafVeryBadAndBadWebAddr;
@property (nonatomic, copy) NSString *leafAgtLostWebAddr;
@property (nonatomic, copy) NSString *webAddr;

@property (nonatomic, copy) NSString* rootCashResponseStr;
@property (nonatomic, copy) NSString* leafVeryBadAndBadCashResponseStr;
@property (nonatomic, copy) NSString* leafAgtLostCashResponseStr;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSArray *dataDictArray;

@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;


@property (nonatomic, retain) CPTGraphHostingView *barChartViewLandscape; 
@property (nonatomic, retain) CPTXYGraph *barChartLandscape;
@property (nonatomic, retain) CPTBarPlot *barPlotLandscape;
@property (retain) NSArray *barPlotData;

@property (nonatomic, retain) UIActivityIndicatorView *loadingOrigin;
@property (nonatomic, retain) UIActivityIndicatorView *loadingLandscape;
@property (nonatomic, readwrite) BOOL ifLoading;

- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefix AddrPostfix:(NSString*)addrPostfix;
- (void)dataUpdateStart;
- (void)dataUpdatePause;
- (void)requestData;
- (void)updateOriginView:(ASIHTTPRequest*)request;
- (void)updateLandscapeView:(ASIHTTPRequest*)request;
- (void) cleanUI;

- (void)createBarChartInLandscapeView;
@end
