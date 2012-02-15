//
//  DetailsViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "JSON.h"
#import "GroupTableViewController.h"
#import "AgtTableViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
#import "DetailsViewController.h"

@implementation DetailsViewController

@synthesize addrPrefix;
@synthesize addrPostfix;
@synthesize allGrpInfoWebAddr,mAgtInfoWebAddr,agtCallInfoWebAddr,webAddr;
@synthesize selectedGrpId;

@synthesize timer,refreshInterval;


@synthesize workStatusResultStr;
@synthesize loginStr;
@synthesize pauseStr;
@synthesize workStatusStr;
@synthesize occupyStr;

@synthesize originView;
@synthesize landscapeView;
@synthesize lists;
@synthesize navController,groupTableViewController,agtTableViewController;
@synthesize delegate,allGrpInfoCashResponseStr,mAgtInfoCashResponseStr,agtCallInfoCashResponseStr;
@synthesize loadingOrigin,loadingLandscape;
@synthesize ifLoading;

@synthesize allGrpInfoDictArray,mAgtInfoDict;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.lists = [[NSMutableArray alloc] init];
        allGrpInfoCashResponseStr = [[NSString alloc]init];
        mAgtInfoCashResponseStr = [[NSString alloc]init];
        agtCallInfoCashResponseStr = [[NSString alloc]init];
        
        groupTableViewController  = [[GroupTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
        groupTableViewController.tableView.delegate = self;
        agtTableViewController = [[AgtTableViewController alloc]initWithStyle:UITableViewStyleGrouped];    
        
    }
    return self;
}

- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
    
    //self.agtInfoWebAddr = [[NSString alloc]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/mAgtInfo.json"];
    //self.allGrpInfoWebAddr =   [[NSString alloc]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/AllGrpInfo.json"];
    self.addrPrefix = newAddrPrefix;
    self.addrPostfix = newAddrPostfix;

    NSString *str1 = [[NSString alloc]initWithFormat:@"%@AllGrpInfo%@",addrPrefix,addrPostfix];
    self.allGrpInfoWebAddr = str1;
    [str1 release];
    NSString *str2 = [[NSString alloc]initWithFormat:@"%@MAgtInfo%@",addrPrefix,addrPostfix];
    self.mAgtInfoWebAddr = str2;
    NSString *str3 = [[NSString alloc]initWithFormat:@"%@AgtCallInfo%@",addrPrefix,addrPostfix];
    self.agtCallInfoWebAddr = str3;
    self.webAddr = allGrpInfoWebAddr;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
    [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setAddrWithAddrPrefix:newAddrPrefix AddrPostfix:newAddrPostfix];


    
    return self;
}

- (void)dealloc
{   
    [originView release];
    [landscapeView release];
    [lists release];
    [groupTableViewController release];
    [agtTableViewController release];
    [navController release];
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
    //NSLog(@"detailsController viewDidLoad");
    [super viewDidLoad];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
    if (df) {  
        refreshInterval = [[df objectForKey:@"detailsviewinterval"]intValue];
    }
    if(0 == refreshInterval)
    {
        refreshInterval = 60;
    }
    
    UINavigationController *_navController = [[UINavigationController alloc ]initWithRootViewController:groupTableViewController];
    self.navController = _navController;
    [_navController release];
    navController.delegate = self;
    navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    navController.navigationBar.topItem.title =@"返回";
    [navController.view setFrame:CGRectMake(0.0f, 00.0f, 320.0f, 379.0f)];
    [self.view addSubview:navController.view];
    

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
        self.timer=[NSTimer scheduledTimerWithTimeInterval:refreshInterval //定时器间隔
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
    //NSLog(@"- (void)viewDidUnload: --> Call!");
    //self.agtInfoDictArray= nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.originView = nil;
    self.landscapeView = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"- (BOOL)shouldAutorotateToInterfaceOrientation: --> Call!");
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table View

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        
    NSString *headerTitle = [[NSString alloc]initWithFormat:@"   监控数: %d个（点击查看座席列表）",[allGrpInfoDictArray count]];
    return [[[DetailHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0) title:headerTitle delegate:self] autorelease];
    [headerTitle release];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([addrPostfix hasSuffix:@"all"] || [addrPostfix hasSuffix:@"*"]) {
        NSString *title = [[NSString alloc]initWithString:@"提示"];
        NSString *messageShow = [[NSString alloc]initWithString:@"抱歉，查看全国或某省(市、自治区)所有站点时无法查看站点座席列表"];
        UIAlertView *alertView = [[UIAlertView alloc ]initWithTitle:title message:messageShow delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertView show];
        [alertView release];
        [title release];
        [messageShow release];
    }
    else
    {
        [navController pushViewController:agtTableViewController animated:YES];
        self.webAddr = mAgtInfoWebAddr;
        [self requestData];
        self.webAddr = allGrpInfoWebAddr;
        self.selectedGrpId = [[groupTableViewController.dataDictArray objectAtIndex:indexPath.row]objectForKey:@"grpid"];
    }
    
}
- (void) viewClicked
{
    if ([addrPostfix hasSuffix:@"all"] || [addrPostfix hasSuffix:@"*"]) {
        NSString *title = [[NSString alloc]initWithString:@"提示"];
        NSString *messageShow = [[NSString alloc]initWithString:@"抱歉，查看全国或某省(市、自治区)所有站点时无法查看站点座席列表"];
        UIAlertView *alertView = [[UIAlertView alloc ]initWithTitle:title message:messageShow delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        
        [alertView show];
        [alertView release];
        [title release];
        [messageShow release];
    }
    else
    {
        [navController pushViewController:agtTableViewController animated:YES];
        self.webAddr = mAgtInfoWebAddr;
        [self requestData];
        self.webAddr = allGrpInfoWebAddr;
        self.selectedGrpId = @"_ALLGROUPS_";
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *grpDict =  [allGrpInfoDictArray objectAtIndex:indexPath.row];
    NSString *title = [[NSString alloc]initWithFormat:@"%@  详情",[grpDict objectForKey:@"grpname"]];
    NSString *messageShow = [[NSString alloc]initWithFormat:@"转座席量%d   接通量%d\n接通率%d%%   注册数%d\n空闲数%d   暂停数%d\n排队数%d",[[grpDict objectForKey:@"transagt"]intValue],[[grpDict objectForKey:@"agtanswer"]intValue],(NSInteger)([[grpDict objectForKey:@"answerrate"]floatValue]*100),[[grpDict objectForKey:@"login"]intValue],[[grpDict objectForKey:@"grpfree"]intValue],[[grpDict objectForKey:@"pause"]intValue],[[grpDict objectForKey:@"queue"]intValue]];
    UIAlertView *alertView = [[UIAlertView alloc ]initWithTitle:title message:messageShow delegate:nil cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    
    [alertView show];
    [alertView release];
    [title release];
    [messageShow release];
}


#pragma mark - download and update data
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
    
    ASIHTTPRequest *allGrpInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:webAddr]];
    [allGrpInfoRequest setDelegate:self];
    [allGrpInfoRequest startAsynchronous];    
}



- (void)requestFinished:(ASIHTTPRequest*)request
{
    requestFailedCount = 0;
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];    
    if ([request.url.absoluteString isEqualToString:allGrpInfoWebAddr]) {
        if (![allGrpInfoCashResponseStr isEqualToString:responseString]) {
            NSArray *tmpArray = [responseString JSONValue];
            self.allGrpInfoCashResponseStr = responseString;
            self.allGrpInfoDictArray = nil;
            groupTableViewController.dataDictArray = nil;
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]]) {
                self.allGrpInfoDictArray = tmpArray;
                groupTableViewController.dataDictArray = tmpArray;
            }
            if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:WithMessage:)]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
                NSString *timeString=[formatter stringFromDate: [NSDate date]];
                [formatter release];
                [delegate willInfoBoardUpdateUIOnPage:4 WithMessage:timeString];
            }
            if (ifLoading==NO){
                [self hideWaiting];
            }
            (self.view == originView)?[self updateOriginView:request]:[self updateLandscapeView:request];
        }
    }
    else if ([request.url.absoluteString isEqualToString:mAgtInfoWebAddr])
    {
        self.webAddr = agtCallInfoWebAddr;
        [self requestData];
        if (![mAgtInfoCashResponseStr isEqualToString:responseString]) {
            NSArray *tmpArray = [responseString JSONValue];
            self.mAgtInfoCashResponseStr = responseString;
            NSMutableDictionary *selectedAgtDict = [[NSMutableDictionary alloc]init ];
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {
                for (NSDictionary *anyAgt in tmpArray) {
                    if ([selectedGrpId isEqualToString:@"_ALLGROUPS_"]) {
                        [selectedAgtDict setObject:anyAgt forKey:[anyAgt objectForKey:@"agtid"]];
                    }
                    else if ([[anyAgt objectForKey:@"agtlogongrps"] rangeOfString:selectedGrpId].length>0) {
                        [selectedAgtDict setObject:anyAgt forKey:[anyAgt objectForKey:@"agtid"]];
                    }
                }
                self.mAgtInfoDict = (NSDictionary*)selectedAgtDict;
            }
        }
    }
    else if ([request.url.absoluteString isEqualToString:agtCallInfoWebAddr])
    {
        self.webAddr = allGrpInfoWebAddr;
        if (![agtCallInfoCashResponseStr isEqualToString:responseString]) {
            NSArray *tmpArray = [responseString JSONValue];
            self.agtCallInfoCashResponseStr = responseString;
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {
                for (NSDictionary *anyAgt in tmpArray) {
                    if ([mAgtInfoDict objectForKey:[anyAgt objectForKey:@"agtid"]]) 
                    {
                        [[mAgtInfoDict objectForKey:[anyAgt objectForKey:@"agtid"]]setObject:[anyAgt objectForKey:@"agtanswerrate"] forKey:@"agtanswerrate"];
                        [[mAgtInfoDict objectForKey:[anyAgt objectForKey:@"agtid"]]setObject:[anyAgt objectForKey:@"agtcallcnt"] forKey:@"agtcallcnt"];
                    }
                }
                NSArray *keys = [[mAgtInfoDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
                agtTableViewController.dataDictArray = [mAgtInfoDict objectsForKeys:keys notFoundMarker:@"NEVERTOBEUSED"];
                (self.view == originView)?[self updateOriginView:request]:[self updateLandscapeView:request];
            }
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

#pragma mark - UI Update Methods
- (void) updateOriginView:(ASIHTTPRequest*)request
{
    if (!request) {
        [((UITableViewController*)navController.topViewController).tableView reloadData];
    }
    else if ([request.url.absoluteString isEqualToString:allGrpInfoWebAddr] )
    {
        [groupTableViewController.tableView reloadData];
    }
    else if ([request.url.absoluteString isEqualToString:agtCallInfoWebAddr])
    {
        [agtTableViewController.tableView reloadData];
    }
    
}
- (void) updateLandscapeView:(ASIHTTPRequest*)request;
{

}

- (void)cleanUI
{
    groupTableViewController.dataDictArray = nil;
    [groupTableViewController.tableView reloadData];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == groupTableViewController) {
        agtTableViewController.dataDictArray = nil;
        [agtTableViewController.tableView reloadData];
        [navigationController setNavigationBarHidden:YES];
    }
    else
    {
        [navigationController setNavigationBarHidden:NO];
        navController.navigationBar.topItem.leftBarButtonItem.title = @"返回";
        [self requestData];
    }
}

@end
