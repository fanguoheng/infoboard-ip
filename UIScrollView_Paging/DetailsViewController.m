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
@synthesize allGrpInfoWebAddr,mAgtInfoWebAddr;


@synthesize timer,refreshInterval;

//@synthesize agtInfoDictArray;
//@synthesize allGrpInfoDictArray;

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
        
        GroupTableViewController *_groupTableViewController = [[GroupTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.groupTableViewController = _groupTableViewController;
        [_groupTableViewController release];
        AgtTableViewController *_agtTableViewController = [[AgtTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.agtTableViewController = _agtTableViewController;
        [_agtTableViewController release];
    
        
    }
    return self;
}

- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    
    //self.agtInfoWebAddr = [[NSString alloc]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/mAgtInfo.json"];
    //self.allGrpInfoWebAddr =   [[NSString alloc]initWithString:@"http://121.32.133.59:8502/FlexBoard/JsonFiles/AllGrpInfo.json"];
    self.addrPrefix = addrPrefixSet;
    self.addrPostfix = addrPostfixSet;
    //self.agtInfoWebAddr = [[NSString alloc ]initWithFormat:@"%@mAgtInfo%@",addrPrefix,addrPostfix];
    self.allGrpInfoWebAddr = [[NSString alloc ]initWithFormat:@"%@AllGrpInfo%@",addrPrefix,addrPostfix];
    //NSLog(@"%@",allGrpInfoWebAddr);
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
    //navController.delegate = self;
    //[navController.navigationBar setFrame:CGRectMake(navController.navigationBar.frame.origin.x, navController.navigationBar.frame.origin.x, navController.navigationBar.frame.size.width, navController.navigationBar.frame.size.height*0.618f)];
    navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    navController.navigationBar.topItem.title =@"组名   转座席量 接通量 接通率";
    [navController.view setFrame:CGRectMake(0.0f, 00.0f, 320.0f, 385.0f)];
    [self.view addSubview:navController.view];
    
    UIImage *pauseImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"media-playback-pause" ofType:@"png"]];
    [pauseOrStartButton setImage:pauseImage forState:UIControlStateNormal];
    UIImage *startImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"media-playback-start" ofType:@"png"]];
    [pauseOrStartButton setImage:startImage forState:UIControlStateSelected];

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

/*
#pragma mark - Table View Data Source Methods



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return [allGrpInfoDictArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    static NSString *CustomCellPortraitIdentifier = @"CustomCellPortraitIdentifier";
    CustomCellPortrait *cellPortrait = (CustomCellPortrait *)[tableView dequeueReusableCellWithIdentifier:CustomCellPortraitIdentifier];
    if (cellPortrait == nil)
    {
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
    
        return cellPortrait;
     
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
*/

#pragma mark - download and update data
- (void)requestData
{
    ASIHTTPRequest *allGrpInfoRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:allGrpInfoWebAddr]];
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
    else if (![request.url.absoluteString isEqualToString:mAgtInfoCashResponseStr])
    {
        NSArray *tmpArray = [responseString JSONValue];
        if ([tmpArray count]&&![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
<<<<<<< master
        {
            
=======
        {     
>>>>>>> local
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
    [groupTableViewController.tableView reloadData];
}
- (void) updateLandscapeView:(ASIHTTPRequest*)request;
{

}

- (void)cleanUI
{
    groupTableViewController.dataDictArray = nil;
    [groupTableViewController.tableView reloadData];
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
