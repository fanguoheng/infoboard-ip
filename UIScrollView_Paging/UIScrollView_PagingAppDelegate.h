//
//  UIScrollView_PagingAppDelegate.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-6-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reachability;
@class UIScrollView_PagingViewController;

@interface UIScrollView_PagingAppDelegate : NSObject <UIApplicationDelegate> {
    Reachability  *hostReach;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UIScrollView_PagingViewController *viewController;


- (void)reachabilityChanged:(NSNotification *)note;

@end
