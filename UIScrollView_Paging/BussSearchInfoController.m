//
//  BussSearchInfoController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
#import "BussSearchInfoController.h"
#import "BSTableHeadView.h"

@implementation BussSearchInfoController
@synthesize addrPrefix;
@synthesize addrPostfix;
@synthesize bussinessInfoWebAddr,bussSearchInfoWebAddr,timer,cashDict_1, bussinessInfoDataDict,bussSearchInfoDataDict,bussSearchInfoDataDictArray,originView,landscapeView,tableViewPortrait;
@synthesize barChartViewLandscape,barChartLandscape,barPlotLandscape,barPlotData,pieChartViewLandscape,pieChartLandscape,piePlotLandscape,answerRatePersent;
@synthesize delegate,bussinessInfoCashResponseStr,bussSearchInfoCashResponseStr;
@synthesize loadingOrigin,loadingLandscape;
@synthesize ifLoading;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //tableViewPortrait=[[[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 200.0) style:UITableViewStyleGrouped] autorelease];
        tableViewPortrait.showsHorizontalScrollIndicator = NO;
        tableViewPortrait.showsVerticalScrollIndicator = NO;
        bussinessInfoCashResponseStr = [[NSString alloc]init ];
        bussSearchInfoCashResponseStr = [[NSString alloc]init];
        //self.tableViewPortrait.style=UITableViewCellSeparatorStyleSingleLine;
       // self.tableViewPortrait.delegate=self;
    }
    return self;
}

- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
    //self.bussinessInfoWebAddr = [[NSString alloc ]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/BussinessInfo.json"];
    //self.bussSearchInfoWebAddr = [[NSString alloc ]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/BussSearchInfo.json"];
    self.addrPrefix = newAddrPrefix;
    self.addrPostfix = newAddrPostfix;
    NSString *_addr1 = [[NSString alloc ]initWithFormat:@"%@BussinessInfo%@",addrPrefix,addrPostfix];
    self.bussinessInfoWebAddr = _addr1;
    [_addr1 release];
    NSString *_addr2 = [[NSString alloc ]initWithFormat:@"%@BussSearchInfo%@",addrPrefix,addrPostfix];
    self.bussSearchInfoWebAddr = _addr2;
    [_addr2 release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
   [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    [self setAddrWithAddrPrefix:newAddrPrefix AddrPostfix:newAddrPostfix];
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
- (void)dealloc
{

    [timer release];
    [originView release];
    [landscapeView release];
    [pieChartViewLandscape release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    refreshInterval = 60;
    loadingOrigin=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                   UIActivityIndicatorViewStyleWhiteLarge];
    loadingOrigin.center=CGPointMake(160,200);
    loadingLandscape=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                      UIActivityIndicatorViewStyleWhiteLarge];
    loadingLandscape.center=CGPointMake(240,110);
    [self createBarChartAndPiePlotInLandscapeView];
    ifLoading=YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.originView = nil;
    self.landscapeView = nil;
    self.tableViewPortrait = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - data update methods

- (void)dataUpdateStart
{
    if (timer == nil) {
        [self requestData];
        
        self.timer=[NSTimer scheduledTimerWithTimeInterval:refreshInterval//定时器间隔
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
    
    ASIHTTPRequest *bussinessInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:bussinessInfoWebAddr]];
    [bussinessInfoRequest setDelegate:self];
    [bussinessInfoRequest startAsynchronous];
    
    ASIHTTPRequest *bussSearchInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:bussSearchInfoWebAddr]];
    [bussSearchInfoRequest setDelegate:self];
    [bussSearchInfoRequest startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{

    requestFailedCount = 0;
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];    
    if ([request.url.absoluteString isEqualToString:bussinessInfoWebAddr]) 
    {
        if (![bussinessInfoCashResponseStr isEqualToString:responseString]) {
            ordercntNum = 0;
            cuscompcntNum = 0;
            sitcompcntNum = 0;
            searchcntNum = 0;
            NSArray *tmpArray = [responseString JSONValue];
            self.bussinessInfoCashResponseStr = responseString;
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {
                for (NSDictionary* anyDic in tmpArray) {
                    ordercntNum += [[anyDic objectForKey:@"ordercnt"]intValue];
                    cuscompcntNum += [[anyDic objectForKey:@"cuscompcnt"]intValue];
                    sitcompcntNum += [[anyDic objectForKey:@"sitcompcnt"]intValue];
                    searchcntNum += [[anyDic objectForKey:@"searchcnt"]intValue];
                }
            }
            if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage: WithMessage:)]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                NSString *timeString=[formatter stringFromDate: [NSDate date]];
                [formatter release];
                [delegate willInfoBoardUpdateUIOnPage:1 WithMessage:timeString];
            }
            self.view == originView?[self updateOriginView:request]:[self updateLandscapeView:request];
            
        }
    }
    else if ([request.url.absoluteString isEqualToString:bussSearchInfoWebAddr])
    {
        if (![bussSearchInfoCashResponseStr isEqualToString:responseString]) {
            NSArray *tmpArray = [responseString JSONValue];
            
            self.bussSearchInfoCashResponseStr = responseString;
            NSMutableDictionary *_dict = [[NSMutableDictionary alloc]init];
            self.bussSearchInfoDataDict = _dict;
            [_dict release];
            maxSearchNum = 0;
            
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {            
                for (NSDictionary *anyDict in tmpArray) {
                NSString *searchType = [[NSString alloc]initWithString:[anyDict objectForKey:@"searchtype"]];
                NSInteger newNum = ([bussSearchInfoDataDict objectForKey:searchType])?([[[bussSearchInfoDataDict objectForKey:searchType]objectForKey:@"value"] intValue]+[[anyDict objectForKey:@"cnt"] intValue]):[[anyDict objectForKey:@"cnt"] intValue];
                NSNumber *newNumber = [[NSNumber alloc]initWithInt:newNum];
                maxSearchNum = maxSearchNum>newNum?maxSearchNum:newNum;
                NSDictionary *searchTypeValue = [[NSDictionary alloc]initWithObjectsAndKeys:searchType,@"searchType",newNumber,@"value", nil];
                [bussSearchInfoDataDict setObject:searchTypeValue forKey:searchType];
                [newNumber release];
                [searchType release];
                [searchTypeValue release];
            }
        }
            self.bussSearchInfoDataDictArray = [[bussSearchInfoDataDict allValues]sortedArrayUsingSelector:@selector(myCompareMethodWithDict:)];                
            if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:WithMessage:)]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                NSString *timeString=[formatter stringFromDate: [NSDate date]];
                [formatter release];
                [delegate willInfoBoardUpdateUIOnPage:1 WithMessage:timeString];;
            }
            if (ifLoading==NO){
                [self hideWaiting];
            }
            self.view == originView?[self updateOriginView:request]:[self updateLandscapeView:request];
        }
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

#pragma mark - UI Updata Methods

/*
[{"SearchType":"","Cnt":97},{"SearchType":"","Cnt":243},{"SearchType":"OA投诉","Cnt":70},{"SearchType":"催件","Cnt":1254},{"SearchType":"改地址","Cnt":207},{"SearchType":"理赔","Cnt":5},{"SearchType":"破损、遗失","Cnt":24},{"SearchType":"其他","Cnt":36},{"SearchType":"退件","Cnt":153},{"SearchType":"正常查单","Cnt":479}]
 */

- (void)createBarChartAndPiePlotInLandscapeView 
{
    // Create barChart from theme
    barChartViewLandscape = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(0.0, 0.0, 183.0, 263.0)];
    barChartViewLandscape.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [self.landscapeView addSubview:self.barChartViewLandscape];
    barChartLandscape = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	//CPTTheme *barChartTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //[barChartLandscape applyTheme:barChartTheme];
	CPTGraphHostingView *barChartHostingView = (CPTGraphHostingView *)self.barChartViewLandscape;
    barChartHostingView.hostedGraph = barChartLandscape;
    
    // Border
    barChartLandscape.plotAreaFrame.borderLineStyle = nil;
    barChartLandscape.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChartLandscape.paddingLeft = 0.0f;
    barChartLandscape.paddingRight = 0.0f;
    barChartLandscape.paddingTop = 10.0f;
    barChartLandscape.paddingBottom = 0.0f;
	
    barChartLandscape.plotAreaFrame.paddingLeft = 10.0;
	barChartLandscape.plotAreaFrame.paddingTop = 10.0;
	barChartLandscape.plotAreaFrame.paddingRight = 10.0;
	barChartLandscape.plotAreaFrame.paddingBottom = 36.0;
    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
    barChartLandscape.titleTextStyle=whiteText;
    barChartLandscape.title=@"业务数据";
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
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:2]intValue]*1.2f+1.0)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(3.0f)];
    
    // Create grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0f;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.3];
    
    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 1.0f;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.15];    
    
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
	//x.title = nil;//@"X Axis";
    //x.titleLocation = CPTDecimalFromFloat(5.0f);
	//x.titleOffset = 15.0f;
	
   
     // Define some custom labels for the data elements
     //x.labelRotation = M_PI/4;
     x.labelingPolicy = CPTAxisLabelingPolicyNone;
     x.labelOffset = 5.0f;
     CPTMutableTextStyle *xLabelTextStyle = [CPTTextStyle textStyle];
     xLabelTextStyle.color = [CPTColor whiteColor];
     xLabelTextStyle.fontSize = 11.0f;
     xLabelTextStyle.textAlignment = CPTTextAlignmentRight;
     x.labelTextStyle = xLabelTextStyle;
     NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:0.0f], [NSDecimalNumber numberWithFloat:1.0f], [NSDecimalNumber numberWithFloat:2.0f], nil];
     NSArray *xAxisLabels = [NSArray arrayWithObjects:@"下单量", @"投诉量", @"查单量", nil];
     NSUInteger labelLocation = 0;
     NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
     for (NSNumber *tickLocation in customTickLocations) {
     CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
     newLabel.tickLocation = [tickLocation decimalValue];
     newLabel.offset = x.labelOffset + x.majorTickLength;
     //newLabel.rotation = M_PI/4;
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
    y.minorTicksPerInterval = 2;
	y.title = nil;
	
    // First bar plot
    CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor blackColor];
    barPlotLandscape = [[CPTBarPlot alloc]init];
    barPlotLandscape.lineStyle = barLineStyle;
    barPlotLandscape.labelOffset = 0.2f;
    barPlotLandscape.barWidth = CPTDecimalFromFloat(0.618f);
    //barPlotLandscape.baseValue = CPTDecimalFromString(@"0.1");
    barPlotLandscape.barCornerRadius = 5.0f;
    barPlotLandscape.dataSource = self;
    //barPlot.barOffset = CPTDecimalFromFloat(0.5f);
    barPlotLandscape.identifier = @"BarPlotLandscape";
    [barChartLandscape addPlot:barPlotLandscape toPlotSpace:plotSpace];
    
    
    //pieChart
    pieChartViewLandscape = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(187.0,0.0,293.0,263.0)];
    pieChartViewLandscape.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    [self.landscapeView addSubview:self.pieChartViewLandscape];
    pieChartLandscape = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
//	CPTTheme *pieChartTheme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
//    [pieChartLandscape applyTheme:pieChartTheme];
	CPTGraphHostingView *pieChartHostingView = (CPTGraphHostingView *)self.pieChartViewLandscape;
    pieChartHostingView.hostedGraph = pieChartLandscape;
	
    pieChartLandscape.paddingLeft = 0.0f;
	pieChartLandscape.paddingTop = 0.0f;
	pieChartLandscape.paddingRight = 0.0f;
	pieChartLandscape.paddingBottom = 0.0f;
	pieChartLandscape.axisSet = nil;
    pieChartLandscape.plotAreaFrame.cornerRadius = 0.0f;	
    
    //pieChartLandscape.titleTextStyle.color = [CPTColor whiteColor];
    //pieChartLandscape.title = @"查单量";
    pieChartLandscape.titleDisplacement = CGPointMake(-100.0f, -20.0f);
    
    
    // Add pie chart
    self.piePlotLandscape = [[CPTPieChart alloc] init];
    piePlotLandscape.dataSource = self;
	piePlotLandscape.pieRadius = 80.0f;
    piePlotLandscape.identifier = @"PiePlotLandscape";
	piePlotLandscape.startAngle = M_PI_2;
    piePlotLandscape.labelOffset = -40.0f;
	piePlotLandscape.sliceDirection = CPTPieDirectionCounterClockwise;
	piePlotLandscape.centerAnchor = CGPointMake(0.5, 0.5);
	piePlotLandscape.borderLineStyle = [CPTLineStyle lineStyle];
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
}

- (void)updateOriginView:(ASIHTTPRequest *)request
{
    [tableViewPortrait reloadData];
}

- (void)updateLandscapeView:(ASIHTTPRequest *)request
{
    self.barPlotData = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:ordercntNum],
                        [NSNumber numberWithInt:cuscompcntNum+sitcompcntNum],
                        [NSNumber numberWithInt:searchcntNum],
                        nil ];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartLandscape.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:2]intValue]*1.2f+1.0)];
    NSString *newPieTitle = [[NSString alloc]initWithFormat:@"查单量:%d",searchcntNum];
    pieChartLandscape.title = newPieTitle;
    CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
    pieChartLandscape.titleTextStyle=whiteText;
    [newPieTitle release];
    [barPlotLandscape reloadData];
    [pieChartLandscape reloadData];
}

- (void)cleanUI
{
    ordercntNum = 0;
    cuscompcntNum = 0;
    sitcompcntNum = 0;
    searchcntNum = 0;
    self.bussSearchInfoDataDictArray = nil;
    [tableViewPortrait reloadData];
    
}

#pragma mark - UITableView DataSource Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return [bussSearchInfoDataDictArray count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BussCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor=[UIColor clearColor];
//        CVTableCellBGView *bgView = [[CVTableCellBGView alloc] init];
//        bgView.cellStyle = CellStyleMiddle;
//        bgView.gradientColor = GradientColorBlack;
//        [cell setBackgroundView:bgView];
//        [bgView release];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor=[UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.detailTextLabel.backgroundColor=[UIColor clearColor];
        cell.textLabel.font=[UIFont systemFontOfSize:18];
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"下单量"];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[bussinessInfoDataDict objectForKey:@"OrderCnt"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:ordercntNum];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"投诉量"];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",([[bussinessInfoDataDict objectForKey:@"CusCompCnt"] intValue]+[[bussinessInfoDataDict objectForKey:@"SitCompCnt"]intValue])];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:(cuscompcntNum+sitcompcntNum)];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"查单量"];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[bussinessInfoDataDict objectForKey:@"SearchCnt"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:searchcntNum];
                    break;
                default:
                    break;
            }
            break;
        case 1:
        {
            /*
            NSString *searchType = [[NSString alloc]initWithString:[[bussSearchInfoDataDictKeys sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:indexPath.row]];
            cell.textLabel.text = [searchType isEqualToString:@""]?@"暂无分类":searchType;
            cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[bussSearchInfoDataDict objectForKey:searchType] intValue]];
            [searchType release];*/
            NSDictionary *search = [[bussSearchInfoDataDictArray objectAtIndex:indexPath.row]retain];
            cell.textLabel.text = [[search objectForKey:@"searchType"] isEqualToString:@""]?@"暂无分类":[search objectForKey:@"searchType"];
            cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[search objectForKey:@"value"]intValue]];
            [search release];
            break;
        }
        default:
            break;
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [[[BSTableHeadView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0,30.0) headStr:@"   业务数据（个）"] autorelease];
        case 1:
            return [[[BSTableHeadView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0,30.0) headStr:@"   查单分类统计（个）"] autorelease];
        default:
            return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"业务数据(个)"];
        case 1:
            return [NSString stringWithFormat:@"查单分类统计(个)"];
        default:
            return nil;
    }
}*/

#pragma mark - core plot 
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    if ([plot.identifier isEqual:@"BarPlotLandscape"])
    {
        return [barPlotData count];
    }
    else
    {
        //return [answerRatePersent count];
         return [bussSearchInfoDataDictArray count];
    }
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    if([plot.identifier isEqual:@"BarPlotLandscape"])
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
        if ( index >= [bussSearchInfoDataDictArray count] ) return nil;
        
        if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
            //return [bussSearchInfoDataDict objectForKey:[[bussSearchInfoDataDictKeys sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:index]];
            return [bussSearchInfoDataDictArray objectAtIndex:index];
        }
        else {
            return [NSNumber numberWithInt:index];
        }
    }
    
}


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
    if([plot.identifier isEqual:@"BarPlotLandscape"])
    {
        //CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%lu", index]];
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@",[barPlotData objectAtIndex:index]]];
        CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
        textStyle.color = [CPTColor whiteColor];
        label.textStyle = textStyle;
        [textStyle release];
        return [label autorelease];
    }
	else
    {   /*
        NSArray *array = [NSArray arrayWithObjects:[NSString stringWithFormat:@"少于5秒"],[NSString stringWithFormat:@"5 - 10秒"],[NSString stringWithFormat:@"10-15秒"],[NSString stringWithFormat:@"多于15秒"], nil];
    
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@   \n   %0.1f%%",[array objectAtIndex:index],[[answerRatePersent objectAtIndex:index]floatValue]*100]];
        CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
        textStyle.color = [CPTColor whiteColor];
        label.textStyle = textStyle;
        [textStyle release];
        return [label autorelease];
         */
        CPTTextLayer *label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d",[[[bussSearchInfoDataDictArray objectAtIndex:index]objectForKey:@"value"]intValue]]];
        CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
        textStyle.color = [CPTColor whiteColor];
        label.textStyle = textStyle;
        [textStyle release];
        return [label autorelease];
    }
    
}

/*
 -(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
 {
 //return ( index == 0 ? 30.0f : 0.0f );
 return 0.0f;
 }
 */

/*-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index; 
 {
 return nil;
 }*/
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
    switch (index%4) {
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

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    //return ( index == 0 ? 30.0f : 0.0f );
    return 5.0f+50.0f*pow((1.0f-[[[bussSearchInfoDataDictArray objectAtIndex:index]objectForKey:@"value"] floatValue]/maxSearchNum),4.0f);
}
#pragma mark - UITableViewDelegate Methods
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
