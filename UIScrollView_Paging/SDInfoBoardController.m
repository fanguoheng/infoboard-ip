//
//  SDInfoBoardController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SDInfoBoardController.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
@implementation SDInfoBoardController
@synthesize delegate;
@synthesize addrPrefix,addrPostfix,urlStringSet;
@synthesize timer,refreshInterval,requestFailedCountMax;
@synthesize originView,landscapeView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.refreshInterval = 60;
        self.requestFailedCountMax = 6;
        urlStringSet = [[NSMutableSet alloc]init];
    }
    return self;
}
- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix
{
    self.addrPrefix = newAddrPrefix;
    self.addrPostfix = newAddrPostfix;
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
    [originView release];
    [landscapeView release];
    [super dealloc];
}

#pragma mark - overridden setters

//refreshInterval最小值为1
- (void) setRefreshInterval:(NSUInteger)refreshInterValSet
{
    if (refreshInterValSet<1) {
        NSLog(@"wanning: refreshInterVal CANNOT be smaller than 1, set to 1 by default.");
        refreshInterval = 1;
    }
    else
        refreshInterval = (NSUInteger)refreshInterValSet;
}

- (void) setRequestFailedCountMax:(NSUInteger)requestFailedCountMaxSet
{
    if (requestFailedCountMaxSet<1) {
        NSLog(@"wanning: requestFailedCount CANNOT be smaller than 1, set to 1 by default.");
        requestFailedCountMax = 1;
    }
    else    
        requestFailedCountMax = (NSUInteger)requestFailedCountMaxSet;
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - dataUpdate
- (void)requestDataFromAddrArray
{
    for (NSString *addr in urlStringSet) {
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:addr]];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}
- (void)dataUpdateStart
{
    if (timer == nil) {
        [self requestDataFromAddrArray];
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

- (void)requestFinished:(ASIHTTPRequest *)request
{
    requestFailedCount = 0;
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    requestFailedCount ++;
    if (requestFailedCount < requestFailedCountMax) {
        ASIHTTPRequest *newRequest = [[request copy] autorelease]; 
        [newRequest startAsynchronous]; 
    }
}

#pragma mark - UIUpdate
- (void) updateOriginView:(ASIHTTPRequest *)request
{
    //基类中此函数什么也不做
}
- (void) updateLandscapeView:(ASIHTTPRequest *)request
{
    //基类中此函数什么也不做
}

- (void) cleanUI
{
    //基类中此函数什么也不做
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
