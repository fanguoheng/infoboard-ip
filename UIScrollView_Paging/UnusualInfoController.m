//
//  UnusualInfoController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
#import "UnusualInfoController.h"
#import "UnUsualRootTableViewController.h"
#import "UnUsualLeafTableViewController.h"
@implementation UnusualInfoController

@synthesize navController,rootTableViewController,leafTableViewController;
@synthesize webAddr,rootWebAddr, leafVeryBadWebAddr,leafBadWebAddr,leafAgtLostWebAddr,timer,refreshInterval,dataDictArray,originView,landscapeView,controlPadView,refreshIntervalSlider,refreshIntervalLabel,pauseOrStartButton;
@synthesize barChartViewLandscape,barChartLandscape,barPlotLandscape,barPlotData;
@synthesize addrPrefix,addrPostfix;
@synthesize delegate,cashResponseStr;
@synthesize loadingOrigin,loadingLandscape;
@synthesize ifLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cashResponseStr = [[NSString alloc]init];
        //navController.delegate = self;
        UnUsualRootTableViewController *_rootTableViewController = [[UnUsualRootTableViewController alloc]initWithStyle:UITableViewStylePlain dataDictArray:nil delegate:self];
        self.rootTableViewController = _rootTableViewController;
        [_rootTableViewController release];
        
        UnUsualLeafTableViewController *_unUsualLeafVeryBadTableViewController = [[UnUsualLeafTableViewController alloc ]initWithStyle:UITableViewStylePlain dataDictArray:nil Tag:0];
        self.leafTableViewController = _unUsualLeafVeryBadTableViewController;
        [_unUsualLeafVeryBadTableViewController release];
    }
    return self;
}

- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    
    self.addrPrefix = addrPrefixSet;
    self.addrPostfix = addrPostfixSet;
    NSString *_addr0 = [[NSString alloc ]initWithFormat:@"%@UnusualInfo%@",addrPrefix,addrPostfix];
    self.rootWebAddr = _addr0;
    [_addr0 release];
    NSString *_addr1 = [[NSString alloc]initWithFormat:@"%@SvrDefineInfo%@",addrPrefix,addrPostfix];
    self.leafVeryBadWebAddr = _addr1;
    [_addr1 release];
    NSString *_addr2 = [[NSString alloc]initWithFormat:@"%@SvrDefineInfo%@",addrPrefix,addrPostfix];
    self.leafBadWebAddr = _addr2;
    [_addr2 release];
    NSString *_addr3 = [[NSString alloc]initWithFormat:@"%@AgtLostInfo%@",addrPrefix,addrPostfix];   
    self.leafAgtLostWebAddr = _addr3;
    [_addr3 release];

    self.webAddr = rootWebAddr;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setAddrWithAddrPrefix:addrPrefixSet AddrPostfix:addrPostfixSet];
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
    [rootTableViewController release];
    [leafTableViewController release];
    [timer release];
    [webAddr release];
    [dataDictArray release];
    [originView release];
    [landscapeView release];
    [controlPadView release];
    [refreshIntervalSlider release];
    [refreshIntervalLabel release];
    [barChartViewLandscape release];
    [cashResponseStr release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //firstLoad = YES;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
    if (df) {  
        refreshInterval = [[df objectForKey:@"unusualInfoInterval"]intValue];
    }
    if(0 == refreshInterval)
    {
        refreshInterval = 60;
    }
    [controlPadView setFrame:CGRectMake(0.0f, 30.0f, 320.0f, 44.0f)];
    
    UINavigationController *_navController = [[UINavigationController alloc]initWithRootViewController:rootTableViewController];
    self.navController = _navController;
    [_navController release];
    navController.delegate = self;
    //[navController.navigationBar setFrame:CGRectMake(navController.navigationBar.frame.origin.x, navController.navigationBar.frame.origin.x, navController.navigationBar.frame.size.width, navController.navigationBar.frame.size.height*0.618f)];
    navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [navController.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 385.0f)];
    [self.view addSubview:navController.view];
    
    UIImage *pauseImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"media-playback-pause" ofType:@"png"]];
    [pauseOrStartButton setImage:pauseImage forState:UIControlStateNormal];
    UIImage *startImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"media-playback-start" ofType:@"png"]];
    [pauseOrStartButton setImage:startImage forState:UIControlStateSelected];
    
    [self createBarChartInLandscapeView];
    loadingOrigin=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                   UIActivityIndicatorViewStyleWhiteLarge];
    loadingOrigin.center=CGPointMake(160,200);
    loadingLandscape=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:
                      UIActivityIndicatorViewStyleWhiteLarge];
    loadingLandscape.center=CGPointMake(240,110);
    ifLoading=YES;  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navController = nil;
    self.originView = nil;
    self.landscapeView = nil;
    self.controlPadView = nil;
    self.refreshIntervalSlider = nil;
    self.refreshIntervalLabel = nil;
    self.pauseOrStartButton = nil;
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
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:webAddr]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];  
    if (![cashResponseStr isEqualToString:responseString]) {
        NSMutableArray *tmpArray = [responseString JSONValue];
        if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]]) {
            if ([request.url.absoluteString isEqualToString:rootWebAddr])
            {
                self.cashResponseStr = responseString; 
                veryBadNum = 0;
                badNum = 0;
                lostCntNum = 0;
                agtCntNum = 0;
                agtLostNum = 0;
                cusLostNum = 0;
                sysLostNum = 0;
                offLostNum = 0;
                othLostNum = 0;
                waitDurSecondNum = 0;
                for (NSDictionary* anyDict in tmpArray) {
                    veryBadNum = veryBadNum+[[anyDict objectForKey:@"verybad"] intValue];
                    badNum = badNum+[[anyDict objectForKey:@"bad"] intValue];
                    lostCntNum = lostCntNum+[[anyDict objectForKey:@"lostcnt"] intValue];
                    float lostRate = [[anyDict objectForKey:@"lostrate"] floatValue];
                    if (0.0f!=lostRate) {
                        agtCntNum +=  [[anyDict objectForKey:@"lostcnt"] intValue]/lostRate;
                    }
                    agtLostNum += [[anyDict objectForKey:@"agtlost"] intValue];
                    cusLostNum += [[anyDict objectForKey:@"cuslost"] intValue];
                    sysLostNum += [[anyDict objectForKey:@"syslost"] intValue];
                    offLostNum += [[anyDict objectForKey:@"offlost"] intValue];
                    othLostNum += [[anyDict objectForKey:@"othlost"] intValue];
                    waitDurSecondNum += [[anyDict objectForKey:@"waitdur"]intValue]*[[anyDict objectForKey:@"cuslost"] intValue];
                }
                NSDictionary *tmpDict = [[NSDictionary alloc ]initWithObjectsAndKeys:[NSNumber numberWithInt:veryBadNum] ,@"verybad",[NSNumber numberWithInt:badNum] ,@"bad",[NSNumber numberWithInt:lostCntNum] ,@"lostcnt",[NSNumber numberWithInt:agtLostNum] ,@"agtlost",[NSNumber numberWithFloat:(agtCntNum?((float)lostCntNum/(float)agtCntNum):0.0f)] ,@"lostrate",[NSNumber numberWithInt:cusLostNum] ,@"cuslost",[NSNumber numberWithInt:sysLostNum] ,@"syslost",[NSNumber numberWithInt:offLostNum] ,@"offlost",[NSNumber numberWithInt:othLostNum] ,@"othlost", nil];
                NSArray *tmpDictArray = [[NSArray alloc]initWithObjects:tmpDict, nil];
                [tmpDict release];
                self.dataDictArray = tmpDictArray;
                [tmpDictArray release];
                [rootTableViewController setDataDictArray:dataDictArray];
                
                if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:)]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YY-MM-dd hh:mm:ss"];
                    NSString *timeString=[formatter stringFromDate: [NSDate date]];
                    [formatter release];
                    [delegate willInfoBoardUpdateUIOnPage:timeString];
                }
            }
            else if([request.url.absoluteString isEqualToString:leafVeryBadWebAddr] || [request.url.absoluteString isEqualToString:leafBadWebAddr])
            {
                NSMutableArray *veryBadDictArray = [[NSMutableArray alloc]init];
                NSMutableArray *badDictArray = [[NSMutableArray alloc]init];
                for (NSDictionary* anyDict in tmpArray) {
                    (5 == [[anyDict objectForKey:@"def"]intValue])?[veryBadDictArray addObject:anyDict]:nil;
                    (4 == [[anyDict objectForKey:@"def"]intValue])?[badDictArray addObject:anyDict]:nil;
                }
                NSArray *tmpDictArray = [[NSArray alloc]initWithObjects:veryBadDictArray,badDictArray, nil];
                [veryBadDictArray release];
                [badDictArray release];
                self.dataDictArray = tmpDictArray;
                [tmpDictArray release];
                [leafTableViewController setDataDictArray:dataDictArray];
            }
            else if([request.url.absoluteString isEqualToString:leafAgtLostWebAddr])
            {
                self.dataDictArray = tmpArray;
                [leafTableViewController setDataDictArray:dataDictArray];
            }
            if (ifLoading==NO){
                [self hideWaiting];
                //NSLog(@"hideWating");
            }
            NSLog(@"%d ifLoading in requestFinishded",ifLoading);
            self.view == originView?[self updateOriginView:request]:[self updateLandscapeView:request];
        }
    }
    [responseString release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    //NSError *error = [request error];
}

#pragma mark - UI Updata Methods
- (void)createBarChartInLandscapeView 
{
    
    // Create barChart from theme
    barChartViewLandscape = [[CPTGraphHostingView alloc] initWithFrame:CGRectMake(185, 0, 295, 274)];
    barChartViewLandscape.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin;
    //barChartViewLandscape.allowPinchScaling = YES;
    [self.landscapeView addSubview:self.barChartViewLandscape];
    barChartLandscape = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	CPTTheme *barChartTheme = [CPTTheme themeNamed:kCPTStocksTheme];
    [barChartLandscape applyTheme:barChartTheme];
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
	
    barChartLandscape.plotAreaFrame.paddingLeft = 15.0f;
	barChartLandscape.plotAreaFrame.paddingTop = 10.0f;
	barChartLandscape.plotAreaFrame.paddingRight = 15.0f;
	barChartLandscape.plotAreaFrame.paddingBottom = 25.0f;
    
    // Graph title
    //barChartLandscape.title = @"客户满意度";
    //CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    //textStyle.color = [CPTColor whiteColor];
    //textStyle.fontSize = 16.0f;
	//textStyle.textAlignment = CPTTextAlignmentCenter;
    //barChartLandscape.titleTextStyle = textStyle;
    //barChartLandscape.titleDisplacement = CGPointMake(0.0f, -20.0f);
    //barChartLandscape.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartLandscape.defaultPlotSpace;
    //plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(90.0f)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:([barPlotData count]-1)]intValue]*1.2f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(5.0f)];
    
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
    //x.labelOffset = 2.0f;
    /*
     x.axisLabels = [NSSet setWithObjects:[[CPTAxisLabel alloc]initWithText:@"呼入" textStyle:[CPTTextStyle textStyle]],
     [[CPTAxisLabel alloc]initWithText:@"呼出" textStyle:[CPTTextStyle textStyle]],
     [[CPTAxisLabel alloc]initWithText:@"排队" textStyle:[CPTTextStyle textStyle]],
     [[CPTAxisLabel alloc]initWithText:@"暂停" textStyle:[CPTTextStyle textStyle]],
     [[CPTAxisLabel alloc]initWithText:@"振铃" textStyle:[CPTTextStyle textStyle]],
     [[CPTAxisLabel alloc]initWithText:@"空闲" textStyle:[CPTTextStyle textStyle]],
     [[CPTAxisLabel alloc]initWithText:@"通话" textStyle:[CPTTextStyle textStyle]],
     [[CPTAxisLabel alloc]initWithText:@"处理" textStyle:[CPTTextStyle textStyle]],
     nil];
     */
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
    /*
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
    
    CPTXYAxis *y = axisSet.yAxis;
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
    y.labelOffset = 50.0f;
    //CPTMutableTextStyle *yAxisLabelTextStyle = [y.labelTextStyle mutableCopy];
    //yAxisLabelTextStyle.color = [CPTColor lightGrayColor];
    //y.labelTextStyle = yAxisLabelTextStyle;
    //[yAxisLabelTextStyle release];
    //y.labelRotation = M_PI/2;
    //y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.05f) length:CPTDecimalFromFloat(100.0f)];
    //y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
    //y.axisLineStyle = lineStyle;
    //y.majorTickLineStyle = lineStyle;
    //y.minorTickLineStyle = nil;
    //y.majorIntervalLength = CPTDecimalFromString(@"10");
    //y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
	y.title = nil;//@"Y Axis";
	//y.titleOffset = 5.0f;
    //y.titleLocation = CPTDecimalFromFloat(150.0f);
	
    // bar plot
    // Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor blackColor];
    //barPlotLandscape = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlotLandscape = [[CPTBarPlot alloc]init];
    //barPlotLandscape.barsAreHorizontal = YES;
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

- (void)updateOriginView:(ASIHTTPRequest*)request
{
    if (!request) {
        //当nil==request时强制更新全部竖屏UI
        [[(id)[navController topViewController] tableView] reloadData];
    }
    else if ( [request.url.absoluteString isEqualToString:rootWebAddr])
    {

        [[rootTableViewController tableView]reloadData];
    }
    else if([request.url.absoluteString isEqualToString:leafVeryBadWebAddr])
    {
        [[leafTableViewController tableView]reloadData];
    }
    else if([request.url.absoluteString isEqualToString:leafBadWebAddr])
    {
        [[leafTableViewController tableView]reloadData];
    }
    else if([request.url.absoluteString isEqualToString:leafAgtLostWebAddr])
    {
        [[leafTableViewController tableView]reloadData];
    }
}

- (void)updateLandscapeView:(ASIHTTPRequest *)request
{
    if ([[navController topViewController] isMemberOfClass:[UnUsualRootTableViewController class]]) 
    {
        veryBadNum = 0;
        badNum = 0;
        lostCntNum = 0;
        agtLostNum = 0;
        cusLostNum = 0;
        sysLostNum = 0;
        offLostNum = 0;
        othLostNum = 0;
        for (NSDictionary* anyDict in dataDictArray) {
            veryBadNum = veryBadNum+[[anyDict objectForKey:@"verybad"] intValue];
            badNum = badNum+[[anyDict objectForKey:@"bad"] intValue];
            lostCntNum += [[anyDict objectForKey:@"lostcnt"] intValue];
            agtLostNum += [[anyDict objectForKey:@"agtlost"] intValue];
            cusLostNum += [[anyDict objectForKey:@"cuslost"] intValue];
            sysLostNum += [[anyDict objectForKey:@"syslost"] intValue];
            offLostNum += [[anyDict objectForKey:@"offlost"] intValue];
            othLostNum += [[anyDict objectForKey:@"othlost"] intValue];
        }
        self.barPlotData = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:agtLostNum],
                            [NSNumber numberWithInt:cusLostNum],
                            [NSNumber numberWithInt:sysLostNum],
                            [NSNumber numberWithInt:offLostNum],
                            [NSNumber numberWithInt:othLostNum],
                            nil];
        
        CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChartLandscape.defaultPlotSpace;
        @try{plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat([[[barPlotData sortedArrayUsingSelector:@selector(compare:)]objectAtIndex:([barPlotData count]-1)]intValue]*1.2f)];}
        @catch (NSException *e) {
        }
        [barPlotLandscape reloadData];
    }

}

- (void)cleanUI
{
    self.dataDictArray = nil;
    [[(id)[navController topViewController] tableView] reloadData];
    
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"touched");
    if ([[navController topViewController] isMemberOfClass:[UnUsualRootTableViewController class]]) {
        switch (indexPath.section) {
            case 0:
                navController.navigationBar.backItem.title = @"返回";
                switch (indexPath.row) {
                    case 0:
                    {
                        self.webAddr = leafVeryBadWebAddr;
                        leafTableViewController.view.tag =  UnUsualLeafTableViewControllerSituationVeryBad;
                        [navController pushViewController:leafTableViewController animated:YES];
                        leafTableViewController.sectionVeryBadOpend = YES;
                        leafTableViewController.sectionBadOpend = NO;
                        navController.navigationBar.topItem.title = @"客户差评详情";
                        break;
                    }

                    case 1:
                    {
                        self.webAddr = leafBadWebAddr;
                        leafTableViewController.view.tag =  UnUsualLeafTableViewControllerSituationBad;
                        [navController pushViewController:leafTableViewController animated:YES];
                        leafTableViewController.sectionVeryBadOpend = NO;
                        leafTableViewController.sectionBadOpend = YES;
                        navController.navigationBar.topItem.title = @"客户差评详情";
                    }
                    default:
                        break;
                }
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:
                    {
                        self.webAddr = leafAgtLostWebAddr;
                        leafTableViewController.view.tag =  UnUsualLeafTableViewControllerSituationAgtLost;
                        [navController pushViewController:leafTableViewController animated:YES];
                        navController.navigationBar.topItem.title = @"座席主动放弃";
                        navController.navigationBar.backItem.title = @"返回";
                        break;
                    }
                        
                    case 1:
                    {
                        NSString *messageShow = [[NSString alloc]initWithFormat:@"挂机客户平均等待时长%0.1f秒", (float)waitDurSecondNum/(float)cusLostNum];
                        
                        UIAlertView *alertView = [[UIAlertView alloc ]initWithTitle:@"详情" message:messageShow delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        
                        [alertView show];
                        [alertView release];
                        [messageShow release];
                         
                        break;
                    }
                    default:
                        break;
                }
                break;
                
            default:
                break;
    }

    }
}
#pragma mark - core plot 

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
        case 0:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xdf/255.0f green:0x20/255.0f  blue:0x29/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xfc/255.0f green:0x51/255.0f  blue:0x56/255.0f  alpha:1.0f];
            //CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 1:
        {
            CPTColor *areaColor =  [CPTColor colorWithComponentRed:0xcb/255.0f  green:0x0a/255.0f  blue:0x89/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xe3/255.0f green:0x3b/255.0f  blue:0xc1/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 2:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xc9/255.0f  green:0x71/255.0f  blue:0x22/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xf8/255.0f green:0xb9/255.0f  blue:0x32/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 3:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0x13/255.0f  green:0x7d/255.0f  blue:0x08/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0x6d/255.0f green:0xe2/255.0f  blue:0x43/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 4:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xdf/255.0f green:0x20/255.0f  blue:0x29/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xfc/255.0f green:0x51/255.0f  blue:0x56/255.0f  alpha:1.0f];
            //CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 5:
        {
            CPTColor *areaColor =  [CPTColor colorWithComponentRed:0xcb/255.0f  green:0x0a/255.0f  blue:0x89/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xe3/255.0f green:0x3b/255.0f  blue:0xc1/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 6:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0xc9/0255.0f green:0x71/255.0f  blue:0x22/255.0f  alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0xf8/255.0f green:0xb9/255.0f  blue:0x32/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        case 7:
        {
            CPTColor *areaColor = [CPTColor colorWithComponentRed:0x13/255.0f green:0x7d/255.0f  blue:0x08/255.0f alpha:0.7f];
            CPTColor *areaColor_2 = [CPTColor colorWithComponentRed:0x6d/255.0f green:0xe2/255.0f  blue:0x43/255.0f  alpha:1.0f];
            CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:areaColor_2];
            areaGradient.angle = -90.0;
            CPTFill* areaGradientFill = [CPTFill fillWithGradient:areaGradient];
            return areaGradientFill;
        }
        default:
            return nil;
    }
    
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == rootTableViewController) {
        //NSString *rootWebAddr = [[NSString alloc ]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/UnusualInfo.json"];
        //NSString *rootWebAddr = [[NSString alloc ]initWithFormat:@"%@UnusualInfo%@",addrPrefix,addrPostfix];
        self.webAddr = rootWebAddr;
        [navController setNavigationBarHidden:YES animated:NO];
        //firstLoad?nil:[self dataUpdateStart];
    }
    else
    {
        [navController setNavigationBarHidden:NO animated:NO];
        [leafTableViewController setDataDictArray:nil];
        [leafTableViewController.tableView reloadData];
        navController.navigationBar.topItem.leftBarButtonItem.title = @"返回";
        [self requestData];
        self.webAddr = rootWebAddr;
        //[self dataUpdatePause];
    }
    //firstLoad = NO;

}

#pragma mark - touch and controlPad
- (IBAction)showControlPadView:(id)sender
{
    UIButton *tietleButton = (UIButton *)sender;
    tietleButton.selected = !tietleButton.selected;
    if(tietleButton.selected)
    {
        /*
         CATransition *animation = [CATransition animation];
         animation.duration = 1.0f;
         animation.timingFunction = UIViewAnimationCurveEaseInOut;
         //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade渐渐消失;kCATransitionMoveIn覆盖进入;kCATransitionPush推出;kCATransitionReveal与MoveIn相反;
         animation.type = kCATransitionFade;
         //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
         animation.subtype = kCATransitionFromBottom;
         */
        //[self.controlPadView.layer addAnimation:animation forKey:@"animationAppear"];
        
        refreshIntervalSlider.value = refreshInterval;
        NSString *refreshIntervalStr = [[NSString alloc]initWithFormat:@"%d", refreshInterval];
        refreshIntervalLabel.text = refreshIntervalStr;
        [refreshIntervalStr release];
        //[controlPadView setFrame:CGRectMake(0.0f, 30.0f, 320.0f, 44.0f)];
        [self.view addSubview:controlPadView];
    }
    else
    {
        /*
         CATransition *animation = [CATransition animation];
         animation.duration = 0.5f;
         animation.timingFunction = UIViewAnimationCurveEaseInOut;
         //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
         animation.type = kCATransitionMoveIn;
         //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
         animation.subtype = kCATransitionFromTop; 
         [self.controlPadView.layer addAnimation:animation forKey:@"animationDissappear"];
         */
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
        if (df) {  
            NSNumber *_refreshInterval = [[NSNumber alloc]initWithInt:refreshInterval];
            [df setObject:_refreshInterval forKey:@"unusualInfoInterval"]; 
            [_refreshInterval release];
            [df synchronize];  
        }  
        [controlPadView removeFromSuperview];
    }
}

- (IBAction)sliderChanged:(id)sender
{
    UISlider *theSlider = (UISlider *)sender;
    refreshInterval = round(theSlider.value); 
    NSString *_refreshIntervalStr = [[NSString alloc]initWithFormat:@"%d", refreshInterval];
    refreshIntervalLabel.text = _refreshIntervalStr;
    [_refreshIntervalStr release];
    [self dataUpdatePause];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:refreshInterval
                                                target:self 
                                              selector:@selector(requestData) 
                                              userInfo:nil 
                                               repeats:YES]; 
}

- (IBAction)refresh:(id)sender{
    [self dataUpdatePause];
    [self dataUpdateStart];
}
- (IBAction)pauseOrStart:(id)sender{
    UIButton *theButton = (UIButton *)sender;
    theButton.selected = !theButton.selected;
    theButton.selected?[self dataUpdatePause]:[self dataUpdateStart];
}

@end
