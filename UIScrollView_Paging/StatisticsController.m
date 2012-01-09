//
//  StatisticsController.m
//  ShentongFlexBoard
//
//  Created by crazysnow on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
#import "StatisticsController.h"



@implementation StatisticsController

@synthesize barChartView;
@synthesize barChart;
@synthesize barPlot;
@synthesize barChartViewLandscape;
@synthesize barChartLandscape;
@synthesize barPlotLandscape;
@synthesize barPlotData;

@synthesize pieChartView;
@synthesize pieChart;
@synthesize piePlot;
@synthesize pieChartViewLandscape;
@synthesize pieChartLandscape;
@synthesize piePlotLandscape;
@synthesize answerRatePersent,percentSign;

@synthesize addrPrefix;
@synthesize addrPostfix;
@synthesize agtTotalInfoWebAddr;
@synthesize agtAverageInfoWebAddr;
@synthesize timer,refreshInterval;

@synthesize agtTotalInfoJsonDictionary;
@synthesize agtAverageInfoJsonDictionary;


@synthesize totalBoundLabel;
@synthesize totalInboundLabel;
@synthesize totalOutboundLabel;
@synthesize agtAnswerRateLabel;

@synthesize avrAnswerCntLabel;
@synthesize avrWaitDurLabel;
@synthesize avrSvrDurLabel;
@synthesize avrWorkDurLabel;
@synthesize lastAvrAnswerCntLabel;
@synthesize lastAvrWaitDurLabel;
@synthesize lastAvrSvrDurLabel;
@synthesize lastAvrWorkDurLabel;

@synthesize originView;
@synthesize landscapeView;

@synthesize delegate,agtTotalInfoCashResponseStr,agtAverageInfoCashResponseStr;

@synthesize loadingOrigin,loadingLandscape;
@synthesize ifLoading;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization   
        agtTotalInfoCashResponseStr = [[NSString alloc]init ];
        agtAverageInfoCashResponseStr = [[NSString alloc]init ];
    }
    return self;
}

- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    
    //self.agtTotalInfoWebAddr =  [[NSString alloc ]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/AgtTotalInfo.json"];
    //self.agtAverageInfoWebAddr = [[NSString alloc ]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/AgtAverageInfo.json"];
    self.addrPrefix = addrPrefixSet;
    self.addrPostfix = addrPostfixSet;
    NSString *addr1 = [[NSString alloc ]initWithFormat:@"%@AgttotalInfo%@",addrPrefix,addrPostfix];
    self.agtTotalInfoWebAddr = addr1;
    [addr1 release];
    //NSLog(@"%@",agtTotalInfoWebAddr);
    NSString *addr2 = [[NSString alloc ]initWithFormat:@"%@AgtAverageInfo%@",addrPrefix,addrPostfix];
    self.agtAverageInfoWebAddr = addr2;
    [addr2 release];
    //NSLog(@"%@",agtAverageInfoWebAddr);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setAddrWithAddrPrefix:addrPrefixSet AddrPostfix:addrPostfixSet];
    
    return self;
}

- (void)dealloc
{    
    [totalBoundLabel release];
    [totalInboundLabel release];
    [totalOutboundLabel release];
    [agtAnswerRateLabel release];
    [percentSign release];
    [avrAnswerCntLabel release];
    [avrWaitDurLabel release];
    [avrSvrDurLabel release];
    [avrWorkDurLabel release];
    [lastAvrAnswerCntLabel release];
    [lastAvrWaitDurLabel release];
    [lastAvrSvrDurLabel release];
    [lastAvrWorkDurLabel release];
    [originView release];
    [landscapeView release];
    
    [barChartView release];
    [barChart release];
    [barChartViewLandscape release];
    [barChartLandscape release];
    [pieChartView release];
    [pieChart release];
    [pieChartViewLandscape release];
    [pieChartLandscape release];
    
    [agtTotalInfoCashResponseStr release];
    [agtAverageInfoCashResponseStr release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
    if (df) {  
        refreshInterval = [[df objectForKey:@"statisticsinterval"]intValue];
    }
    if(0 == refreshInterval)
    {
        refreshInterval = 60;
    }
    [self createBarChartAndPiePlotInOriginView];
    [self createBarChartAndPiePlotInLandscapeView];
    
    loadingOrigin=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
             UIActivityIndicatorViewStyleWhiteLarge];
    loadingOrigin.center=CGPointMake(160,200);
    loadingLandscape=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                   UIActivityIndicatorViewStyleWhiteLarge];
    loadingLandscape.center=CGPointMake(240,110);
    ifLoading=YES;
}


- (void)dataUpdateStart
{
    if (timer == nil) {
        [self requestData];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                    target:self 
                                                  selector:@selector(requestData) 
                                                  userInfo:nil 
                                                   repeats:YES]; 
    }
}

- (void)dataUpdatePause
{
    [timer invalidate];
    if (timer != nil) {
        self.timer = nil;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.totalBoundLabel = nil;
    self.totalInboundLabel = nil;
    self.totalOutboundLabel = nil;
    self.agtAnswerRateLabel = nil;
    self.percentSign = nil;
    self.avrAnswerCntLabel = nil;
    self.avrWaitDurLabel = nil;
    self.avrSvrDurLabel = nil;
    self.avrWorkDurLabel = nil;
    self.lastAvrAnswerCntLabel = nil;
    self.lastAvrWaitDurLabel = nil;
    self.lastAvrSvrDurLabel = nil;
    self.lastAvrWorkDurLabel = nil;
    self.originView = nil;
    self.landscapeView = nil;
    self.loadingOrigin =nil;
    self.loadingLandscape =nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Download and Update Data
-(void)showWaiting {
    [loadingOrigin startAnimating];
    [loadingLandscape startAnimating];
    [self.originView addSubview:loadingOrigin];
    [self.landscapeView addSubview:loadingLandscape];
}
//消除滚动轮指示器
-(void)hideWaiting 
{
    [loadingOrigin stopAnimating];
    [loadingLandscape stopAnimating];
    [loadingOrigin removeFromSuperview];
    [loadingLandscape removeFromSuperview];
}

- (void)requestData
{
    if (ifLoading) {
        [self showWaiting];
        //NSLog(@"%d showWaing",ifLoading);
        ifLoading=NO;
    }
    //NSLog(@"%d ifLoading in requestData",ifLoading);
    
    ASIHTTPRequest *agtTotalInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.agtTotalInfoWebAddr]];
    [agtTotalInfoRequest setDelegate:self];
    [agtTotalInfoRequest startAsynchronous];
    
    ASIHTTPRequest *agtAverageInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.agtAverageInfoWebAddr]];
    [agtAverageInfoRequest setDelegate:self];
    [agtAverageInfoRequest startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    requestFailedCount = 0;
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    if ([request.url.absoluteString isEqualToString:agtTotalInfoWebAddr]) {
        if (![agtTotalInfoCashResponseStr isEqualToString:responseString]) {
            self.agtTotalInfoCashResponseStr = responseString ;
            NSArray *tmpArray = [responseString JSONValue];
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {
                totalInboundNum = 0;
                totalOutboundNum = 0;
                totalAgtAnswerNum = 0;
                totalTransAgtNum = 0;
                veryGoodNum = 0;
                goodNum = 0;
                generalNum = 0;
                badNum = 0;
                veryBadNum = 0;
                answerRate1Num = 0;
                answerRate2Num = 0;
                answerRate3Num = 0;
                answerRate4Num = 0;
                for (NSMutableDictionary *anyDic in tmpArray) {
                    totalInboundNum += [[anyDic objectForKey:@"totalinbound"]intValue];
                    totalOutboundNum += [[anyDic objectForKey:@"totaloutbound"]intValue];
                    NSInteger theTotalagtanswer = [[anyDic objectForKey:@"totalagtanswer"]intValue];
                    totalAgtAnswerNum += theTotalagtanswer;
                    totalTransAgtNum += [[anyDic objectForKey:@"totaltransagt"]intValue];
                    veryGoodNum += [[anyDic objectForKey:@"verygood"]intValue];
                    goodNum += [[anyDic objectForKey:@"good"]intValue];
                    generalNum += [[anyDic objectForKey:@"infogeneral"]intValue];
                    badNum += [[anyDic objectForKey:@"bad"]intValue];
                    veryBadNum += [[anyDic objectForKey:@"verybad"]intValue];
                    
                    answerRate1Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate1"]floatValue]);
                    answerRate2Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate2"]floatValue]);
                    answerRate3Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate3"]floatValue]);
                    answerRate4Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate4"]floatValue]);
                }
                totalBoundNum = totalInboundNum + totalOutboundNum;
                self.barPlotData = [NSArray arrayWithObjects:
                                    [NSNumber numberWithInt:veryGoodNum],
                                    [NSNumber numberWithInt:goodNum],
                                    [NSNumber numberWithInt:generalNum],
                                    [NSNumber numberWithInt:badNum],
                                    [NSNumber numberWithInt:veryBadNum],
                                    nil];
                
                self.answerRatePersent = [NSArray arrayWithObjects:
                                          [NSNumber numberWithFloat:answerRate1Num/totalAgtAnswerNum],
                                          [NSNumber numberWithFloat:answerRate2Num/totalAgtAnswerNum],
                                          [NSNumber numberWithFloat:answerRate3Num/totalAgtAnswerNum],
                                          [NSNumber numberWithFloat:answerRate4Num/totalAgtAnswerNum],
                                          nil];
                if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:WithMessage:)]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YY-MM-dd hh:mm:ss"];
                    NSString *timeString=[formatter stringFromDate: [NSDate date]];
                    [formatter release];
                    [delegate willInfoBoardUpdateUIOnPage:0 WithMessage:timeString];
                }
                if (ifLoading==NO){
                    [self hideWaiting];
                    //NSLog(@"hideWating");
                }
                self.view == originView?[self updateOriginView:request]:[self updateLandscapeView:request];
            }
        }
    }
    else if ([request.url.absoluteString isEqualToString:agtAverageInfoWebAddr])
    {
        if (![agtAverageInfoCashResponseStr isEqualToString:responseString]) {
            self.agtAverageInfoCashResponseStr = responseString;
            NSArray *tmpArray = [responseString JSONValue];
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {
                grpCount = (float)[tmpArray count];//[tmpArray count]已确保非0
                avrAnswerCntNum = 0;
                avrWaitDurNum = 0;
                avrSvrDurNum = 0;
                avrWorkDurNum = 0;
                lastAvrAnswerCntNum = 0;
                lastAvrWaitDurNum = 0;
                lastAvrSvrDurNum = 0;
                lastAvrWorkDurNum = 0;
                for (NSDictionary* anyDic in tmpArray) {
                    avrAnswerCntNum += [[anyDic objectForKey:@"avranswer"]intValue];
                    avrWaitDurNum += [[anyDic objectForKey:@"avrwaitdur"]intValue];;
                    avrSvrDurNum += [[anyDic objectForKey:@"avrsvrdur"]intValue];;
                    avrWorkDurNum += [[anyDic objectForKey:@"avrworkdur"]intValue];;
                    lastAvrAnswerCntNum += [[anyDic objectForKey:@"lastavranswercnt"]intValue];;
                    lastAvrWaitDurNum += [[anyDic objectForKey:@"lastavrwaitdur"]intValue];;
                    lastAvrSvrDurNum += [[anyDic objectForKey:@"lastavrsvrdur"]intValue];;
                    lastAvrWorkDurNum += [[anyDic objectForKey:@"lastavrworkdur"]intValue];;
                }
                
                if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:WithMessage:)]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YY-MM-dd hh:mm:ss"];
                    NSString *timeString=[formatter stringFromDate: [NSDate date]];
                    [formatter release];
                    [delegate willInfoBoardUpdateUIOnPage:0 WithMessage:timeString];
                }
                self.view == originView?[self updateOriginView:request]:[self updateLandscapeView:request];
            }
        }
    }
    /*
    if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]]) {
        if ([request.url.absoluteString isEqualToString:agtTotalInfoWebAddr]) {
            
            totalInboundNum = 0;
            totalOutboundNum = 0;
            totalAgtAnswerNum = 0;
            totalTransAgtNum = 0;
            veryGoodNum = 0;
            goodNum = 0;
            generalNum = 0;
            badNum = 0;
            veryBadNum = 0;
            answerRate1Num = 0;
            answerRate2Num = 0;
            answerRate3Num = 0;
            answerRate4Num = 0;
            for (NSMutableDictionary *anyDic in tmpArray) {
                totalInboundNum += [[anyDic objectForKey:@"totalinbound"]intValue];
                totalOutboundNum += [[anyDic objectForKey:@"totaloutbound"]intValue];
                NSInteger theTotalagtanswer = [[anyDic objectForKey:@"totalagtanswer"]intValue];
                totalAgtAnswerNum += theTotalagtanswer;
                totalTransAgtNum += [[anyDic objectForKey:@"totaltransagt"]intValue];
                veryGoodNum += [[anyDic objectForKey:@"verygood"]intValue];
                goodNum += [[anyDic objectForKey:@"good"]intValue];
                generalNum += [[anyDic objectForKey:@"infogeneral"]intValue];
                badNum += [[anyDic objectForKey:@"bad"]intValue];
                veryBadNum += [[anyDic objectForKey:@"verybad"]intValue];
                
                answerRate1Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate1"]floatValue]);
                answerRate2Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate2"]floatValue]);
                answerRate3Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate3"]floatValue]);
                answerRate4Num += round(theTotalagtanswer*[[anyDic objectForKey:@"answerrate4"]floatValue]);
            }
            totalBoundNum = totalInboundNum + totalOutboundNum;
        }
        else if ([request.url.absoluteString isEqualToString:agtAverageInfoWebAddr])
        {        
            grpCount = (float)[tmpArray count];//[tmpArray count]已确保非0
            avrAnswerCntNum = 0;
            avrWaitDurNum = 0;
            avrSvrDurNum = 0;
            avrWorkDurNum = 0;
            lastAvrAnswerCntNum = 0;
            lastAvrWaitDurNum = 0;
            lastAvrSvrDurNum = 0;
            lastAvrWorkDurNum = 0;
            for (NSDictionary* anyDic in tmpArray) {
                avrAnswerCntNum += [[anyDic objectForKey:@"avranswer"]intValue];
                avrWaitDurNum += [[anyDic objectForKey:@"avrwaitdur"]intValue];;
                avrSvrDurNum += [[anyDic objectForKey:@"avrsvrdur"]intValue];;
                avrWorkDurNum += [[anyDic objectForKey:@"avrworkdur"]intValue];;
                lastAvrAnswerCntNum += [[anyDic objectForKey:@"lastavranswercnt"]intValue];;
                lastAvrWaitDurNum += [[anyDic objectForKey:@"lastavrwaitdur"]intValue];;
                lastAvrSvrDurNum += [[anyDic objectForKey:@"lastavrsvrdur"]intValue];;
                lastAvrWorkDurNum += [[anyDic objectForKey:@"lastavrworkdur"]intValue];;
            }
        }
        self.view == originView?[self updateOriginView:request]:[self updateLandscapeView:request];
    }
     */
    [responseString release];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    requestFailedCount ++;
    if (requestFailedCount < 6) {
        ASIHTTPRequest *newRequest = [[request copy] autorelease]; 
        [newRequest startAsynchronous]; 
    }
}

#pragma mark - update UI
- (void)createBarChartAndPiePlotInOriginView 
{
    // Create barChart from theme
    self.barChartView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(18.0f,180.0f,134.0f,140.0f)];
    barChartView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:barChartView];
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTGraphHostingView *barChartHostingView = (CPTGraphHostingView *)self.barChartView;
    barChartHostingView.hostedGraph = barChart;
    
    // Border
    //barChart.plotAreaFrame.borderLineStyle = nil;
    //barChart.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChart.paddingLeft = 0.0f;
    barChart.paddingRight = 0.0f;
    barChart.paddingTop = 0.0f;
    barChart.paddingBottom = 0.0f;
	
    //barChart.plotAreaFrame.paddingLeft = 2.0;
	//barChart.plotAreaFrame.paddingTop = 2.0;
	//barChart.plotAreaFrame.paddingRight = 2.0;
	//barChart.plotAreaFrame.paddingBottom = 2.0;
    
    /*
     // Graph title
     barChart.title = @"客户满意度";
     CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
     textStyle.color = [CPTColor whiteColor];
     //textStyle.fontSize = 16.0f;
     textStyle.textAlignment = CPTTextAlignmentCenter;
     barChart.titleTextStyle = textStyle;
     barChart.titleDisplacement = CGPointMake(0.0f, -10.0f);
     barChart.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
     */
    
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    //plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(50.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:4]intValue]*1.2f+1.0)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(5.0f)];
    
    
	
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	x.title = nil;//@"X Axis";
    //x.titleLocation = CPTDecimalFromFloat(5.0f);
	//x.titleOffset = 15.0f;
	
	// Define some custom labels for the data elements
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
	CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    y.majorIntervalLength = CPTDecimalFromString(@"50");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
	y.title = nil;//@"Y Axis";
	//y.titleOffset = 5.0f;
    //y.titleLocation = CPTDecimalFromFloat(150.0f);
	
    
    // First bar plot
    
    // Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 2.0;
	barLineStyle.lineColor = [CPTColor blackColor];
    barPlot = [[CPTBarPlot alloc]init];
    barPlot.lineStyle = barLineStyle;
    barPlot.barCornerRadius = 3.0f;
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.barOffset = CPTDecimalFromFloat(0.5f);
    barPlot.barWidth = CPTDecimalFromFloat(0.65f);
    barPlot.labelOffset = 0.5f;
    barPlot.identifier = @"BarPlot";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    
    //pieChart
    pieChartView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(168.0f,180.0f,134.0f,140.0f)];
    pieChartView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.pieChartView];
    pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTGraphHostingView *pieChartHostingView = (CPTGraphHostingView *)self.pieChartView;
    pieChartHostingView.hostedGraph = pieChart;
	
    pieChart.paddingLeft = 0.0f;
	pieChart.paddingTop = 0.0f;
	pieChart.paddingRight = 0.0f;
	pieChart.paddingBottom = 0.0f;
	
	pieChart.axisSet = nil;
	
    /*
     pieChart.titleTextStyle.color = [CPTColor whiteColor];
     pieChart.title = @"从呼叫到接听服务";
     pieChart.titleDisplacement = CGPointMake(0.0f, -10.0f);
     */
    // Add pie chart
    self.piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource = self;
	piePlot.pieRadius = 58.0;
    piePlot.labelOffset = -28.0f;
    piePlot.identifier = @"PiePlot";
	piePlot.startAngle = 0.0f;
	piePlot.sliceDirection = CPTPieDirectionCounterClockwise;
	piePlot.centerAnchor = CGPointMake(0.5, 0.45);
	piePlot.borderLineStyle = barLineStyle;//[CPTLineStyle lineStyle];
    // Overlay gradient for pie chart
    CPTGradient *overlayGradient = [[[CPTGradient alloc] init]autorelease];
    overlayGradient.gradientType = CPTGradientTypeRadial;
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.0];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.2] atPosition:0.9];
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.6] atPosition:1.0];
    piePlot.overlayFill = [CPTFill fillWithGradient:overlayGradient];
	piePlot.delegate = self;
    [pieChart addPlot:piePlot];
    [piePlot release];
}

- (void)createBarChartAndPiePlotInLandscapeView 
{
    // Create barChart from theme
    self.barChartViewLandscape = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0, 0, 238.0, 263.0)];
    barChartViewLandscape.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [self.landscapeView addSubview:self.barChartViewLandscape];
    barChartLandscape = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
//	CPTTheme *barChartTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
//    CPTTheme 统计图主题
//    [barChartLandscape applyTheme:barChartTheme];
	CPTGraphHostingView *barChartHostingView = (CPTGraphHostingView *)self.barChartViewLandscape;
    barChartHostingView.hostedGraph = barChartLandscape;
    
    // Border
    barChartLandscape.plotAreaFrame.borderLineStyle = nil;
    barChartLandscape.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChartLandscape.paddingLeft = 0.0f;//容器与表格层的间隔，标题写在表格层上，背景图也是在表格层上
    barChartLandscape.paddingRight = 0.0f;
    barChartLandscape.paddingTop = 10.0f;
    barChartLandscape.paddingBottom = .0f;
	
    barChartLandscape.plotAreaFrame.paddingLeft = 10.0;//表格层与柱状图形层的间隔
	barChartLandscape.plotAreaFrame.paddingTop = 10.0;
	barChartLandscape.plotAreaFrame.paddingRight = 10.0;
	barChartLandscape.plotAreaFrame.paddingBottom = 36.0;
    barChartLandscape.title = @"客户满意度";
    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
	pieChart.titleTextStyle = whiteText;
    barChartLandscape.titleTextStyle=whiteText;
    
    // Graph title
    /*
     barChart.title = @"客户满意度";
     CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
     textStyle.color = [CPTColor whiteColor];
     //textStyle.fontSize = 16.0f;
     textStyle.textAlignment = CPTTextAlignmentCenter;
     barChart.titleTextStyle = textStyle;
     //barChart.titleDisplacement = CGPointMake(0.0f, -20.0f);
     barChart.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
     */
    
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartLandscape.defaultPlotSpace;
    //plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(90.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:4] intValue]*1.2f+1.0)];//y轴的数值范围
    //compare：默认排序方式，从小到大
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(5.0f)];
    
    // Create grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    //主要线条
    majorGridLineStyle.lineWidth = 1.0f;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.2f];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    //次要线条
    minorGridLineStyle.lineWidth = 1.0f;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.1f];    
    
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChartLandscape.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.minorTicksPerInterval = 1;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    //x轴上的标签文字离x轴线的距离
	//x.title = nil;//@"X Axis";
    //x.titleLocation = CPTDecimalFromFloat(5.0f);
	//x.titleOffset = 15.0f;
	
    
	// Define some custom labels for the data elements
	x.labelRotation = M_PI/4;//x轴文字旋转的角度
	x.labelingPolicy = CPTAxisLabelingPolicyNone;//x轴不画标签并且不画格线
    x.labelOffset = -8.0f;//自定义的标签离x轴的距离
    CPTMutableTextStyle *xLabelTextStyle = [CPTTextStyle textStyle];
    xLabelTextStyle.color = [CPTColor whiteColor];
    xLabelTextStyle.fontSize = 11.0f;
    xLabelTextStyle.textAlignment = CPTTextAlignmentRight;
    x.labelTextStyle = xLabelTextStyle;
    NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:0.2f], [NSDecimalNumber numberWithFloat:1.2f], [NSDecimalNumber numberWithFloat:2.2f], [NSDecimalNumber numberWithFloat:3.2f],[NSDecimalNumber numberWithFloat:4.2f], nil];
    NSArray *xAxisLabels = [NSArray arrayWithObjects:@"很 满 意", @"满   意", @"一   般", @"不 满 意", @"很不满意", nil];
    NSUInteger labelLocation = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for (NSNumber *tickLocation in customTickLocations) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];//返回浮点数
        newLabel.offset = x.labelOffset + x.majorTickLength;//两个标签之间的数值间隔
        newLabel.rotation = M_PI/4;
        [customLabels addObject:newLabel];
        [newLabel release];
    }
    
    x.axisLabels =  [NSSet setWithArray:customLabels];
    
    
	CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    //y.majorIntervalLength = CPTDecimalFromString(@"50");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"-3.0f");
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.minorTicksPerInterval = 2.0f;
	y.title = nil;//@"Y Axis";
	//y.titleOffset = 5.0f;
    //y.titleLocation = CPTDecimalFromFloat(150.0f);
	
    // First bar plot
    CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 2.5;
	barLineStyle.lineColor = [CPTColor blackColor];
    //barPlotLandscape = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlotLandscape = [[CPTBarPlot alloc]init];
    barPlotLandscape.lineStyle = barLineStyle;
    barPlotLandscape.labelOffset = 0.2f;
    barPlotLandscape.barWidth = CPTDecimalFromFloat(0.618f);
    //barPlotLandscape.baseValue = CPTDecimalFromString(@"0.1");
    barPlotLandscape.barCornerRadius = 5.0f;
    barPlotLandscape.dataSource = self;
    //barPlot.barOffset = CPTDecimalFromFloat(0.5f);
    barPlotLandscape.identifier = @"BarPlot";
    [barChartLandscape addPlot:barPlotLandscape toPlotSpace:plotSpace];
    //CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	//whiteText.color = [CPTColor whiteColor];
    //pieChart
    pieChartViewLandscape = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(242,0,238,263)];
    pieChartViewLandscape.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [self.landscapeView addSubview:self.pieChartViewLandscape];
    pieChartLandscape = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
//	CPTTheme *pieChartTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
//    [pieChartLandscape applyTheme:pieChartTheme];
	CPTGraphHostingView *pieChartHostingView = (CPTGraphHostingView *)self.pieChartViewLandscape;
    pieChartHostingView.hostedGraph = pieChartLandscape;
	
    pieChartLandscape.paddingLeft = 0.0f;
	pieChartLandscape.paddingTop = 10.0f;
	pieChartLandscape.paddingRight = 0.0f;
	pieChartLandscape.paddingBottom = 0.0f;
	
	pieChartLandscape.axisSet = nil;
	pieChartLandscape.title=@"接听效率";
 	pieChartLandscape.titleTextStyle = whiteText;
    pieChartLandscape.plotAreaFrame.cornerRadius = 0.0f;
//     pieChart.titleTextStyle.color = [CPTColor whiteColor];
     //pieChart.title = @"从呼叫到接听服务";
     //pieChart.titleDisplacement = CGPointMake(70, 0);
     
    
    // Add pie chart
    self.piePlotLandscape = [[CPTPieChart alloc] init];
    piePlotLandscape.dataSource = self;
	piePlotLandscape.pieRadius = 95.0f;
    piePlotLandscape.identifier = @"PiePlotLandscape";
	piePlotLandscape.startAngle = 0.0f;
    piePlotLandscape.labelOffset = -65.0f;
	piePlotLandscape.sliceDirection = CPTPieDirectionCounterClockwise;
	piePlotLandscape.centerAnchor = CGPointMake(0.5, 0.5);
	piePlotLandscape.borderLineStyle = barLineStyle;
    //piePlotLandscape.title=@"客户满意度";
    //piePlotLandscape.borderLineStyle = barLineStyle;
    
    // Overlay gradient for pie chart
    CPTGradient *overlayGradient = [[[CPTGradient alloc] init]autorelease];
    overlayGradient.gradientType = CPTGradientTypeRadial;
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.0];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.3] atPosition:0.9];
	overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.7] atPosition:1.0];
    piePlotLandscape.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    //[overlayGradient release];
	piePlotLandscape.delegate = self;

    [pieChartLandscape addPlot:piePlotLandscape];
    [piePlotLandscape release];
    
  
     /*// Add legend
     //CPTLegend *theLegend = [CPTLegend legendWithGraph:pieChartLandscape];
     CPTLegend *theLegend = [[CPTLegend alloc ]initWithGraph:pieChartLandscape];
     theLegend.numberOfColumns = 2;
     //theLegend.fill = [CPTFill fillWithColor:[CPTColor grayColor]];
     //theLegend.borderLineStyle = [CPTLineStyle lineStyle];
     theLegend.borderLineStyle = barLineStyle;
     theLegend.cornerRadius = 5.0;
     
     pieChartLandscape.legend = theLegend;
     
     //pieChartLandscape.legendAnchor = CPTRectAnchorRight;
     pieChartLandscape.legendDisplacement = CGPointMake(0.0, 20.0);*/
}
-(void)updateOriginView:(ASIHTTPRequest *)request
{
    //当nil==request时强制更新全部竖屏UI
    if (!request) {
        
        totalBoundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalBoundNum];
        totalInboundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalInboundNum];
        totalOutboundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalOutboundNum];
        
        if(totalTransAgtNum)
        {
            if(totalAgtAnswerNum != totalTransAgtNum)
            {
                float agtAnswerRate = (NSInteger)(round((totalAgtAnswerNum / totalTransAgtNum) * 1000));
                NSString *_str = [[NSString alloc] initWithFormat:@"%0.1f%%", agtAnswerRate/10.0f];
                agtAnswerRateLabel.text =  _str;
                [_str release];
            }
            else
            {
                NSString *_str = [[NSString alloc] initWithString:@"100%"];
                agtAnswerRateLabel.text =  _str;
                [_str release];
            }
            //self.agtAnswerRateLabel.textColor = answerRateColor;
            //self.percentSign.textColor = answerRateColor;
        }
        else
        {
            NSString *_str = [[NSString alloc] initWithString:@"0"];
            agtAnswerRateLabel.text = _str;
            [_str release];
            //self.agtAnswerRateLabel.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.25f alpha:1.0f];
            //self.percentSign.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.25f alpha:1.0f];
        }

        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:4]intValue]*1.2f+1.0)];
        [barPlot reloadData];
        [piePlot reloadData];
        
        NSString *_str0 = [[NSString alloc ]initWithFormat:@"%0.1f",avrAnswerCntNum/grpCount];
        self.avrAnswerCntLabel.text = _str0;
        [_str0 release];
        NSString *_str1 = [[NSString alloc ]initWithFormat:@"%0.1f", avrWaitDurNum/grpCount];
        self.avrWaitDurLabel.text = _str1;
        [_str1 release];
        NSString *_str2 = [[NSString alloc ]initWithFormat:@"%0.1f", avrSvrDurNum/grpCount];
        self.avrSvrDurLabel.text = _str2;
        [_str2 release];
        
        NSString *_str3 = [[NSString alloc ]initWithFormat:@"%0.1f", avrWorkDurNum/grpCount];
        self.avrWorkDurLabel.text = _str3;
        [_str3 release];
        
        NSString *_str4 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrAnswerCntNum/grpCount];
        self.lastAvrAnswerCntLabel.text = _str4;
        [_str4 release];
        
        NSString *_str5 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrWaitDurNum/grpCount];
        self.lastAvrWaitDurLabel.text = _str5;
        [_str5 release];
        
        
        NSString *_str6 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrSvrDurNum/grpCount];
        self.lastAvrSvrDurLabel.text = _str6;
        [_str6 release];
        
        
        NSString *_str7 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrWorkDurNum/grpCount];
        self.lastAvrWorkDurLabel.text = _str7;
        [_str7 release];
        
        
    }
    else if ([request.url.absoluteString isEqualToString:agtTotalInfoWebAddr]) {
        totalBoundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalBoundNum];
        totalInboundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalInboundNum];
        totalOutboundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalOutboundNum];
        
        if(totalTransAgtNum)
        {
            if(totalAgtAnswerNum != totalTransAgtNum)
            {
                float agtAnswerRate = (NSInteger)(round((totalAgtAnswerNum / totalTransAgtNum) * 1000));
                NSString *_str = [[NSString alloc] initWithFormat:@"%0.1f%%", agtAnswerRate/10.0f];
                agtAnswerRateLabel.text =  _str;
                [_str release];
            }
            else
            {
                NSString *_str = [[NSString alloc] initWithString:@"100%"];
                agtAnswerRateLabel.text =  _str;
                [_str release];
            }
            //self.agtAnswerRateLabel.textColor = answerRateColor;
            //self.percentSign.textColor = answerRateColor;
        }
        else
        {
            NSString *_str = [[NSString alloc] initWithString:@"0"];
            agtAnswerRateLabel.text = _str;
            [_str release];
            //self.agtAnswerRateLabel.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.25f alpha:1.0f];
            //self.percentSign.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.25f alpha:1.0f];
        }
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:4]intValue]*1.2f+1.0)];
        [barPlot reloadData];
        [piePlot reloadData];
    }
    else if ([request.url.absoluteString isEqualToString:agtAverageInfoWebAddr])
    {
        NSString *_str0 = [[NSString alloc ]initWithFormat:@"%0.1f",avrAnswerCntNum/grpCount];
        self.avrAnswerCntLabel.text = _str0;
        [_str0 release];
        NSString *_str1 = [[NSString alloc ]initWithFormat:@"%0.1f", avrWaitDurNum/grpCount];
        self.avrWaitDurLabel.text = _str1;
        [_str1 release];
        NSString *_str2 = [[NSString alloc ]initWithFormat:@"%0.1f", avrSvrDurNum/grpCount];
        self.avrSvrDurLabel.text = _str2;
        [_str2 release];
        
        NSString *_str3 = [[NSString alloc ]initWithFormat:@"%0.1f", avrWorkDurNum/grpCount];
        self.avrWorkDurLabel.text = _str3;
        [_str3 release];
        
        NSString *_str4 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrAnswerCntNum/grpCount];
        self.lastAvrAnswerCntLabel.text = _str4;
        [_str4 release];
        
        NSString *_str5 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrWaitDurNum/grpCount];
        self.lastAvrWaitDurLabel.text = _str5;
        [_str5 release];
        
        
        NSString *_str6 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrSvrDurNum/grpCount];
        self.lastAvrSvrDurLabel.text = _str6;
        [_str6 release];
        
        
        NSString *_str7 = [[NSString alloc ]initWithFormat:@"%0.1f", lastAvrWorkDurNum/grpCount];
        self.lastAvrWorkDurLabel.text = _str7;
        [_str7 release];
    }
       
}

-(void)updateLandscapeView:(ASIHTTPRequest *)request
{
    //当nil==request时强制更新UI
    if (!request || [request.url.absoluteString isEqualToString:agtTotalInfoWebAddr]) {
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartLandscape.defaultPlotSpace;
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:4]intValue]*1.2f+1.0)];
        [barPlotLandscape reloadData];
        [piePlotLandscape reloadData];
    }
}

- (void)cleanUI
{
    totalBoundLabel.text = nil;
    totalInboundLabel.text = nil;
    totalOutboundLabel.text = nil;
    agtAnswerRateLabel.text = nil;
    avrAnswerCntLabel.text = nil;
    avrWaitDurLabel.text = nil;
    avrSvrDurLabel.text = nil;
    avrWorkDurLabel.text = nil;
    lastAvrAnswerCntLabel.text = nil;
    lastAvrWaitDurLabel.text = nil;
    lastAvrSvrDurLabel.text = nil;
    lastAvrWorkDurLabel.text = nil;
    self.barPlotData = nil;
    self.answerRatePersent = nil;
    [barPlot reloadData];
    [piePlot reloadData];
    [barPlotLandscape reloadData];
    [piePlotLandscape reloadData];
}
#pragma mark - Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot.identifier isEqual:@"BarPlot"])
    {
        return [barPlotData count];
    }
    else
    {
        return [answerRatePersent count];
    }
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    if([plot.identifier isEqual:@"BarPlot"])
    {
        switch ( fieldEnum ) {
			case CPTBarPlotFieldBarLocation:
				return  (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index)];
                
			case CPTBarPlotFieldBarTip:
				return  [barPlotData objectAtIndex:index];
            default:
                return nil;

		}
        
    }
    else{
        if ( index >= [self.answerRatePersent count] ) return nil;
        
        if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
            return [answerRatePersent objectAtIndex:index];
        }
        else {
            return [NSNumber numberWithInt:index];
        }
    }

}


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
    if([plot.identifier isEqual:@"BarPlot"])
    {
        //CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", index]];
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@",[barPlotData objectAtIndex:index]]];
        CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
        textStyle.color = [CPTColor whiteColor];
        label.textStyle = textStyle;
        [textStyle release];
        return [label autorelease];
    }
    else if ([plot.identifier isEqual:@"PiePlot"])
    {
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%0.1f%%",[[answerRatePersent objectAtIndex:index]floatValue]*100]];
        CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
        textStyle.color = [CPTColor whiteColor];
        label.textStyle = textStyle;
        [textStyle release];
        return [label autorelease];
    }
	else if ([plot.identifier isEqual:@"PiePlotLandscape"])
    {   
        NSArray *array = [NSArray arrayWithObjects:[NSString stringWithFormat:@"小于5秒"],[NSString stringWithFormat:@" 5 - 10秒"],[NSString stringWithFormat:@" 10-15秒"],[NSString stringWithFormat:@"大于15秒"], nil];
        
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@   \n   %0.1f%%",[array objectAtIndex:index],[[answerRatePersent objectAtIndex:index]floatValue]*100]];
        CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
        textStyle.color = [CPTColor whiteColor];
        label.textStyle = textStyle;
        [textStyle release];
        return [label autorelease];
    }
    else
        return nil;

}

/*
-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    //return ( index == 0 ? 30.0f : 0.0f );
    return 0.0f;
}
 */

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    /*
     CPTColor *areaColor = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
     CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
     areaGradient.angle = -90.0;
     CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
     return areaGradientFill;

     
     cbf869__ 67d83b
     47dcee--3aabeb
     f5f05e__f8b932
     f38be8__e33dc2
     f52b77__e9243b
     */
    switch (index) {
        case 0:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0x67/255.0f green:0xd8/255.0f  blue:0x3b/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xcb/255.0f green:0xf8/255.0f  blue:0x69/255.0f  alpha:1.0f];
            //CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 1:
        {
            CPTColor *areaColor =  [CPTColor colorWithComponentRed:0x3a/255.0f  green:0xab/255.0f  blue:0xeb/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0x47/255.0f green:0xdc/255.0f  blue:0xee/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 2:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xf8/255.0f  green:0xb9/255.0f  blue:0x32/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xf5/255.0f green:0xf0/255.0f  blue:0x5e/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 3:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xe3/255.0f  green:0x3d/255.0f  blue:0xc2/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xf3/255.0f green:0x8b/255.0f  blue:0xe8/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 4:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xe9/255.0f green:0x24/255.0f  blue:0x3b/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xf5/255.0f green:0x2b/255.0f  blue:0x77/255.0f  alpha:1.0f];
            //CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        default:
            return nil;
    }
    
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0x67/255.0f green:0xd8/255.0f  blue:0x3b/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xcb/255.0f green:0xf8/255.0f  blue:0x69/255.0f  alpha:1.0f];
            //CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 1:
        {
            CPTColor *areaColor =  [CPTColor colorWithComponentRed:0x3a/255.0f  green:0xab/255.0f  blue:0xeb/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0x47/255.0f green:0xdc/255.0f  blue:0xee/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 2:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xf8/255.0f  green:0xb9/255.0f  blue:0x32/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xf5/255.0f green:0xf0/255.0f  blue:0x5e/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 3:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xe9/255.0f green:0x24/255.0f  blue:0x3b/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xf5/255.0f green:0x2b/255.0f  blue:0x77/255.0f  alpha:1.0f];
            //CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        default:
            return nil;
    }
}

/*
-(NSString *)legendTitleForPieChart:(CPTPieChart *)apieChart recordIndex:(NSUInteger)index
{
    
     
    NSLog(@"legend??");
    return [NSString stringWithFormat:@"Pie Slice %u", index];
}
*/
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    if ([plot.identifier isEqual:@"PiePlotLandscape"])
    {
        switch (index) {
            case 3:
            {
                
            }
                break;
            case 4:
            {
                
            }
                break;
            default:
                break;
        }
    }

}
 -(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
 {
 //pieChart.title = [NSString stringWithFormat:@"Selected index: %lu", index];
 }
 
#pragma mark - utiles


- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number
{
    if (number < 1000) {
        NSMutableString *resultString = [[NSMutableString alloc ]initWithFormat:@"%d", number];
        return [resultString autorelease];
    }
    else
    {
        NSMutableString *resultString = [[NSMutableString alloc ]initWithFormat:@"%d,%d", number/1000, number%1000];
        if ((number%1000)<10) 
        {
            NSRange range = [resultString rangeOfString:@","];
            [resultString insertString:@"00" atIndex:range.location+1]; 
        }
        else if ((number%1000)<100) 
        {
            NSRange range = [resultString rangeOfString:@","];
            [resultString insertString:@"0" atIndex:range.location+1]; 
        }
        return [resultString autorelease];
    }
}


@end
