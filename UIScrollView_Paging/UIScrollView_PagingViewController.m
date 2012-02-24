//
//  UIScrollView_PagingViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"

#import "StatisticsController.h"
#import "RealtimeMonitorController.h"
#import "DetailsViewController.h"
#import "UnusualInfoController.h"
#import "BussSearchInfoController.h"


#import "Reachability.h"
#import "UIScrollView_PagingViewController.h"
@implementation UIScrollView_PagingViewController

@synthesize scrollView;


@synthesize pageControl,showAllViewBoardsAndSettingButton,pageRefreshTimeLabel,viewBoardControllers,viewBoardFrontViews;

@synthesize hostAddr,addrPrefix,addrPostfix,allViewsPicView;

@synthesize provincesShops,provinces,shops;

@synthesize navBar,navBarTitles;
@synthesize updateTimeStrArray;
@synthesize loginController,settingController;
- (void)dealloc
{
    [navBar release];
    [navBarTitles release];
    [pageControl release];
    [viewBoardControllers release];
    [pageControl release];
    [showAllViewBoardsAndSettingButton release];
    [pageRefreshTimeLabel release];
    [viewBoardFrontViews release];
    [provincesShops release];
    [provinces release];
    [shops release];
    [allViewsPicView release];
    [updateTimeStrArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    Float32 scrollViewFrameWidth = scrollView.frame.size.width;
    Float32 scrollViewFrameHeight = scrollView.frame.size.height;
    navBarTitles = [[NSArray alloc]initWithObjects:@"统计分析",@"业务汇总",@"异常汇总",@"实时呼叫",@"座席列表", nil];
    navBar.topItem.title = [navBarTitles objectAtIndex:0];
    updateTimeStrArray = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"",@"", nil];
    
    StatisticsController *statisticsController = [[StatisticsController alloc ]initWithNibName:@"StatisticsController" bundle:nil];
    statisticsController.delegate = self;
    RealtimeMonitorController *realtimeMonitorController = [[RealtimeMonitorController alloc ]initWithNibName:@"RealtimeMonitorController" bundle:nil];
    realtimeMonitorController.delegate = self;
    DetailsViewController *detailsViewController = [[DetailsViewController alloc ]initWithNibName:@"DetailsViewController" bundle:nil];
    detailsViewController.delegate = self;
    UnusualInfoController *unusualInfoController = [[UnusualInfoController alloc ]initWithNibName:@"UnusualInfoController" bundle:nil];
    unusualInfoController.delegate = self;
    BussSearchInfoController *bussSearchInfoController = [[BussSearchInfoController alloc ]initWithNibName:@"BussSearchInfoController" bundle:nil];
    bussSearchInfoController.delegate = self;
    
    
    
    viewBoardControllers = [[NSArray alloc ]initWithObjects:statisticsController,bussSearchInfoController, unusualInfoController, realtimeMonitorController, detailsViewController,nil ];
    viewBoardControllersCount = [viewBoardControllers count];
    pageControl.numberOfPages = viewBoardControllersCount;
    viewBoardFrontViews = [[NSMutableArray alloc]init];
    
    [statisticsController release];
    [realtimeMonitorController release];
    [detailsViewController release];
    [unusualInfoController release];
    [bussSearchInfoController release];
    
    scrollView.contentSize = CGSizeMake(scrollViewFrameWidth * viewBoardControllersCount, scrollViewFrameHeight);
    scrollView.alpha = 0.0f;
    //各页面属性设置
    for (NSInteger i=0; i<viewBoardControllersCount; i++) {
        [[[viewBoardControllers objectAtIndex:i] view ] setFrame:CGRectMake(scrollViewFrameWidth * i, 0.0f, scrollViewFrameWidth - kViewGap, scrollViewFrameHeight)];
        UIControl *frontView = [[UIControl alloc]initWithFrame:CGRectMake(0.0f, 0.0f, scrollViewFrameWidth-kViewGap, scrollViewFrameHeight)];
        frontView.backgroundColor = [UIColor blackColor];
        frontView.alpha = 0.0f;
        frontView.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [[[viewBoardControllers objectAtIndex:i] view ] addSubview:frontView];
        [viewBoardFrontViews addObject:frontView];
        [frontView release];
        [scrollView addSubview:[[viewBoardControllers objectAtIndex:i] view]];
        
        [[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(15.0f + 43.0f*i, 120.0f, 116.0, 178.0)];
        [[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(0.08726646*(i-2))];
        [[[viewBoardControllers objectAtIndex:i] view] setAlpha:0.0f];

    }

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
    if (df) {  
        if (NO){
            addrPrefix = [[NSString alloc]initWithFormat:@"http://%@/STMC/ScanData.json?methodName=Get",hostAddr];            
            addrPostfix = [df valueForKey:@"addrpostfix"];
            
            self.provincesShops = [df objectForKey:@"provincesshops"];
            self.provinces = [df objectForKey:@"provinces"];
            NSInteger provinceSelected = [[df objectForKey:@"provinceselectednumber"] intValue];
            NSInteger shopSelected = [[df objectForKey:@"shopselectednumber"] intValue];
            self.shops = [provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]];
            NSString *provinceName = [[provinces objectAtIndex:provinceSelected]retain];
            NSString *shopName = [[[[provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]] objectAtIndex:shopSelected] objectForKey:@"shopname"]retain];
            NSString *province_shopStr = [[NSString alloc]initWithFormat:@"%@ %@",provinceName,shopName];
            [provinceName release];
            [shopName release];
            [showAllViewBoardsAndSettingButton setTitle:province_shopStr forState:UIControlStateNormal];
            NSLog(@"province_shopStr ->%@",province_shopStr);
            [province_shopStr release];
            [self loadAllViewBoardsWithAddrPrefix:addrPrefix  AddrPostfix:addrPostfix];
        }
        else
        {
            loginController = [[SDLoginViewController alloc]initWithNibName:@"SDLoginViewController" bundle:nil tagStr:@"login"];
            loginController.delegate = self;
            [self.view addSubview:loginController.view];
        }

    }

}

- (void)viewDidAppear:(BOOL)animated {   
    //检测网络连接状态
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) && 
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)) {
        UIAlertView *alertView = [[UIAlertView alloc ]initWithTitle:@"警告" message:@"无网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return allowRotationLanscape?interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown:interfaceOrientation == UIInterfaceOrientationPortrait;
}

UIInterfaceOrientation temp;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{    
    temp =toInterfaceOrientation;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewFrameWidth = scrollView.frame.size.width;
    CGFloat scrollViewFrameHeight = scrollView.frame.size.height;
    scrollView.contentSize = CGSizeMake(scrollViewFrameWidth * viewBoardControllersCount, scrollViewFrameHeight);    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        //NSLog(@"Portrait");
        for (NSInteger i=0; i<viewBoardControllersCount; i++) {
            [[viewBoardControllers objectAtIndex:i] setView:[[viewBoardControllers objectAtIndex:i] originView]];
            [[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(scrollViewFrameWidth * i, 0.0f, scrollViewFrameWidth-kViewGap, scrollViewFrameHeight)];
        }
        
        if (currentOffsetX<240.0f) {
            [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
        }else if(currentOffsetX<740.0f) {
            [scrollView setContentOffset:CGPointMake(340.0f, 0.0f) animated:NO];
        }else if(currentOffsetX<1240.0f) {
            [scrollView setContentOffset:CGPointMake(680.0f, 0.0f) animated:NO];
        }else if(currentOffsetX<1740.0f) {
            [scrollView setContentOffset:CGPointMake(1020.0f, 0.0f) animated:NO];
        }else {
            [scrollView setContentOffset:CGPointMake(1360.0f, 0.0f) animated:NO];
        }
        [[viewBoardControllers objectAtIndex:pageControl.currentPage] updateOriginView:nil];
        [[viewBoardFrontViews objectAtIndex:pageControl.currentPage] setAlpha:0.0f];
        [[[viewBoardControllers objectAtIndex:pageControl.currentPage]view ] setAlpha:0.0f];       
    }
    
    else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight ||toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {        
        //NSLog(@"Landscape");
        for (NSInteger i=0; i<viewBoardControllersCount; i++) {
            [[viewBoardControllers objectAtIndex:i] setView:[[viewBoardControllers objectAtIndex:i] landscapeView]];
            [[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(scrollViewFrameWidth * i, 1.0f, scrollViewFrameWidth-kViewGap, scrollViewFrameHeight)];
        }
        if (currentOffsetX<160.0f) {
            [scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
        }else if(currentOffsetX<500.0f) {
            [scrollView setContentOffset:CGPointMake(500.0f, 0.0f) animated:NO];
        }else if(currentOffsetX<840.0f) {
            [scrollView setContentOffset:CGPointMake(1000.0f, 0.0f) animated:NO];
        }else if(currentOffsetX<1180.0f) {
            [scrollView setContentOffset:CGPointMake(1500.0f, 0.0f) animated:NO];
        }else {
            [scrollView setContentOffset:CGPointMake(2000.0f, 0.0f) animated:NO];
        }
        [[viewBoardControllers objectAtIndex:pageControl.currentPage] updateLandscapeView:nil];
        //半透明度渐变动画 
        [[[viewBoardControllers objectAtIndex:pageControl.currentPage]view ] setAlpha:0.0f];
    }
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    if (temp == UIInterfaceOrientationLandscapeRight || temp == UIInterfaceOrientationLandscapeLeft)
    {        
        [UIView beginAnimations:@"animationLandscapeViewFadeIn" context:nil]; 
        [UIView setAnimationDuration:0.35f]; 
        [[[viewBoardControllers objectAtIndex:pageControl.currentPage] view] setAlpha:1.0f];
        [UIView commitAnimations];
        [scrollView setFrame:CGRectMake(0.0, 1.0, 500.0, 263.0)];
        [navBar removeFromSuperview];}
    else if(temp==UIInterfaceOrientationPortrait)
    {  
        //半透明度渐变动画 
        [UIView beginAnimations:@"animationLandscapeViewFadeIn" context:nil]; 
        [UIView setAnimationDuration:0.35f]; 
        [[[viewBoardControllers objectAtIndex:pageControl.currentPage] view] setAlpha:1.0f];
        [UIView commitAnimations];  
        
        [scrollView setFrame:CGRectMake(0.0, 44.0, 340.0, 379.0)];
        [navBar setFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
        [self.view addSubview:navBar];
    }
    CGFloat scrollViewFrameWidth = scrollView.frame.size.width;
    CGFloat scrollViewFrameHeight = scrollView.frame.size.height;
    scrollView.contentSize = CGSizeMake(scrollViewFrameWidth * viewBoardControllersCount, scrollViewFrameHeight);   
}

#pragma mark - Scroll and pagecontrol paging


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //NSLog(@"offset->%f",scrollView.contentOffset.x);
    Float32 currentOffset = scrollView.contentOffset.x;
    Float32 scrollViewFrameWidth = scrollView.frame.size.width;
    
    if (currentOffset >=0 && currentOffset<=(scrollViewFrameWidth*(viewBoardControllersCount-1))) 
    {
        // Update the page when more than 50% of the previous/next page is visible  
        NSInteger pageTag = floor(currentOffset / (scrollViewFrameWidth+0.01f));
        Float32 prevPageAlpha = (currentOffset-scrollViewFrameWidth*pageTag)/scrollViewFrameWidth;
        [[viewBoardFrontViews objectAtIndex:pageTag] setAlpha:prevPageAlpha];
        [[viewBoardFrontViews objectAtIndex:pageTag+1] setAlpha:(1.0f - prevPageAlpha)];
        
        NSInteger page = floor(currentOffset / scrollViewFrameWidth - 0.5f) + 1.0f;
        pageControl.currentPage = page;
        navBar.topItem.title = [navBarTitles objectAtIndex:page];
        pageRefreshTimeLabel.text = [updateTimeStrArray objectAtIndex:page];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    [self startTimersPaged];
}

# pragma mark - set and invalidate timers

-(void)startTimersPaged
{
    for (NSInteger i=0; i<viewBoardControllersCount; i++) {
        if (pageControl.currentPage == i) {
            [[viewBoardControllers objectAtIndex:i] dataUpdateStart];
        }
        else
            [[viewBoardControllers objectAtIndex:i] dataUpdatePause];
    }
}


//- (void) forwardToSettingView
//{
//    [welcomeView removeFromSuperview];
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.3f;
//    //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
//    animation.type = kCATransitionPush;
//    //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
//    animation.subtype = kCATransitionFromRight; 
//    animation.delegate = self;
//    [self.view.layer addAnimation:animation forKey:nil];
//    [welcomeView removeFromSuperview];
//}
//- (IBAction)shopsSelectionConfirm:(id)sender
//{
//    for (id viewBoardController in viewBoardControllers) {
//        [viewBoardController cleanUI];
//    }
//    for (NSInteger i=0; i<[updateTimeStrArray count]; i++) {
//        [updateTimeStrArray replaceObjectAtIndex:i withObject:@""];
//    }
//    pageRefreshTimeLabel.text = nil;
//    NSString *_addrPrefix = [[NSString alloc]initWithFormat:@"http://%@/STMC/ScanData.json?methodName=Get",hostAddr];
//    self.addrPrefix = _addrPrefix;
//    [_addrPrefix release];
//    NSInteger provinceSelected = [picker selectedRowInComponent:0];
//    NSInteger shopSelected = [picker selectedRowInComponent:1];
//    self.addrPostfix = [[NSString alloc]initWithFormat:@"&shopId=%@",[[[provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]] objectAtIndex:shopSelected] objectForKey:@"shopid"]];
//    NSString *provinceName = [[provinces objectAtIndex:provinceSelected]retain];
//    NSString *shopName = [[[[provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]] objectAtIndex:shopSelected] objectForKey:@"shopname"]retain];
//    NSString *province_shopStr = [[NSString alloc]initWithFormat:@"%@ %@",provinceName,shopName];
//    [provinceName release];
//    [shopName release];
//    [showAllViewBoardsAndSettingButton setTitle:province_shopStr forState:UIControlStateNormal];
//    [province_shopStr release];
//    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
//    if (df) {
//        NSNumber *provinceSelectedNumber = [[NSNumber alloc]initWithInt:provinceSelected];
//        NSNumber *shopSelectedNumber = [[NSNumber alloc]initWithInt:shopSelected];
//        [df setValue:provinceSelectedNumber forKey:@"provinceselectednumber"];
//        [df setValue:shopSelectedNumber forKey:@"shopselectednumber"];
//        [df setValue:provinces forKey:@"provinces"];
//        [df setValue:provincesShops forKey:@"provincesshops"];
//        [df setValue:addrPostfix forKey:@"addrpostfix"];
//        //[df setValue:shopName forKey:@"shopname"];
//        [df synchronize];
//        [provinceSelectedNumber release];
//        [shopSelectedNumber release];
//    }
//
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.7f;
//        //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
//        animation.type = kCATransitionPush;
//        //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
//        animation.subtype = kCATransitionFromRight; 
//        animation.delegate = self;
//        [self.view.layer addAnimation:animation forKey:nil];
//        [settingView removeFromSuperview];
//        [self loadAllViewBoardsWithAddrPrefix:addrPrefix  AddrPostfix:addrPostfix];
//}


#pragma mark - viewBoards Manage
- (void) loadAllViewBoardsWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
    scrollView.alpha = 1.0f;
    for (id anyViewBoardController in viewBoardControllers) {
        [anyViewBoardController setAddrWithAddrPrefix:newAddrPrefix AddrPostfix:newAddrPostfix];
    }
    [[viewBoardControllers objectAtIndex:pageControl.currentPage] dataUpdateStart];
    [NSTimer scheduledTimerWithTimeInterval:0.8f
                                     target:self 
                                   selector:@selector(jumpToCurrentPage) 
                                   userInfo:nil 
                                    repeats:NO];
}

- (IBAction)showAllViewBoards:(id)sender
{
    allowRotationLanscape = NO;
    showAllViewBoardsAndSettingButton.enabled = NO;
    [[viewBoardControllers objectAtIndex:pageControl.currentPage] dataUpdatePause];
    Float32 currentOffset = scrollView.contentOffset.x;
    [allViewsPicView setFrame:CGRectMake(currentOffset, 0.0f, 320.0f, 434.0f)];
    for (NSInteger i=0; i<viewBoardControllersCount; i++) {
        [[viewBoardControllers objectAtIndex:i] dataUpdatePause];
        [UIView beginAnimations:@"animationViewBoardsGather" context:nil];
        [UIView setAnimationDuration:0.5f]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(currentOffset + 15.0f + 43.0f*i, 120.0f, 116.0, 178.0)];
        [[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(0.08726646*(i-2))];
        [[[viewBoardControllers objectAtIndex:i] view] setAlpha:0.0f];
        [UIView commitAnimations];
    }
    
    [UIView beginAnimations:@"animationScrollviewWhite" context:nil];
    [UIView setAnimationDuration:0.7f]; 
    allViewsPicView.alpha = 1.0f;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.8f
                                         target:self 
                                       selector:@selector(backToSettingView) 
                                       userInfo:nil 
                                        repeats:NO];
        
    ((StatisticsController *)[viewBoardControllers objectAtIndex:0]).ifLoading=YES;
    ((RealtimeMonitorController *)[viewBoardControllers objectAtIndex:1]).ifLoading=YES;
    ((UnusualInfoController *)[viewBoardControllers objectAtIndex:2]).ifLoading=YES;
    ((BussSearchInfoController *)[viewBoardControllers objectAtIndex:3]).ifLoading=YES;
    ((DetailsViewController *)[viewBoardControllers objectAtIndex:4]).ifLoading=YES;
}

- (void)backToSettingView
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
    animation.type = kCATransitionPush;
    //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
    animation.subtype = kCATransitionFromLeft; 
    animation.delegate = self;
    [self.view.layer addAnimation:animation forKey:nil];
    [self.view addSubview:loginController.view];
    [self.view addSubview:settingController.view];
    scrollView.alpha = 0.0f;
}


-(void)jumpToCurrentPage
{
    [UIView beginAnimations:@"animationScrollviewDark" context:nil]; 
    [UIView setAnimationDuration:0.6f];
    allViewsPicView.alpha = 0.0f;
    [UIView commitAnimations];
    Float32 scrollViewFrameWidth = scrollView.frame.size.width;
    Float32 scrollViewFrameHeight = scrollView.frame.size.height;
    
    for (NSInteger i=0; i<viewBoardControllersCount; i++) {
        
        [UIView beginAnimations:@"animationViewBoardsScatter" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        //[UIView setAnimationDuration:0.8f]; 
        //[UIView setAnimationDuration:abs(pageControl.currentPage - i)*0.35+1.0];
        [UIView setAnimationDuration:0.9-abs(pageControl.currentPage - i)*0.2];
        [[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(0.0f)];
        //[[viewBoardFrontViews objectAtIndex:i]setAlpha:0.0f];
        [[[viewBoardControllers objectAtIndex:i] view]setFrame:CGRectMake(scrollViewFrameWidth*i, 0.0f, scrollViewFrameWidth-kViewGap, scrollViewFrameHeight)];
        [[[viewBoardControllers objectAtIndex:i] view] setAlpha:1.0f];
        [UIView commitAnimations];
    }
    scrollView.scrollEnabled = YES;
    showAllViewBoardsAndSettingButton.enabled = YES;
    allowRotationLanscape = YES;
}

#pragma mark - willInfoBoardUpdateUIOnPage: Delegate
- (void)willInfoBoardUpdateUIOnPage:(NSInteger)page WithMessage:(NSString*) msg;
{

    [updateTimeStrArray replaceObjectAtIndex:page withObject:msg];
    pageRefreshTimeLabel.text = [updateTimeStrArray objectAtIndex:pageControl.currentPage];
}

#pragma mark - go back or forward
-(void)needGoBackWithControllerTagStr:(NSString*)tagStr message:(id)msg
{
    if ([tagStr isEqualToString:@"login"]) {
        exit(0);
    }
    else{
        [settingController.view removeFromSuperview];
    }
}
-(void)needGoForwardWithControllerTagStr:(NSString*)tagStr message:(id)msg
{
    if ([tagStr isEqualToString:@"login"]) {
        hostAddr =  [[((NSDictionary*)msg)objectForKey:@"ipAddr"]retain];
        NSString *_addrPrefix = [[NSString alloc]initWithFormat:@"http://%@/STMC/ScanData.json?methodName=Get",hostAddr];
        self.addrPrefix = _addrPrefix;
        [_addrPrefix release];
        NSString* responseStr = [((NSDictionary*)msg)objectForKey:@"responseStr"];
        if (responseStr) {
            settingController = [[SDSettingViewController alloc]initWithNibName:@"SDSettingViewController" bundle:nil tagStr:@"setting"];
            settingController.delegate = self;
            [self.view addSubview:settingController.view];
            [settingController reloadWithResponseStr:responseStr];
        }
    }else if([tagStr isEqualToString:@"setting"])
    {
        NSString* _addrPostfix = [[NSString alloc]initWithFormat:@"&shopId=%@",[msg objectForKey:@"selectedShopId"]];
        self.addrPostfix = _addrPostfix;
        [_addrPostfix release];
        [showAllViewBoardsAndSettingButton setTitle:[msg objectForKey:@"province_shopStr"] forState:UIControlStateNormal];
        [settingController.view removeFromSuperview];
        [loginController.view removeFromSuperview];
        [self loadAllViewBoardsWithAddrPrefix:self.addrPrefix AddrPostfix:addrPostfix];
    }
         
}

@end
