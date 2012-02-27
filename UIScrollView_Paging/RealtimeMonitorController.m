//
//  RealtimeMonitorController.m
//  ShentongFlexBoard
//
//  Created by crazysnow on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
#import "RealtimeMonitorController.h"


@implementation RealtimeMonitorController

@synthesize addrPrefix;
@synthesize addrPostfix;
@synthesize webAddr;
@synthesize timer;
@synthesize dataDictionary;

@synthesize barChartView;   
@synthesize barChart;
@synthesize barPlot;    
@synthesize barChartViewLandscape;   
@synthesize barChartLandscape;
@synthesize barPlotLandscape;
@synthesize barPlotData;
@synthesize customLabels;

@synthesize totalBoundLabel;
@synthesize totalInboundLabel;
@synthesize totalOutboundLabel;
@synthesize totalTransAgtLabel;
@synthesize totalAgtAnswerLabel;
@synthesize agtAnswerRateLabel,percentSignLabel;
@synthesize totalIVRLabel;
@synthesize inboundLabel;
@synthesize outboundLabel;
@synthesize queueLabel;
@synthesize loninAgtLabel;

@synthesize originView;
@synthesize landscapeView;

@synthesize delegate,cashResponseStr;
@synthesize loadingOrigin,loadingLandscape;
@synthesize ifLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cashResponseStr = [[NSString alloc]init];
    }
    return self;
}
- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
    //self.webAddr = [[NSString alloc ]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/AgtTotalInfo.json"];
    self.addrPrefix = newAddrPrefix;
    self.addrPostfix = newAddrPostfix;
    webAddr = [[NSString alloc ]initWithFormat:@"%@AgttotalInfo%@",addrPrefix,addrPostfix];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
    [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setAddrWithAddrPrefix:newAddrPrefix AddrPostfix:newAddrPostfix];
    
    return self;
}
- (void)dealloc
{
    [totalBoundLabel release];
    [totalInboundLabel release];
    [totalOutboundLabel release];
    [totalTransAgtLabel release];
    [totalAgtAnswerLabel release];
    [agtAnswerRateLabel release];
    [percentSignLabel release];
    [totalIVRLabel release];
    [loninAgtLabel release];
    [inboundLabel release];
    [outboundLabel release];
    [queueLabel release];
    [originView release];
    [landscapeView release];
    [super dealloc];
    
    [barChartView release];
    [barChart release];
    [barChartViewLandscape release];
    [barChartLandscape release];
    [cashResponseStr release];
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
    refreshInterval = 60;
    [self createBarChartInOriginView]; 
    [self createBarChartInLandscapeView];
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
    if (timer == nil)
    {
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
    // e.g. self.myOutlet = nil;
    self.totalBoundLabel = nil;
    self.totalInboundLabel = nil;
    self.totalOutboundLabel = nil;
    self.totalTransAgtLabel = nil;
    self.totalAgtAnswerLabel = nil;
    self.agtAnswerRateLabel = nil;
    self.percentSignLabel = nil;
    self.totalIVRLabel = nil;
    self.loninAgtLabel = nil;
    self.inboundLabel = nil;
    self.outboundLabel = nil;
    self.queueLabel = nil;
    self.originView = nil;
    self.landscapeView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    //NSLog(@"updateRealtimeMonitorData");
    if (ifLoading) {
        [self showWaiting];
        //NSLog(@"%d showWaing",ifLoading);
        ifLoading=NO;
    }
    //NSLog(@"%d ifLoading in requestData",ifLoading);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.webAddr]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    requestFailedCount = 0;
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];   
    if (![cashResponseStr isEqualToString:responseString]) {
        self.cashResponseStr = responseString;
        NSArray *tmpArray = [responseString JSONValue];
        
        totalInboundNum = 0;
        totalOutboundNum = 0;
        totalAgtAnswerNum = 0;
        totalTransAgtNum = 0;
        totalIVRNum = 0;
        loninAgtNum = 0;
        
        inboundNum = 0;
        outboundNum = 0;
        queueNum = 0;
        ringAgtNum = 0;
        pauseAgtNum = 0;
        idleAgtNum = 0;
        talkingAgtNum = 0;
        occupyAgtNum = 0;
        
        if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]]) 
        {
            for (NSMutableDictionary *anyDic in tmpArray) {
                totalInboundNum += [[anyDic objectForKey:@"totalinbound"]intValue];
                totalOutboundNum += [[anyDic objectForKey:@"totaloutbound"]intValue];
                totalAgtAnswerNum += [[anyDic objectForKey:@"totalagtanswer"]intValue];
                totalTransAgtNum += [[anyDic objectForKey:@"totaltransagt"]intValue];
                totalIVRNum += [[anyDic objectForKey:@"totalivr"]intValue];
                loninAgtNum += [[anyDic objectForKey:@"loninagt"]intValue];
                inboundNum += [[anyDic objectForKey:@"inbound"]intValue];
                outboundNum += [[anyDic objectForKey:@"outbound"]intValue];
                queueNum += [[anyDic objectForKey:@"infoqueue"]intValue];
                ringAgtNum += [[anyDic objectForKey:@"ringagt"]intValue];
                pauseAgtNum += [[anyDic objectForKey:@"pauseagt"]intValue];
                idleAgtNum += [[anyDic objectForKey:@"idleagt"]intValue];
                talkingAgtNum += [[anyDic objectForKey:@"talkingagt"]intValue];
                occupyAgtNum += [[anyDic objectForKey:@"occupyagt"]intValue];
                
            }
        }
        totalBoundNum = totalInboundNum + totalOutboundNum;
        self.barPlotData = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:pauseAgtNum],
                            [NSNumber numberWithInt:occupyAgtNum],
                            [NSNumber numberWithInt:talkingAgtNum],
                            [NSNumber numberWithInt:ringAgtNum],
                            [NSNumber numberWithInt:idleAgtNum],
                            nil];
        if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:WithMessage:)]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
            NSString *timeString=[formatter stringFromDate: [NSDate date]];
            [formatter release];
            [delegate willInfoBoardUpdateUIOnPage:3 WithMessage:timeString];
        }
        if (ifLoading==NO){
            [self hideWaiting];
        }
        self.view == originView?[self updateOriginView:request]:[self updateLandscapeView:request];
    }
    [responseString release];
        
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (requestFailedCount < 6) {
        ASIHTTPRequest *newRequest = [[request copy] autorelease]; 
        [newRequest startAsynchronous]; 
    }
}
 
- (void)updateOriginView:(ASIHTTPRequest *)request
{    
    
    //totalInboundNum = [[self.dataDictionary objectForKey:@"TotalInbound"] intValue];
    
    totalInboundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalInboundNum];
    
    //totalOutboundNum = [[self.dataDictionary objectForKey:@"TotalOutbound"]intValue];
    totalOutboundLabel.text = [self mutableStringWithCommaConvertFromInteger:totalOutboundNum];
    
    //totalBoundNum = totalInboundNum + totalOutboundNum;
    totalBoundLabel.text  = [self mutableStringWithCommaConvertFromInteger:totalBoundNum];
    
    //totalAgtAnswerNum = [[self.dataDictionary objectForKey:@"TotalAgtAnswer"]floatValue];
    totalAgtAnswerLabel.text = [self mutableStringWithCommaConvertFromInteger:totalAgtAnswerNum];
    
    //totalTransAgtNum = [[self.dataDictionary objectForKey:@"TotalTransAgt"]floatValue];
    totalTransAgtLabel.text = [self mutableStringWithCommaConvertFromInteger:totalTransAgtNum];
    
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
        //self.percentSignLabel.textColor = answerRateColor;
    }
    else
    {
        NSString *_str = [[NSString alloc] initWithString:@"0"];
        self.agtAnswerRateLabel.text = _str;
        [_str release];
        //self.agtAnswerRateLabel.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.25f alpha:1.0f];
        //self.percentSignLabel.textColor = [UIColor colorWithRed:0.8f green:0.0f blue:0.25f alpha:1.0f];
    }
    

    totalIVRLabel.text = [self mutableStringWithCommaConvertFromInteger:totalIVRNum];
    loninAgtLabel.text = [self mutableStringWithCommaConvertFromInteger:loninAgtNum];
    
    inboundLabel.text = [self mutableStringWithCommaConvertFromInteger:inboundNum];
    outboundLabel.text = [self mutableStringWithCommaConvertFromInteger:outboundNum];
    queueLabel.text = [self mutableStringWithCommaConvertFromInteger:queueNum];

    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
     @try{plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:([barPlotData count]-1)]intValue]*1.2f)];}
     @catch (NSException *e) {
     }
    
    [barPlot reloadData];

}
 
- (void)updateLandscapeView:(ASIHTTPRequest *)request
{
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartLandscape.defaultPlotSpace;
    @try{plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:([barPlotData count]-1)]intValue]*1.2f)];}
    @catch (NSException *e) {
    }
    
    /*
     CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChartLandscape.axisSet;
     CPTXYAxis *x = axisSet.xAxis;
     NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:0.0f], [NSDecimalNumber numberWithFloat:1.0f], [NSDecimalNumber numberWithFloat:2.0f], [NSDecimalNumber numberWithFloat:3.0f],[NSDecimalNumber numberWithFloat:4.0f],[NSDecimalNumber numberWithFloat:5.0f],[NSDecimalNumber numberWithFloat:6.0f],[NSDecimalNumber numberWithFloat:7.0f], nil];
     NSArray *xAxisLabels = [NSArray arrayWithObjects:@"呼入", @"呼出", @"排队", @"暂停",@"振铃", @"空闲",@"通话",@"处理", nil];
     NSUInteger labelLocation = 0;
     self.customLabels = [[NSMutableArray alloc ]initWithCapacity:[xAxisLabels count]];
     for (NSNumber *tickLocation in customTickLocations) {
     CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
     newLabel.tickLocation = [tickLocation decimalValue];
     newLabel.offset = x.labelOffset + x.majorTickLength;
     //newLabel.rotation = M_PI/4;
     [customLabels addObject:newLabel];
     [newLabel release];
     }
     x.axisLabels =  [NSSet setWithArray:customLabels];
     */
    
    [barPlotLandscape reloadData];
}

- (void)cleanUI
{
    totalBoundLabel.text = nil;
    totalInboundLabel.text = nil;
    totalOutboundLabel.text = nil;
    totalTransAgtLabel.text = nil;
    totalAgtAnswerLabel.text = nil;
    agtAnswerRateLabel.text = nil;
    totalIVRLabel.text = nil;
    loninAgtLabel.text = nil;
    inboundLabel.text = nil;
    outboundLabel.text = nil;
    queueLabel.text = nil;
    self.barPlotData = nil;
    [barPlot reloadData];
    [barPlotLandscape reloadData];
}
#pragma mark - create plots
- (void)createBarChartInOriginView 
{
    
    // Create barChart from theme
    self.barChartView = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(50.0f, 143.0f, 248.0f, 150.0f)];
    barChartView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;;
    [self.originView addSubview:self.barChartView];
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	//CPTTheme *barChartTheme = [CPTTheme themeNamed:kCPTPlainBlackTheme];
    //[barChart applyTheme:barChartTheme];
	CPTGraphHostingView *barChartHostingView = (CPTGraphHostingView *)self.barChartView;
    barChartHostingView.hostedGraph = barChart;
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChart.paddingLeft = 0.0f;
    barChart.paddingRight = 0.0f;
    barChart.paddingTop = 0.0f;
    barChart.paddingBottom = .0f;
	
    barChart.plotAreaFrame.paddingLeft = 2.0;
	barChart.plotAreaFrame.paddingTop = 2.0;
	barChart.plotAreaFrame.paddingRight = 2.0;
	barChart.plotAreaFrame.paddingBottom = 2.0;
    
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:([barPlotData count]-1)]intValue]*1.2f+1.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(5.0f)];
    
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = nil;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
	CPTXYAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.axisLineStyle = nil;
    
    // bar plot
	CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 2.0;
	barLineStyle.lineColor = [CPTColor blackColor];
    barPlot = [[CPTBarPlot alloc]init];
    barPlot.barsAreHorizontal = YES;
    barPlot.barWidth = CPTDecimalFromFloat(0.618f);
    barPlot.lineStyle = barLineStyle;
    barPlot.barCornerRadius = 3.0f;
    barPlot.dataSource = self;
    barPlot.identifier = @"BarPlot";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
}
- (void)createBarChartInLandscapeView 
{

    // Create barChart from theme
    self.barChartViewLandscape = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(185.0f, 0.0f, 295.0f, 263.0f)];
    barChartViewLandscape.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    //barChartViewLandscape.allowPinchScaling = YES;
    [self.landscapeView addSubview:self.barChartViewLandscape];
    barChartLandscape = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
//	CPTTheme *barChartTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
//    [barChartLandscape applyTheme:barChartTheme];
	CPTGraphHostingView *barChartHostingView = (CPTGraphHostingView *)self.barChartViewLandscape;
    barChartHostingView.hostedGraph = barChartLandscape;
    
    // Border
    barChartLandscape.plotAreaFrame.borderLineStyle = nil;
    barChartLandscape.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChartLandscape.paddingLeft = 0.0f;
    barChartLandscape.paddingRight = 0.0f;
    barChartLandscape.paddingTop = 0.0f;
    barChartLandscape.paddingBottom = 0.0f;
	
    barChartLandscape.plotAreaFrame.paddingLeft = 50.0f;
	barChartLandscape.plotAreaFrame.paddingTop = 10.0f;
	barChartLandscape.plotAreaFrame.paddingRight = 20.0f;
	barChartLandscape.plotAreaFrame.paddingBottom = 10.0f;
	
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartLandscape.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:([barPlotData count]-1)]intValue]*1.2f+1.0)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(5.0f)];
    
    // Create grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0f;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.3];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 1.0f;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.15];
    
    
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChartLandscape.axisSet;
    CPTXYAxis *x = axisSet.yAxis;
    x.majorGridLineStyle = majorGridLineStyle;
    x.minorGridLineStyle = minorGridLineStyle;
    x.minorTicksPerInterval = 1;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    //x.labelOffset = 2.0f;
    //x.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(9.0f)];
    //x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(100.0f)];
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"-0.5");
	x.title = nil;//@"X Axis";
    //x.titleLocation = CPTDecimalFromFloat(5.0f);
	//x.titleOffset = 15.0f;
    
     // Define some custom labels for the data elements
     //x.labelRotation = M_PI/4;
     
    
     x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelOffset = -3.6f;

     NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:0.0f], [NSDecimalNumber numberWithFloat:1.0f], [NSDecimalNumber numberWithFloat:2.0f], [NSDecimalNumber numberWithFloat:3.0f],[NSDecimalNumber numberWithFloat:4.0f], nil];
     NSArray *xAxisLabels = [NSArray arrayWithObjects:@"暂停", @"处理", @"通话", @"振铃",@"空闲", nil];
     NSUInteger labelLocation = 0;
     self.customLabels = [[NSMutableArray alloc ]initWithCapacity:[xAxisLabels count]];
     for (NSNumber *tickLocation in customTickLocations) {
     CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
     newLabel.tickLocation = [tickLocation decimalValue];
     newLabel.offset = x.labelOffset + x.majorTickLength;
     //newLabel.rotation = M_PI/4;
     [customLabels addObject:newLabel];
     [newLabel release];
     }
    x.axisLabels =  [NSSet setWithArray:customLabels];
    
    
    CPTXYAxis *y = axisSet.xAxis;
    y.majorIntervalLength = CPTDecimalFromInteger(5);
    y.minorTicksPerInterval = 2;
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    //y.preferredNumberOfMajorTicks = 8;
    y.majorGridLineStyle = majorGridLineStyle;
    y.minorGridLineStyle = minorGridLineStyle;
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init]; 
    //[formatter setMaximumFractionDigits:0];  
    //y.labelFormatter = formatter; 
    //[formatter release];
    //y.labelFormatter = [[NSNumberFormatter alloc]init];
    y.labelOffset = 25.0f;
    //CPTMutableTextStyle *yAxisLabelTextStyle = [y.labelTextStyle mutableCopy];
    //yAxisLabelTextStyle.color = [CPTColor grayColor];
    //y.labelTextStyle = yAxisLabelTextStyle;
    //[yAxisLabelTextStyle release];
    //y.labelRotation = M_PI/2;
    //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.05f) length:CPTDecimalFromFloat(100.0f)];
    //y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
    //y.axisLineStyle = lineStyle;
    //y.majorTickLineStyle = lineStyle;
    //y.minorTickLineStyle = nil;
    y.majorIntervalLength = CPTDecimalFromString(@"10");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"50");
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	y.title = nil;//@"Y Axis";
	//y.titleOffset = 5.0f;
    //y.titleLocation = CPTDecimalFromFloat(150.0f);
	
    // bar plot
    // Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 2.5;
	barLineStyle.lineColor = [CPTColor blackColor];
    //barPlotLandscape = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlotLandscape = [[CPTBarPlot alloc]init];
    barPlotLandscape.barsAreHorizontal = YES;
    barPlotLandscape.lineStyle = barLineStyle;
	barPlotLandscape.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0f green:0.0f blue:0.5f alpha:0.5f]];
    //barPlotLandscape.baseValue = CPTDecimalFromString(@"0.5");
    barPlotLandscape.dataSource = self;
    //barPlotLandscape.barOffset = CPTDecimalFromFloat(0.5f);
    //barPlotLandscape.barLabelOffset = -10.0f ;
    barPlotLandscape.barWidth = CPTDecimalFromFloat(0.618f); // bar is 50% of the available space
	barPlotLandscape.barCornerRadius = 5.0f;
    barPlotLandscape.identifier = @"BarPlotLandscape";
    [barChartLandscape addPlot:barPlotLandscape toPlotSpace:plotSpace];
    
}

#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
        return [barPlotData count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
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


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
    //CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", index]];
    CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@",[barPlotData objectAtIndex:index]]];
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    textStyle.color = [CPTColor whiteColor];
    label.textStyle = textStyle;
    [textStyle release];
    return [label autorelease];
    
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    /*
    CPTColor *areaColor = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle = -90.0;
    CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
    return areaGradientFill;
     
     渐变1       #fc5165——#df2029
     渐变2       #e33bc1——#cb0a89
     渐变3       #f8b932——#e97122
     渐变4       #6de243——#137d08
     渐变5       #47ddee——#48b3e4
     */
    switch (index) {
        case 4:
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
        case 0:
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
        case 2:
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
#pragma mark - axis delegate
-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    return NO;
}
 */
#pragma mark - string format methods
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

/*
- (void)frontViewSelected
{
    NSLog(@"frontViewSelected");
    frontView.selected = YES;
}
 */
@end
