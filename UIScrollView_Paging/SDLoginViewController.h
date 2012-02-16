//
//  SDLoginViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDBackForwardViewController.h"
@interface SDLoginViewController : SDBackForwardViewController
{
    bool rememberPwd;
    bool autoLogin;
    IBOutlet UITextField* usernameTextField;
    IBOutlet UITextField* passwordTextField;
    IBOutlet UISwitch* rememberPwddSwitch;
    IBOutlet UISwitch* autoLoginSwitch;
    IBOutlet UIButton* exitButton;
    IBOutlet UIButton* toSettingViewButton;
}
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* ipAddr;

- (IBAction)textFieldDoneEditing:(id)sender;

@end
