//
//  StatisticsController.h
//  ShentongFlexBoard
//
//  Created by crazysnow on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "SDInfoBoardUIUpdate.h"
@class ASIHTTPRequest;

@interface StatisticsController : UIViewController<UIActionSheetDelegate,CPTPieChartDataSource, CPTPieChartDelegate, CPTPlotDataSource,CPTBarPlotDelegate>
{
    CPTGraphHostingView *barChartView; //一个装一个柱状图或者饼图 
    CPTXYGraph *barChart;//xy背景图，表格
    CPTBarPlot *barPlot;//柱状
    CPTGraphHostingView *barChartViewLandscape;  
    CPTXYGraph *barChartLandscape;
    CPTBarPlot *barPlotLandscape;
    NSArray *barPlotData;
    
    CPTGraphHostingView *pieChartView;
    CPTXYGraph *pieChart;
    CPTPieChart *piePlot;//chart饼图
    CPTGraphHostingView *pieChartViewLandscape;
    CPTXYGraph *pieChartLandscape;
    CPTPieChart *piePlotLandscape;
    NSArray * answerRatePersent;
    
    NSString *agtTotalInfoWebAddr;
    NSString *agtAverageInfoWebAddr;
    NSTimer *timer;
    NSInteger refreshInterval;

	NSMutableData *agtTotalInfoResponseData;
    
	NSMutableData *agtAverageInfoResponseData;
    
    NSDictionary *agtTotalInfoJsonDictionary;

    UIColor * strokeColor;
    NSArray * blockColors;
    NSDictionary *agtAverageInfoJsonDictionary;
    
    NSInteger totalInboundNum;
    NSInteger totalOutboundNum;
    NSInteger totalBoundNum;
    
    NSInteger veryGoodNum;
    NSInteger goodNum;
    NSInteger generalNum;
    NSInteger badNum;
    NSInteger veryBadNum;
    NSInteger answerRate1Num;
    NSInteger answerRate2Num;
    NSInteger answerRate3Num;
    NSInteger answerRate4Num;
    
    float totalAgtAnswerNum;
    float totalTransAgtNum;
    
    float grpCount;
    NSInteger avrAnswerCntNum;
    NSInteger avrWaitDurNum;
    NSInteger avrSvrDurNum;
    NSInteger avrWorkDurNum;
    NSInteger lastAvrAnswerCntNum;
    NSInteger lastAvrWaitDurNum;
    NSInteger lastAvrSvrDurNum;
    NSInteger lastAvrWorkDurNum;
    
    UILabel *totalBoundLabel;
    UILabel *totalInboundLabel;
    UILabel *totalOutboundLabel;
    
    UILabel *avrAnswerCntLabel;
    UILabel *avrWaitDurLabel;
    UILabel *avrSvrDurLabel;
    UILabel *avrWorkDurLabel;
    UILabel *lastAvrAnswerCntLabel;
    UILabel *lastAvrWaitDurLabel;
    UILabel *lastAvrSvrDurLabel;
    UILabel *lastAvrWorkDurLabel;
    
    UIView *originView;
    UIView *landscapeView;
    NSInteger requestFailedCount;
}
@property (nonatomic, assign) id <SDInfoBoardUpdateUI> delegate;
@property (nonatomic,copy) NSString *agtTotalInfoCashResponseStr;
@property (nonatomic,copy) NSString *agtAverageInfoCashResponseStr;
@property (nonatomic, retain) CPTGraphHostingView *barChartView; 
@property (nonatomic, retain) CPTXYGraph *barChart;
@property (nonatomic, retain) CPTBarPlot *barPlot;
@property (nonatomic, retain) CPTGraphHostingView *barChartViewLandscape; 
@property (nonatomic, retain) CPTXYGraph *barChartLandscape;
@property (nonatomic, retain) CPTBarPlot *barPlotLandscape;
@property (nonatomic, retain) NSArray *barPlotData;

@property (nonatomic, retain) CPTGraphHostingView *pieChartView;
@property (nonatomic, retain) CPTXYGraph *pieChart;
@property (nonatomic, retain) CPTPieChart *piePlot;
@property (nonatomic, retain) CPTGraphHostingView *pieChartViewLandscape;
@property (nonatomic, retain) CPTXYGraph *pieChartLandscape;
@property (nonatomic, retain) CPTPieChart *piePlotLandscape;
@property (nonatomic, retain) NSArray * answerRatePersent;

@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;
@property (nonatomic, copy) NSString *agtTotalInfoWebAddr;
@property (nonatomic, copy) NSString *agtAverageInfoWebAddr;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) NSInteger refreshInterval;

@property (nonatomic, retain) NSDictionary *agtTotalInfoJsonDictionary;
@property (nonatomic, retain) NSDictionary *agtAverageInfoJsonDictionary;


@property (nonatomic, retain) IBOutlet UILabel *totalBoundLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalInboundLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalOutboundLabel;
@property (nonatomic, retain) IBOutlet UILabel *agtAnswerRateLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentSign;

@property (nonatomic, retain) IBOutlet UILabel *avrAnswerCntLabel;
@property (nonatomic, retain) IBOutlet UILabel *avrWaitDurLabel;
@property (nonatomic, retain) IBOutlet UILabel *avrSvrDurLabel;
@property (nonatomic, retain) IBOutlet UILabel *avrWorkDurLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastAvrAnswerCntLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastAvrWaitDurLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastAvrSvrDurLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastAvrWorkDurLabel;

@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;


@property (nonatomic, retain) UIActivityIndicatorView *loadingOrigin;
@property (nonatomic, retain) UIActivityIndicatorView *loadingLandscape;
@property (nonatomic, readwrite) BOOL ifLoading;

- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;

- (void) dataUpdateStart;
- (void) dataUpdatePause;
- (void) requestData;
//- (void) cleanAllData;

- (void)createBarChartAndPiePlotInOriginView; 
- (void)createBarChartAndPiePlotInLandscapeView;

- (void) updateOriginView:(ASIHTTPRequest *)request;
- (void) updateLandscapeView:(ASIHTTPRequest *)request;
- (void) cleanUI;

- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number;

@end
