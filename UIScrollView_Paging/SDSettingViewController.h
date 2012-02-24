//
//  SDSettingViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDBackForwardViewController.h"

@interface SDSettingViewController : SDBackForwardViewController<UIPickerViewDataSource>
{
    IBOutlet UIButton* exitButton;
    IBOutlet UIButton* toSettingViewButton;
}
@property (nonatomic, copy) NSString* responseStr;
@property (nonatomic, copy) NSString* selectedShopId;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) NSMutableDictionary *provincesShops;
@property (nonatomic, retain) NSMutableArray *provinces;
@property (nonatomic, retain) NSMutableArray *shops;
- (IBAction)goBackOrForward:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tagStr:(NSString*)tagStrOrNil responseStr:(NSString *)responseStrOrNil;
-(void)requestAllShopsFromHostAddr:(NSString*)hostAddrOrNil;
- (void) reloadWithResponseStr:(NSString*)responseStrOrNil;
@end
