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
<<<<<<< master
@synthesize allGrpInfoWebAddr,mAgtInfoWebAddr;

=======
@synthesize allGrpInfoWebAddr,mAgtInfoWebAddr,agtCallInfoWebAddr,webAddr;
@synthesize selectedGrpId;
>>>>>>> local

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
@synthesize delegate,allGrpInfoCashResponseStr,mAgtInfoCashResponseStr,agtCallInfoCashResponseStr;
@synthesize loadingOrigin,loadingLandscape;
@synthesize ifLoading;
<<<<<<< master
=======
@synthesize allGrpInfoDictArray,mAgtInfoDict;

>>>>>>> local
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
        agtCallInfoCashResponseStr = [[NSString alloc]init];
        
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
<<<<<<< master
    //self.agtInfoWebAddr = [[NSString alloc ]initWithFormat:@"%@mAgtInfo%@",addrPrefix,addrPostfix];
    self.allGrpInfoWebAddr = [[NSString alloc ]initWithFormat:@"%@AllGrpInfo%@",addrPrefix,addrPostfix];
    //NSLog(@"%@",allGrpInfoWebAddr);
=======
    NSString *str1 = [[NSString alloc]initWithFormat:@"%@AllGrpInfo%@",addrPrefix,addrPostfix];
    self.allGrpInfoWebAddr = str1;
    [str1 release];
    NSString *str2 = [[NSString alloc]initWithFormat:@"%@MAgtInfo%@",addrPrefix,addrPostfix];
    self.mAgtInfoWebAddr = str2;
    NSString *str3 = [[NSString alloc]initWithFormat:@"%@AgtCallInfo%@",addrPrefix,addrPostfix];
    self.agtCallInfoWebAddr = str3;
    self.webAddr = allGrpInfoWebAddr;
    
>>>>>>> local
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


    static NSString *CustomCellPortraitIdentifier = @"CustomCellPortraitIdentifier";
    CustomCellPortrait *cellPortrait = (CustomCellPortrait *)[tableView dequeueReusableCellWithIdentifier:CustomCellPortraitIdentifier];
    if (cellPortrait == nil)
    {
<<<<<<< master
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellPortrait" owner:self options:nil];
        for (id oneObject in nib)
                if([oneObject isKindOfClass:[CustomCellPortrait class]])
                    cellPortrait = (CustomCellPortrait *)oneObject;
    } 

    NSDictionary *grpDict =  [allGrpInfoDictArray objectAtIndex:indexPath.row];
    float answerRate = [[grpDict objectForKey:@"answerrate"]floatValue];
    UIColor *answerRateColor = [UIColor colorWithRed:(1.0f-answerRate) green:answerRate blue:0.25f alpha:1.0f];
    cellPortrait.groupIcon.backgroundColor = answerRateColor;
    cellPortrait.grpName.text = [grpDict objectForKey:@"grpname"];
    cellPortrait.grpName.textColor = answerRateColor;
    //cellPortrait.login.text = [NSString stringWithFormat:@"%d",[[grpDict objectForKey:@"login"]intValue]];
    cellPortrait.transAgt.text = [NSString stringWithFormat:@"%d",[[grpDict objectForKey:@"transagt"]intValue]];
    cellPortrait.agtAnswer.text = [NSString stringWithFormat:@"%d",[[grpDict objectForKey:@"agtanswer"]intValue]];
    cellPortrait.answerRate.text = [NSString stringWithFormat:@"%d",(NSInteger)(answerRate*100)];
    cellPortrait.answerRate.textColor = answerRateColor;
    cellPortrait.percentSign.textColor = answerRateColor;
    //cellPortrait.queueLen.text = [NSString stringWithFormat:@"%d",[[grpDict objectForKey:@"queuelen"]intValue]];
        
    CVTableCellBGView *bgView = [[CVTableCellBGView alloc] init];
    bgView.cellStyle = CellStyleMiddle;
    bgView.gradientColor = GradientColorBlack;
    [cellPortrait setBackgroundView:bgView];
    [bgView release];
=======
        [navController pushViewController:agtTableViewController animated:YES];
        self.webAddr = mAgtInfoWebAddr;
        [self requestData];
        self.webAddr = allGrpInfoWebAddr;
        self.selectedGrpId = [[groupTableViewController.dataDictArray objectAtIndex:indexPath.row]objectForKey:@"grpid"];
    }
>>>>>>> local
    
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
    NSLog(@"SUCCEED");
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];    
<<<<<<< master
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
=======
    if ([request.url.absoluteString isEqualToString:allGrpInfoWebAddr]) {
        if (![allGrpInfoCashResponseStr isEqualToString:responseString]) {
            NSArray *tmpArray = [responseString JSONValue];
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]]) {
                self.allGrpInfoCashResponseStr = responseString;
                self.allGrpInfoDictArray = tmpArray;
                groupTableViewController.dataDictArray = tmpArray;
                
                if ([delegate respondsToSelector:@selector(willInfoBoardUpdateUIOnPage:)]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YY-MM-dd hh:mm:ss"];
                    NSString *timeString=[formatter stringFromDate: [NSDate date]];
                    [formatter release];
                    [delegate willInfoBoardUpdateUIOnPage:timeString];
                }
                if (ifLoading==NO){
                    [self hideWaiting];
                    //NSLog(@"hideWating");
                }
                (self.view == originView)?[self updateOriginView:request]:[self updateLandscapeView:request];
>>>>>>> local
            }
        }
    }
    else if ([request.url.absoluteString isEqualToString:mAgtInfoWebAddr])
    {
<<<<<<< master
        NSArray *tmpArray = [responseString JSONValue];
        if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
        {
            if (ifLoading==NO){
                [self hideWaiting];
                NSLog(@"hideWating");
=======
        if (![mAgtInfoCashResponseStr isEqualToString:responseString]) {
            NSArray *tmpArray = [responseString JSONValue];
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {
                self.mAgtInfoCashResponseStr = responseString;
                NSMutableDictionary *selectedAgtDict = [[NSMutableDictionary alloc]init ];
                for (NSDictionary *anyAgt in tmpArray) {
                    if ([[anyAgt objectForKey:@"agtlogongrps"] rangeOfString:selectedGrpId].length>0) {
                        [selectedAgtDict setObject:anyAgt forKey:[anyAgt objectForKey:@"agtid"]];
                    }
                }
                self.mAgtInfoDict = (NSDictionary*)selectedAgtDict;
                self.webAddr = agtCallInfoWebAddr;
                [self requestData];
                self.webAddr = allGrpInfoWebAddr;
            }
        }
    }
    else if ([request.url.absoluteString isEqualToString:agtCallInfoWebAddr])
    {
        if (![agtCallInfoCashResponseStr isEqualToString:responseString]) {
            NSArray *tmpArray = [responseString JSONValue];
            if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
            {
                self.agtCallInfoCashResponseStr = responseString;
                for (NSDictionary *anyAgt in tmpArray) {
                    if ([mAgtInfoDict objectForKey:[anyAgt objectForKey:@"agtid"]]) 
                    {
                        [[mAgtInfoDict objectForKey:[anyAgt objectForKey:@"agtid"]]setObject:[anyAgt objectForKey:@"agtanswerrate"] forKey:@"agtanswerrate"];
                        [[mAgtInfoDict objectForKey:[anyAgt objectForKey:@"agtid"]]setObject:[anyAgt objectForKey:@"agtcallcnt"] forKey:@"agtcallcnt"];
                    }
                }
                
                agtTableViewController.dataDictArray = [mAgtInfoDict allValues];
                (self.view == originView)?[self updateOriginView:request]:[self updateLandscapeView:request];
>>>>>>> local
            }
        }
    }

    [responseString release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"FAILED");
    //NSError *error = [request error];
}

#pragma mark - UI Update Methods
- (void) updateOriginView:(ASIHTTPRequest*)request
{
<<<<<<< master
    [groupTableViewController.tableView reloadData];
=======
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
    
>>>>>>> local
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
