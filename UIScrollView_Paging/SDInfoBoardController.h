//
//  SDInfoBoardController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDInfoBoardController : UIViewController
{
    @private NSUInteger refreshInterval;
}
@property (nonatomic, copy) NSString *addrPrefix;
@property (nonatomic, copy) NSString *addrPostfix;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, readwrite) NSUInteger refreshInterval;

@property (nonatomic, retain) IBOutlet UIView *originView;
@property (nonatomic, retain) IBOutlet UIView *landscapeView;

@property (nonatomic, retain) IBOutlet UIView *controlPadView;
@property (nonatomic, retain) IBOutlet UISlider *refreshIntervalSlider;
@property (nonatomic, retain) IBOutlet UILabel *refreshIntervalLabel;
@property (nonatomic, retain) IBOutlet UIButton *refreshButton;
@property (nonatomic, retain) IBOutlet UIButton *pauseOrStartButton;


- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;

- (void) dataUpdateStart;
- (void) dataUpdatePause;
- (void) requestData;
- (void) updateOriginView;
- (void) updateLandscapeView;

- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)showControlPadView:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)pauseOrStart:(id)sender;
@end
