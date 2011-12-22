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
@synthesize allGrpInfoWebAddr,mAgtInfoWebAddr,webAddr;
@synthesize selectedGrpId;

@synthesize timer,refreshInterval;


@synthesize workStatusResultStr;
@synthesize loginStr;
@synthesize pauseStr;
@synthesize workStatusStr;
@synthesize occupyStr;

@synthesize num0Str;
@synthesize num1Str;
@synthesize num2Str;


@synthesize originView;
@synthesize landscapeView;
@synthesize controlPadView,refreshIntervalLabel,refreshIntervalSlider,pauseOrStartButton;
@synthesize lists;
@synthesize navController,groupTableViewController,agtTableViewController;
@synthesize delegate,allGrpInfoCashResponseStr,mAgtInfoCashResponseStr;
@synthesize loadingOrigin,loadingLandscape;
@synthesize ifLoading;
@synthesize allGrpInfoDictArray,magtInfoDictArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.lists = [[NSMutableArray alloc] init];
        
        self.num0Str = [NSString stringWithFormat:@"%@",@"0"];
        self.num1Str = [NSString stringWithFormat:@"%@",@"1"];
        self.num2Str = [NSString stringWithFormat:@"%@",@"2"];
        allGrpInfoCashResponseStr = [[NSString alloc]init];
        mAgtInfoCashResponseStr = [[NSString alloc]init];
        
        groupTableViewController  = [[GroupTableViewController alloc]initWithStyle:UITableViewStylePlain];
        groupTableViewController.tableView.delegate = self;
        agtTableViewController = [[AgtTableViewController alloc]initWithStyle:UITableViewStylePlain];    
        
    }
    return self;
}

- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    
    //self.agtInfoWebAddr = [[NSString alloc]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/mAgtInfo.json"];
    //self.allGrpInfoWebAddr =   [[NSString alloc]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/AllGrpInfo.json"];
    self.addrPrefix = addrPrefixSet;
    self.addrPostfix = addrPostfixSet;
    NSString *str1 = [[NSString alloc]initWithFormat:@"%@AllGrpInfo%@",addrPrefix,addrPostfix];
    self.allGrpInfoWebAddr = str1;
    [str1 release];
    NSString *str2 = [[NSString alloc]initWithFormat:@"%@MAgtInfo%@",addrPrefix,addrPostfix];
    self.mAgtInfoWebAddr = str2;
    self.webAddr = allGrpInfoWebAddr;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)AddrPostfixSet
{
    [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setAddrWithAddrPrefix:addrPrefixSet AddrPostfix:AddrPostfixSet];


    
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
    [controlPadView setFrame:CGRectMake(0.0f, 30.0f, 320.0f, 44.0f)];
    
    UINavigationController *_navController = [[UINavigationController alloc ]initWithRootViewController:groupTableViewController];
    self.navController = _navController;
    [_navController release];
    navController.delegate = self;
    navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    navController.navigationBar.topItem.title =@"组名   转座席量 接通量 接通率";
    [navController.view setFrame:CGRectMake(0.0f, 00.0f, 320.0f, 379.0f)];
    [self.view addSubview:navController.view];
    
    UIImage *pauseImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"media-playback-pause" ofType:@"png"]];
    [pauseOrStartButton setImage:pauseImage forState:UIControlStateNormal];
    UIImage *startImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"media-playback-start" ofType:@"png"]];
    [pauseOrStartButton setImage:startImage forState:UIControlStateSelected];

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
        self.selectedGrpId = [[groupTableViewController.dataDictArray objectAtIndex:indexPath.row]objectForKey:@"grpid"];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
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
        NSLog(@"%d showWaing",ifLoading);
        ifLoading=NO;
    }
    NSLog(@"%d ifLoading in requestData",ifLoading);
    
    ASIHTTPRequest *allGrpInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:webAddr]];
    [allGrpInfoRequest setDelegate:self];
    [allGrpInfoRequest startAsynchronous];    
}



- (void)requestFinished:(ASIHTTPRequest*)request
{
    NSLog(@"SUCCEED");
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];    
    if (![request.url.absoluteString isEqualToString:allGrpInfoCashResponseStr]) {
        NSArray *tmpArray = [responseString JSONValue];
        if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]]) {
            self.allGrpInfoCashResponseStr = responseString;
            groupTableViewController.dataDictArray = tmpArray;
            
            if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:)]) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YY-MM-dd hh:mm:ss"];
                NSString *timeString=[formatter stringFromDate: [NSDate date]];
                [formatter release];
                [delegate willInfoBoardUpdateUIOnPage:timeString];
            }                
            [groupTableViewController.tableView reloadData];
        }
    }
    else if ([request.url.absoluteString isEqualToString:mAgtInfoWebAddr])
    {
        NSArray *tmpArray = [responseString JSONValue];
        if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
    [responseString release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"FAILED");
    //NSError *error = [request error];
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
        [navigationController setNavigationBarHidden:YES];
    }
    else
    {
        [navigationController setNavigationBarHidden:NO];
        navController.navigationBar.topItem.leftBarButtonItem.title = @"返回";
        [self requestData];
        self.webAddr = allGrpInfoWebAddr;
    }
}
#pragma mark - touch and controlPad
- (IBAction)showControlPadView:(id)sender
{
    UIButton *tietleButton = (UIButton *)sender;
    tietleButton.selected = !tietleButton.selected;
    if(tietleButton.selected)
    {
       
        refreshIntervalSlider.value = refreshInterval;
        NSString *refreshIntervalStr = [[NSString alloc]initWithFormat:@"%d", refreshInterval];
        refreshIntervalLabel.text = refreshIntervalStr;
        [refreshIntervalStr release];
        [self.view addSubview:controlPadView];
    }
    else
    {
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
        if (df) {  
            NSNumber *_refreshInterval = [[NSNumber alloc]initWithInt:refreshInterval];
            [df setObject:_refreshInterval forKey:@"detailsviewinterval"]; 
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
