//
//  RealtimeMonitorController.h
//  ShentongFlexBoard
//
//  Created by crazysnow on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "SDInfoBoardUIUpdate.h"
@class ASIHTTPRequest;

@interface RealtimeMonitorController : UIViewController<UIActionSheetDelegate, CPTPlotDataSource>//,CPTAxisDelegate>
{

    NSString *webAddr;
    
    NSInteger totalInboundNum;
    NSInteger totalOutboundNum;
    NSInteger totalBoundNum;
    float totalAgtAnswerNum;
    float totalTransAgtNum;
    NSInteger totalIVRNum;
    NSInteger loninAgtNum;

    NSInteger inboundNum;
    NSInteger outboundNum;
    NSInteger queueNum;
    NSInteger ringAgtNum;
    NSInteger pauseAgtNum;
    NSInteger idleAgtNum;
    NSInteger talkingAgtNum;
    NSInteger occupyAgtNum;
    
    NSInteger refreshInterval;
    NSTimer *timer;
    
    CPTGraphHostingView *barChartView;   
    CPTXYGraph *barChart;
    CPTBarPlot *barPlot;    
    
    CPTGraphHostingView *barChartViewLandscape;   
    CPTXYGraph *barChartLandscape;
    CPTBarPlot *barPlotLandscape;
    
    NSArray *barPlotData;
    NSDictionary *dataDictionary;
    
    UILabel *totalBoundLabel;
    UILabel *totalInboundLabel;
    UILabel *totalOutboundLabel;
    UILabel *totalTransAgtLabel;
    UILabel *totalAgtAnswerLabel;
    UILabel *agtAnswerRateLabel;
    UILabel *totalIVRLabel;
    UILabel *loninAgtLabel;
    
    UILabel *inboundLabel;
    UILabel *outBoundLabel;
    UILabel *queueLabel;
    
    UIView *originView;
    UIView *landscapeView;
    
    NSMutableArray *customLabels;
    NSInteger requestFailedCount;
}
@property (nonatomic, assign) id <SDInfoBoardUpdateUI> delegate;
@property (nonatomic, copy) NSString* cashResponseStr;
@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;
@property (nonatomic, copy) NSString *webAddr;

@property (nonatomic, retain) CPTGraphHostingView *barChartView;   
@property (nonatomic, retain) CPTXYGraph *barChart;
@property (nonatomic, retain) CPTBarPlot *barPlot;    
@property (nonatomic, retain) CPTGraphHostingView *barChartViewLandscape;   
@property (nonatomic, retain) CPTXYGraph *barChartLandscape;
@property (nonatomic, retain) CPTBarPlot *barPlotLandscape;
@property (retain) NSArray *barPlotData;
@property (nonatomic, retain) NSMutableArray *customLabels;

@property (nonatomic) NSInteger refreshInterval;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSDictionary *dataDictionary;


@property (nonatomic, retain) IBOutlet UILabel *totalBoundLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalInboundLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalOutboundLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalTransAgtLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalAgtAnswerLabel;
@property (nonatomic, retain) IBOutlet UILabel *agtAnswerRateLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentSignLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalIVRLabel;
@property (nonatomic, retain) IBOutlet UILabel *loninAgtLabel;
@property (nonatomic, retain) IBOutlet UILabel *inboundLabel;
@property (nonatomic, retain) IBOutlet UILabel *outboundLabel;
@property (nonatomic, retain) IBOutlet UILabel *queueLabel;
@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;

@property (nonatomic, retain) UIActivityIndicatorView *loadingOrigin;
@property (nonatomic, retain) UIActivityIndicatorView *loadingLandscape;
@property (nonatomic, readwrite) BOOL ifLoading;

- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;

- (void) dataUpdateStart;
- (void) dataUpdatePause;
- (void) requestData;
- (void) updateOriginView:(ASIHTTPRequest *)request;
- (void) updateLandscapeView:(ASIHTTPRequest *)request;
- (void) cleanUI;

- (void)createBarChartInOriginView;
- (void)createBarChartInLandscapeView;
- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number;

@end
