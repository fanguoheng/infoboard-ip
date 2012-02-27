//
//  DetailsViewContrller.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDInfoBoardUIUpdate.h"
#import "DetailHeaderView.h"
@class ASIHTTPRequest;
@class GroupTableViewController;
@class AgtTableViewController;

@interface DetailsViewController : UIViewController <UITableViewDelegate,UINavigationControllerDelegate,ClickableViewDelegate>{
    
    NSString *allGrpInfoWebAddr;
    NSString *agtInfoWebAddr;
    NSTimer *timer;
    NSInteger refreshInterval;
    NSMutableArray *magtInfoDictArray;
    UIView *originView;
    UIView *landscapeView;
    NSMutableArray *lists;
    NSInteger requestFailedCount;
}
@property (nonatomic, assign) id <SDInfoBoardUpdateUI> delegate;
@property (nonatomic, copy) NSString* allGrpInfoCashResponseStr;
@property (nonatomic, copy) NSString* mAgtInfoCashResponseStr;
@property (nonatomic, copy) NSString* agtCallInfoCashResponseStr;
@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;

@property (nonatomic, copy) NSString *webAddr;
@property (nonatomic, copy) NSString *allGrpInfoWebAddr;
@property (nonatomic, copy) NSString *mAgtInfoWebAddr;
@property (nonatomic, copy) NSString *agtCallInfoWebAddr;
@property (nonatomic, copy) NSString *selectedGrpId;
@property (nonatomic, retain) NSTimer *timer;

@property (copy) NSString *workStatusResultStr;
@property (copy) NSString *loginStr;
@property (copy) NSString *pauseStr;
@property (copy) NSString *workStatusStr;
@property (copy) NSString *occupyStr;


@property (nonatomic, retain) NSArray *allGrpInfoDictArray;
@property (nonatomic, retain) NSDictionary *mAgtInfoDict;

@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;

@property (nonatomic, retain) NSMutableArray *lists;

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) GroupTableViewController *groupTableViewController;
@property (nonatomic, retain) AgtTableViewController *agtTableViewController;
@property (nonatomic, retain) UIActivityIndicatorView *loadingOrigin;
@property (nonatomic, retain) UIActivityIndicatorView *loadingLandscape;
@property (nonatomic, readwrite) BOOL ifLoading;

- (void)setAddrWithAddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)newAddrPrefix AddrPostfix:(NSString*)newAddrPostfix;
- (void) dataUpdateStart;
- (void) dataUpdatePause;
- (void) requestData;
- (void) updateOriginView:(ASIHTTPRequest*)request;
- (void) updateLandscapeView:(ASIHTTPRequest*)request;
- (void) cleanUI;

@end
