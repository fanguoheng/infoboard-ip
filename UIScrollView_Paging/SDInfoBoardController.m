//
//  SDInfoBoardController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SDInfoBoardController.h"

@implementation SDInfoBoardController
@synthesize addrPrefix,addrPostfix;
@synthesize timer,refreshInterval;
@synthesize originView,landscapeView;
@synthesize controlPadView,refreshIntervalSlider,refreshIntervalLabel,refreshButton,pauseOrStartButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.refreshInterval = 5;
    }
    return self;
}
- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet
{
    self.addrPrefix = addrPrefixSet;
    self.addrPostfix = addrPostfixSet;
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
    [originView release];
    [landscapeView release];
    [controlPadView release];
    [refreshIntervalSlider release];
    [refreshIntervalLabel release];
    [refreshButton release];
    [pauseOrStartButton release];
    [super dealloc];
}

#pragma mark - overridden setters

//refreshInterval最小值为1
- (void) setRefreshInterval:(NSUInteger)refreshInterValSet
{
    (refreshInterValSet<1)?(refreshInterval = 1):(refreshInterval = refreshInterValSet);
}
#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.originView = nil;
    self.landscapeView  = nil;
    self.controlPadView  = nil;
    self.refreshIntervalSlider  = nil;
    self.refreshIntervalLabel  = nil;
    self.refreshButton  = nil;
    self.pauseOrStartButton  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - dataUpdate
- (void)requestData
{
    //基类中此函数什么也不做
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

#pragma mark - dataUpdate
- (void) updateOriginView
{
    //基类中此函数什么也不做
}
- (void) updateLandscapeView
{
    //基类中此函数什么也不做
}
#pragma mark - controlPad
- (IBAction)showControlPadView:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    theButton.selected = !theButton.selected;
    if(theButton.selected)
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
            [df setObject:_refreshInterval forKey:@"statisticsinterval"]; 
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

#pragma mark - utiles
//将整数变成带逗号的字符串，仅支持小于1,000,000的整数
- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number
{
    if (number < 1000) {
        NSMutableString *resultString = [[NSMutableString alloc ]initWithFormat:@"%d", number];
        return [resultString autorelease];
    }
    else if (number < 1000000)
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
    else
    {
        NSLog(@"mutableStringWithCommaConvertFromInteger:number>1000000 NOT Supported!!");
        NSMutableString *resultString = [[NSMutableString alloc ]initWithFormat:@"%d", number];
        return [resultString autorelease];
    }

}
@end
