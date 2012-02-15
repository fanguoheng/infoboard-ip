//
//  BussSearchInfoController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "CorePlot-CocoaTouch.h"
#import "SDInfoBoardUIUpdate.h"
#import <UIKit/UIKit.h>

@interface BussSearchInfoController : UIViewController<UITableViewDelegate, UITableViewDataSource,CPTPlotDataSource>
{
    NSInteger refreshInterval;
    
    NSInteger ordercntNum;
    NSInteger cuscompcntNum;
    NSInteger sitcompcntNum;
    NSInteger searchcntNum;
    
    NSInteger maxSearchNum;
    NSInteger requestFailedCount;
}
@property (nonatomic, assign) id <SDInfoBoardUpdateUI> delegate;
@property (nonatomic, copy) NSString* bussinessInfoCashResponseStr;
@property (nonatomic, copy) NSString* bussSearchInfoCashResponseStr;
@property (nonatomic) NSInteger refreshInterval;
@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;
@property (nonatomic, copy) NSString *bussinessInfoWebAddr;
@property (nonatomic, copy) NSString *bussSearchInfoWebAddr;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSDictionary *cashDict_1;
@property (nonatomic, retain) NSDictionary *bussinessInfoDataDict;
@property (nonatomic, retain) NSMutableDictionary *bussSearchInfoDataDict;
@property (nonatomic, retain) NSArray *bussSearchInfoDataDictArray;


@property (nonatomic, retain) CPTGraphHostingView *barChartViewLandscape; 
@property (nonatomic, retain) CPTXYGraph *barChartLandscape;
@property (nonatomic, retain) CPTBarPlot *barPlotLandscape;
@property (retain) NSArray *barPlotData;
@property (nonatomic, retain) CPTGraphHostingView *pieChartViewLandscape;
@property (nonatomic, retain) CPTXYGraph *pieChartLandscape;
@property (nonatomic, retain) CPTPieChart *piePlotLandscape;
@property (nonatomic, retain) NSArray * answerRatePersent;

@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;
@property (nonatomic, retain) IBOutlet UITableView *tableViewPortrait;
@property (nonatomic, retain) UIActivityIndicatorView *loadingOrigin;
@property (nonatomic, retain) UIActivityIndicatorView *loadingLandscape;
@property (nonatomic, readwrite) BOOL ifLoading;

- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;
- (void)dataUpdateStart;
- (void)dataUpdatePause;
- (void)requestData;
- (void)updateOriginView:(ASIHTTPRequest *)request;
- (void)updateLandscapeView:(ASIHTTPRequest *)request;
- (void) cleanUI;

- (void)createBarChartAndPiePlotInLandscapeView;
- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number;
@end

@interface NSDictionary(myCompare)
- (NSComparisonResult)myCompareMethodWithDict: (NSDictionary*)theOtherDict;
@end


@implementation NSDictionary(myCompare)
- (NSComparisonResult)myCompareMethodWithDict: (NSDictionary*)anotherDict
{
    NSInteger firstValue = [[self objectForKey: @"value"] intValue];
    NSInteger secondValue = [[anotherDict objectForKey: @"value"] intValue];
    return firstValue < secondValue;
    
    if  (firstValue!=secondValue)
        return firstValue < secondValue;
    else
    {
        return [(NSString*)[self objectForKey:@"searchType"] compare:[anotherDict objectForKey:@"searchType"]];
    }
}
@end
