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

@synthesize welcomeView,settingView,hostAddrTextField,hostReachResultLabel,hostAddr,addrPrefix,addrPostfix,allViewsPicView;

@synthesize picker,provincesShops,provinces,shops;

@synthesize navBar,navBarTitles;
- (void)dealloc
{
    [navBar release];
    [navBarTitles release];
    [pageControl release];
    [viewBoardControllers release];
    [welcomeView release];
    [settingView release];
    [pageControl release];
    [showAllViewBoardsAndSettingButton release];
    [pageRefreshTimeLabel release];
    [viewBoardFrontViews release];
    [hostAddrTextField release];
    [hostReachResultLabel release];
    [picker release];
    [provincesShops release];
    [provinces release];
    [shops release];
    [allViewsPicView release];
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
    //pageControl.currentPage = 0;
    viewBoardFrontViews = [[NSMutableArray alloc]init];
    
    [statisticsController release];
    [realtimeMonitorController release];
    [detailsViewController release];
    [unusualInfoController release];
    [bussSearchInfoController release];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
        
        //[[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(60.0f + 20.0f*i, 100.0f, (scrollViewFrameWidth-kViewGap)*0.45, scrollViewFrameHeight*0.45)];
        //[[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(3.14159265/20*(i-2))];
        [[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(15.0f + 43.0f*i, 120.0f, 116.0, 178.0)];
        //[[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(currentOffset + 60.0f + 20.0f*i, 100.0f, (scrollViewFrameWidth-kViewGap)*0.45, scrollViewFrameHeight*0.45)];
        
        //[[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(3.14159265/20*(i-2))];
        [[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(0.08726646*(i-2))];
        [[[viewBoardControllers objectAtIndex:i] view] setAlpha:0.0f];

    }

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
    if (df) {  
        hostAddr = [df objectForKey:@"hostaddr"];
        hostAddrTextField.text = hostAddr;
        if ([hostAddr isEqualToString:@"172.16.23.70:8080"]) {

            //hostAddr = [[NSString alloc]initWithFormat:@"http://172.16.23.70:8080/STMC/ScanData.json?methodName=GetClientPermission&shopId=0"];
            addrPrefix = [[NSString alloc]initWithFormat:@"http://%@/STMC/ScanData.json?methodName=Get",hostAddr];            
            addrPostfix = [df valueForKey:@"addrpostfix"];
            CATransition *animation = [CATransition animation];
            animation.duration = 0.7f;
            //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
            animation.type = kCATransitionPush;
            //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
            animation.subtype = kCATransitionFromRight; 
            animation.delegate = self;
            [self.view.layer addAnimation:animation forKey:nil];
            [settingView removeFromSuperview];
            /*
             NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
             if (df) {
             NSNumber *provinceSelectedNumber = [[NSNumber alloc]initWithInt:provinceSelected];
             NSNumber *shopSelectedNumber = [[NSNumber alloc]initWithInt:shopSelected];
             [df setValue:provinceSelectedNumber forKey:@"provinceselectednumber"];
             [df setValue:shopSelectedNumber forKey:@"shopselectednumber"];
             [df setValue:provinces forKey:@"provinces"];
             [df setValue:provincesShops forKey:@"provincesshops"];
             [df setValue:addrPostfix forKey:@"addrpostfix"];
             [df synchronize];
             [provinceSelectedNumber release];
             [shopSelectedNumber release];
             }
             */
            self.provincesShops = [df objectForKey:@"provincesshops"];
            self.provinces = [df objectForKey:@"provinces"];
            NSInteger provinceSelected = [[df objectForKey:@"provinceselectednumber"] intValue];
            NSInteger shopSelected = [[df objectForKey:@"shopselectednumber"] intValue];
            self.shops = [provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]];
            [picker reloadAllComponents];
            [picker selectRow:provinceSelected inComponent:0 animated:NO]; 
            [picker selectRow:shopSelected inComponent:1 animated:NO]; 
            [self loadAllViewBoardsWithAddrPrefix:addrPrefix  AddrPostfix:addrPostfix];
        }
        else
        {
            [self.view addSubview:settingView];
            [self.view addSubview:welcomeView];
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


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //allowScrollChangePage = NO;
    //scrollView.pagingEnabled = NO;
    CGFloat scrollViewFrameWidth = scrollView.frame.size.width;
    CGFloat scrollViewFrameHeight = scrollView.frame.size.height;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
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
        
        //半透明度渐变动画 
        [[[viewBoardControllers objectAtIndex:pageControl.currentPage]view ] setAlpha:0.0f];
        [UIView beginAnimations:@"animationLandscapeViewFadeIn" context:nil]; 
        [UIView setAnimationDuration:0.35f]; 
        [[[viewBoardControllers objectAtIndex:pageControl.currentPage] view] setAlpha:1.0f];
        [UIView commitAnimations];
    }
    
    else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight | toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        //NSLog(@"Landscape");
        for (NSInteger i=0; i<viewBoardControllersCount; i++) {
            [[viewBoardControllers objectAtIndex:i] setView:[[viewBoardControllers objectAtIndex:i] landscapeView]];
            [[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(scrollViewFrameWidth * i, 0.0f, scrollViewFrameWidth-kViewGap, scrollViewFrameHeight)];
            //NSLog(@"lanscapeView %d -> %f %f %f %f",i,[[viewBoardControllers objectAtIndex:i] view].frame.origin.x,[[viewBoardControllers objectAtIndex:i] view].frame.origin.y,[[viewBoardControllers objectAtIndex:i] view].frame.size.width,[[viewBoardControllers objectAtIndex:i] view].frame.size.height);
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
        [UIView beginAnimations:@"animationLandscapeViewFadeIn" context:nil]; 
        [UIView setAnimationDuration:1.8f]; 
        [[[viewBoardControllers objectAtIndex:pageControl.currentPage] view] setAlpha:1.0f];
        [UIView commitAnimations];
    }
}

/*
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    scrollView.pagingEnabled = YES;
}
*/
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

    }


}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    [self startTimersPaged];
}

/*
- (IBAction)changePage {

    if (scrollView.scrollEnabled) {
        CGRect frame = CGRectMake((scrollView.frame.size.width) * pageControl.currentPage, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        [scrollView scrollRectToVisible:frame animated:YES];
        [self startTimersPaged];
    }

}
*/

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


#pragma mark - shops selection
-(IBAction)requestAllShopsFromHostAddr:(id)sender
{
    /*
    if([hostAddrTextField.text isEqualToString:@"172.16.23.70:8080"])
    {
        NSString *shopListAddr = [[NSString alloc]initWithFormat:@"http://172.16.23.70:8080/STMC/ScanData.json?methodName=GetClientPermission&shopId=0"]; 
        
        ASIHTTPRequest *allShopsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:shopListAddr]];
        [shopListAddr release];
        [allShopsRequest setDelegate:self];
        allShopsRequest.didFinishSelector = @selector(didFinishAllShopsRequest:);
        allShopsRequest.didFailSelector = @selector(didFailAllShopsRequest:);
        [allShopsRequest startAsynchronous];
    }
    else
        [self didFailAllShopsRequest:nil];
     */
    NSString *shopListAddr = [[NSString alloc]initWithFormat:@"http://%@/STMC/ScanData.json?methodName=GetClientPermission&shopId=0",hostAddrTextField.text]; 
    
    ASIHTTPRequest *allShopsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:shopListAddr]];
    [shopListAddr release];
    [allShopsRequest setDelegate:self];
    allShopsRequest.didFinishSelector = @selector(didFinishAllShopsRequest:);
    allShopsRequest.didFailSelector = @selector(didFailAllShopsRequest:);
    [allShopsRequest startAsynchronous];
}

-(void)didFinishAllShopsRequest:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];    
    NSArray *tmpArray = [responseString JSONValue];
    [responseString release];
    if([tmpArray count] && ![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
    {
        NSString *reachText = [[NSString alloc]initWithString:@"连接服务器成功"];
        hostReachResultLabel.text = reachText;
        [reachText release];
        provincesShops = [[NSMutableDictionary alloc]init ];
        for (NSDictionary* anyShop in tmpArray) {
            //provincesShops中已存在以此省名为key的字典
            NSString *provinceName = [[NSString alloc]initWithString:[anyShop objectForKey:@"province"]];
            if ([provincesShops objectForKey:provinceName])
            {
                [(NSMutableArray*)[provincesShops objectForKey:provinceName] addObject:anyShop];
            }
            //provincesShops中未存在以此省名为key的字典
            else
            {
                NSString *allShopsID = [[NSString alloc]initWithFormat:@"%@*",[[anyShop objectForKey:@"shopid"]substringToIndex:3]];
                NSString *allShopsName = [[NSString alloc]initWithFormat:@"%@所有站点",provinceName];
                NSDictionary *AllShops = [[NSDictionary alloc]initWithObjectsAndKeys:allShopsID,@"shopid",allShopsName,@"shopname", nil];
                [allShopsID release];
                [allShopsName release];
                NSMutableArray *shopsOfTheProvice = [[NSMutableArray alloc]initWithObjects:AllShops,anyShop, nil];
                [AllShops release];
                [provincesShops setObject:shopsOfTheProvice forKey:provinceName];

            }
        }
        self.provinces = [[NSMutableArray alloc]initWithArray:[provincesShops allKeys]];
        NSString *nationwideShopsStr = [[NSString alloc]initWithString:@"全国"];
        [provinces insertObject:nationwideShopsStr atIndex:0];
        NSString *nationwideShopsID = [[NSString alloc]initWithString:@"all"];
        NSString *nationwideShopsName = [[NSString alloc]initWithString:@"全国所有站点"];

        NSDictionary *nationwideShopsDic = [[NSDictionary alloc]initWithObjectsAndKeys:nationwideShopsID,@"shopid",nationwideShopsName,@"shopname", nil];
        [nationwideShopsID release];
        [nationwideShopsName release];
        NSArray *nationwideShopsArray = [[NSArray alloc]initWithObjects:nationwideShopsDic, nil];
        [provincesShops setObject:nationwideShopsArray forKey:@"全国"];
        self.shops = [provincesShops objectForKey:[provinces objectAtIndex:0]];
        [picker reloadAllComponents];
        [picker selectRow:0 inComponent:0 animated:NO]; 
        [picker selectRow:0 inComponent:1 animated:NO]; 
        [NSTimer scheduledTimerWithTimeInterval:0.5f
                                         target:self 
                                       selector:@selector(forwardToSettingView) 
                                       userInfo:nil 
                                        repeats:NO];
    }
    else
    {
        [self didFailAllShopsRequest:nil];
    }

}

- (void) forwardToSettingView
{
    [welcomeView removeFromSuperview];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3f;
    //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
    animation.type = kCATransitionPush;
    //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
    animation.subtype = kCATransitionFromRight; 
    animation.delegate = self;
    [self.view.layer addAnimation:animation forKey:nil];
    [welcomeView removeFromSuperview];
}

-(void)didFailAllShopsRequest:(ASIHTTPRequest *)request
{
    NSString *reachFailText = [[NSString alloc]initWithString:@"连接服务器失败"];
    hostReachResultLabel.text = reachFailText;
    [reachFailText release];
}
- (IBAction)shopsSelectionConfirm:(id)sender
{
    for (id viewBoardController in viewBoardControllers) {
        [viewBoardController cleanUI];
    }
    NSString *_addrPrefix = [[NSString alloc]initWithFormat:@"http://%@/STMC/ScanData.json?methodName=Get",hostAddr];
    self.addrPrefix = _addrPrefix;
    [_addrPrefix release];
    NSInteger provinceSelected = [picker selectedRowInComponent:0];
    NSInteger shopSelected = [picker selectedRowInComponent:1];
    self.addrPostfix = [[NSString alloc]initWithFormat:@"&shopId=%@",[[[provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]] objectAtIndex:shopSelected] objectForKey:@"shopid"]];
    [showAllViewBoardsAndSettingButton setTitle:[[[provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]] objectAtIndex:shopSelected] objectForKey:@"shopname"] forState:UIControlStateNormal];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    if (df) {
        NSNumber *provinceSelectedNumber = [[NSNumber alloc]initWithInt:provinceSelected];
        NSNumber *shopSelectedNumber = [[NSNumber alloc]initWithInt:shopSelected];
        [df setValue:provinceSelectedNumber forKey:@"provinceselectednumber"];
        [df setValue:shopSelectedNumber forKey:@"shopselectednumber"];
        [df setValue:provinces forKey:@"provinces"];
        [df setValue:provincesShops forKey:@"provincesshops"];
        [df setValue:addrPostfix forKey:@"addrpostfix"];
        [df synchronize];
        [provinceSelectedNumber release];
        [shopSelectedNumber release];
    }

        CATransition *animation = [CATransition animation];
        animation.duration = 0.7f;
        //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
        animation.type = kCATransitionPush;
        //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
        animation.subtype = kCATransitionFromRight; 
        animation.delegate = self;
        [self.view.layer addAnimation:animation forKey:nil];
        [settingView removeFromSuperview];
        [self loadAllViewBoardsWithAddrPrefix:addrPrefix  AddrPostfix:addrPostfix];
}

#pragma mark - gereral controller
- (IBAction)backOrForward:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    switch (theButton.tag) {
        case 10:
            exit(0);
            break;
        case 12:
        {    
            hostReachResultLabel.text = nil;
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3f;
            //设置上面4种动画效果使用CATransiton可以设置4种动画效果，分别为：kCATransitionFade;//渐渐消失kCATransitionMoveIn;//覆盖进入kCATransitionPush;//推出kCATransitionReveal;//与MoveIn相反
            animation.type = kCATransitionPush;
            //设置动画的方向，有四种，分别为kCATransitionFromRight、kCATransitionFromLeft、kCATransitionFromTop、kCATransitionFromBottom
            animation.subtype = kCATransitionFromLeft;
            animation.delegate = self;
            [self.view.layer addAnimation:animation forKey:nil];
            [self.view addSubview:welcomeView];
            break;
        }
        default:
            break;
    }
    
}

- (IBAction)textFieldDoneEditing:(id)sender
{
    
     self.hostAddr = hostAddrTextField.text;
     NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
     if (df)
     {
         [df setValue:hostAddr forKey:@"hostaddr"];
         [df synchronize];
     }
    [sender resignFirstResponder];
}

- (IBAction)textFieldEditing:(id)sender
{
    NSString *emptyStr = [[NSString alloc]initWithString:@""];
    hostReachResultLabel.text = emptyStr;
    [emptyStr release];
}
#pragma mark - viewBoards Manage
- (void) loadAllViewBoardsWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    pageControl.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = [UIColor whiteColor];
    scrollView.alpha = 1.0f;
    for (id anyViewBoardController in viewBoardControllers) {
        [anyViewBoardController setAddrWithAddrPrefix:addrPrefixSet AddrPostfix:addrPostfixSet];
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
        //(i!=pageControl.currentPage)?[[viewBoardFrontViews objectAtIndex:i]setAlpha:0.6f]:nil;
        [[viewBoardControllers objectAtIndex:i] dataUpdatePause];
        [UIView beginAnimations:@"animationViewBoardsGather" context:nil];
        [UIView setAnimationDuration:0.5f]; 
        //[UIView setAnimationDuration:abs(pageControl.currentPage - i)*0.1+0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(currentOffset + 15.0f + 43.0f*i, 120.0f, 116.0, 178.0)];
        //[[[viewBoardControllers objectAtIndex:i] view] setFrame:CGRectMake(currentOffset + 60.0f + 20.0f*i, 100.0f, (scrollViewFrameWidth-kViewGap)*0.45, scrollViewFrameHeight*0.45)];
        
        //[[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(3.14159265/20*(i-2))];
        [[[viewBoardControllers objectAtIndex:i] view] setTransform:CGAffineTransformMakeRotation(0.08726646*(i-2))];
        [[[viewBoardControllers objectAtIndex:i] view] setAlpha:0.0f];
        
        [UIView commitAnimations];
    }
    
    [UIView beginAnimations:@"animationScrollviewWhite" context:nil];
    [UIView setAnimationDuration:0.7f]; 
    self.view.backgroundColor = [UIColor whiteColor];
    scrollView.backgroundColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    allViewsPicView.alpha = 1.0f;
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.8f
                                         target:self 
                                       selector:@selector(backToSettingView) 
                                       userInfo:nil 
                                        repeats:NO];
        

    
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
    [self.view addSubview:settingView];
    scrollView.alpha = 0.0f;
}


-(void)jumpToCurrentPage
{
    [UIView beginAnimations:@"animationScrollviewDark" context:nil]; 
    [UIView setAnimationDuration:0.6f];
    allViewsPicView.alpha = 0.0f;
    self.view.backgroundColor = [UIColor darkGrayColor];
    scrollView.backgroundColor = [UIColor darkTextColor];
    pageControl.backgroundColor = [UIColor darkTextColor];
    [UIView commitAnimations];
    Float32 scrollViewFrameWidth = scrollView.frame.size.width;
    Float32 scrollViewFrameHeight = scrollView.frame.size.height;
    //[scrollView scrollRectToVisible:CGRectMake(scrollViewFrameWidth*pageControl.currentPage, 0.0f, scrollViewFrameWidth, scrollViewFrameHeight) animated:NO];
    //allViewsPicView.alpha = 0.0f;
    
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
        //[[viewBoardFrontViews objectAtIndex:i]removeTarget:self action:@selector(jumpToPageSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    scrollView.scrollEnabled = YES;
    //pageControl.enabled = YES;
    //[self startTimersPaged];
    //[scrollView setContentOffset:CGPointMake(scrollViewFrameWidth*pageControl.currentPage, 0.0f)];
    showAllViewBoardsAndSettingButton.enabled = YES;
    allowRotationLanscape = YES;
}

#pragma mark - UIPickerView datasource Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (0==component)?[provinces count]:[shops count];
}
#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 78.0f;  
            break;
        default:
            return 208.0f;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return (0==component)?[provinces objectAtIndex:row]:[[shops objectAtIndex:row]objectForKey:@"shopname"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{   
    switch (component) {
        case 0:
        {

            self.shops = [provincesShops objectForKey:[provinces objectAtIndex:row]];
            [picker reloadComponent:1];
            break;
        }  
        default:
            break;
    }

}

#pragma mark - willInfoBoardUpdateUIOnPage: Delegate
- (void)willInfoBoardUpdateUIOnPage:(NSString *) msg
{

    pageRefreshTimeLabel.text = msg;
}
@end
