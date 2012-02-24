//
//  SDLoginViewController.h
//  UIScrollView_Paging
//
//  Created by crazysnow on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDBackForwardViewController.h"
@interface SDLoginViewController : SDBackForwardViewController<NSXMLParserDelegate>
{
    bool rememberPwd;
    bool recordResults;
    IBOutlet UITextField* usernameTextField;
    IBOutlet UITextField* passwordTextField;
    IBOutlet UISwitch* autoLoginSwitch;
    IBOutlet UIButton* exitButton;
    IBOutlet UIButton* toSettingViewButton;
    IBOutlet UILabel* resultLabel;
}
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, copy) NSString* encryptIpAddr;
@property (nonatomic, copy) NSString* ipAddr;

@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;


- (IBAction)textFieldDoneEditing:(id)sender;
- (void) requestEncryptedIpWithHostStr:(NSString*)hostStrOrNil username:(NSString*)usernameOrNil password:(NSString*)passwordOrNil;
- (NSString*) DESDecrypt:(NSData*)data;
-(void)requestAllShopsFromHostAddr:(NSString*)hostAddrOrNil;
@end
