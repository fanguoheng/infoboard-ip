//
//  SDInfoBoardController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDInfoBoardUIUpdate.h"
@class  ASIHTTPRequest;
@interface SDInfoBoardController : UIViewController
{
 @private
    NSUInteger refreshInterval;
    NSUInteger requestFailedCount;
}
@property (nonatomic, assign) id <SDInfoBoardUpdateUI> delegate;
@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;
@property (nonatomic, retain) NSMutableSet *urlStringSet;

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, readwrite) NSUInteger refreshInterval;
@property (nonatomic, readwrite) NSUInteger requestFailedCountMax;

@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;



- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newnewAddrPostfix;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;
- (void) dataUpdateStart;
- (void) dataUpdatePause;
- (void) requestDataFromAddrArray;
- (void) updateOriginView:(ASIHTTPRequest *)request;
- (void) updateLandscapeView:(ASIHTTPRequest *)request;
- (void) cleanUI;
- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number;
@end

