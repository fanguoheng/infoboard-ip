//
//  SDBackForwardViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SDBackForwadControllerDelegate;

@interface SDBackForwardViewController : UIViewController

@property (nonatomic, copy) NSString* tagStr;
@property (nonatomic, assign) id<SDBackForwadControllerDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tagStr:(NSString*)tagStrOrNil;
-(void) goBack;
-(void) goForward;
@end

@protocol SDBackForwadControllerDelegate <NSObject>
@optional
-(void)needGoBackWithControllerTagStr:(NSString*)tagStr message:(id)msg;
-(void)needGoForwardWithControllerTagStr:(NSString*)tagStr message:(id)msg;
@end