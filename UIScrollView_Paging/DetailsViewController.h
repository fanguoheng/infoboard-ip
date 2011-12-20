//
//  DetailsViewContrller.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-6-2.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDInfoBoardUIUpdate.h"
@class ASIHTTPRequest;
@class GroupTableViewController;
@class AgtTableViewController;
@interface DetailsViewController : UIViewController <UITableViewDelegate,UINavigationControllerDelegate>{
    NSString *allGrpInfoWebAddr;
    NSString *agtInfoWebAddr;
    
    NSTimer *timer;
    NSInteger refreshInterval;
    
    NSMutableArray *magtInfoDictArray;
    
    NSString *num0Str;
    NSString *num1Str;
    NSString *num2Str;
    
    UIView *originView;
    UIView *landscapeView;
    NSMutableArray *lists;
}
@property (nonatomic, assign) id <SDInfoBoardUpdateUI> delegate;
@property (nonatomic, copy) NSString* allGrpInfoCashResponseStr;
@property (nonatomic, copy) NSString* mAgtInfoCashResponseStr;
@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;
@property (nonatomic, copy) NSString *webAddr;
@property (nonatomic, copy) NSString *mAgtInfoWebAddr;
@property (nonatomic, copy) NSString *allGrpInfoWebAddr;
@property (nonatomic, copy) NSString *selectedGrpId;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic) NSInteger refreshInterval;

@property (copy) NSString *workStatusResultStr;
@property (copy) NSString *loginStr;
@property (copy) NSString *pauseStr;
@property (copy) NSString *workStatusStr;
@property (copy) NSString *occupyStr;

@property (nonatomic, retain) NSArray *allGrpInfoDictArray;
@property (nonatomic, retain) NSArray *magtInfoDictArray;
@property (copy) NSString *num0Str;
@property (copy) NSString *num1Str;
@property (copy) NSString *num2Str;

@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;
@property (nonatomic, retain) IBOutlet UIView *controlPadView;
@property (nonatomic, retain) IBOutlet UISlider *refreshIntervalSlider;
@property (nonatomic, retain) IBOutlet UILabel *refreshIntervalLabel;
@property (nonatomic, retain) IBOutlet UIButton *pauseOrStartButton;
@property (nonatomic, retain) NSMutableArray *lists;

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) GroupTableViewController *groupTableViewController;
@property (nonatomic, retain) AgtTableViewController *agtTableViewController;


- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;
- (void) dataUpdateStart;
- (void) dataUpdatePause;
- (void) requestData;
- (void) updateOriginView:(ASIHTTPRequest*)request;
- (void) updateLandscapeView:(ASIHTTPRequest*)request;
- (void) cleanUI;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)showControlPadView:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)pauseOrStart:(id)sender;
@end
