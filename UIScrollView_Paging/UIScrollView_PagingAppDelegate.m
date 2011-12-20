//
//  UIScrollView_PagingAppDelegate.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import "StatisticsController.h"
#import "RealtimeMonitorController.h"
#import "DetailsViewController.h"
#import "Reachability.h"
#include <arpa/inet.h>
#import "UIScrollView_PagingAppDelegate.h"

#import "UIScrollView_PagingViewController.h"

@implementation UIScrollView_PagingAppDelegate


@synthesize window=_window;

@synthesize viewController=_viewController;

//@synthesize connectionFailureCount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    //hostReach = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];

    
    struct sockaddr_in hostAddress;
    hostAddress.sin_len = sizeof(hostAddress);
    hostAddress.sin_family = AF_INET;
    hostAddress.sin_port = htons(8502);
    hostAddress.sin_addr.s_addr = inet_addr("121.32.133.59");
    hostReach = [[Reachability reachabilityWithAddress:&hostAddress] retain];
    [hostReach startNotifier];
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //NSLog(@"applicationWillResignActive:");
    
    //[self.viewController startTimersPaged];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"applicationDidEnterBackground:");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    //NSLog(@"applicationWillTerminate:");
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

# pragma mark - Reachability
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告"
                              message:@"网络连接已断开"
                              delegate:nil
                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}                      
@end
