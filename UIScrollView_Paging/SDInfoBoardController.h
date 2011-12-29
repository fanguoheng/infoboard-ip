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




- (void)setAddrWithAddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AddrPrefix:(NSString*)addrPrefixSet AddrPostfix:(NSString*)addrPostfixSet;

- (void) dataUpdateStart;
- (void) dataUpdatePause;
- (void) requestData;
- (void) updateOriginView;
- (void) updateLandscapeView;

- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number;


@end
