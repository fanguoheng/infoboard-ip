//
//  SDLoginViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SDLoginViewController.h"
#import "MD5.h"
@implementation SDLoginViewController
@synthesize username,password,ipAddr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    usernameTextField.tag = 1;
    passwordTextField.tag = 2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - user input
- (IBAction)textFieldDoneEditing:(id)sender
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];  
    UITextField *theTextField = (UITextField*)sender;
    switch (theTextField.tag) {
        case 1:
        {
            self.username = theTextField.text;
            [df setValue:self.username forKey:@"username"];
            break;
        }
        case 2:
        {
            self.password = theTextField.text;
            [df setValue:self.password forKey:@"password"];
            break;
        } 
            
        default:
            break;
    }
    [sender resignFirstResponder];
}
#pragma mark - Decrypt
- (NSString*) getEncryptedIpWithHostStr:(NSString*)hostStrOrNil username:(NSString*)usernameOrNil password:(NSString*)passwordOrNil
{
    //@"172.16.23.73:8080"
    //封装soap请求消息
    NSMutableString *namePwd = [[NSMutableString alloc]initWithString:usernameOrNil];
    [namePwd appendString:passwordOrNil];
    NSString *namePwdMD5 = [[NSString alloc]initWithString:[namePwd md5]];
    [namePwd release];
	NSString *soapMessage = 
    [NSString stringWithFormat:
     @"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:loc=\"http://localhost:8080/\">\n"
     "<soapenv:Header/>\n"
     "<soapenv:Body>\n"
     "<loc:SecureLogin>\n"
     "<strSecure>%@</strSecure>\n"
     "<AppId>%@</AppId>\n"
     "</loc:SecureLogin>\n"
     "</soapenv:Body>\n"
     "</soapenv:Envelope>",namePwdMD5,@"IOS"];
	//NSLog(@"%@",soapMessage);
	//请求发送到的路径
    NSString *urlStr = [[NSString alloc]initWithFormat:@"http://%@/MapService/LoginServerPort?wsdl",hostStrOrNil];
	NSURL *url = [[NSURL alloc ]initWithString:urlStr];
    [urlStr release];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    [url release];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	//以下对请求信息添加属性前四句是必有的，第五句是soap信息。
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://172.16.23.73:8080/MapService/LoginServerPort?wsdl" forHTTPHeaderField:@"SOAPAction"];
	
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	//请求
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	//如果连接已经建好，则初始化data
	/*if( theConnection )
	{
		webData = [[NSMutableData alloc]init];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}*/

}
- (void) goBack
{
    [self.delegate needGoBackWithControllerTagStr:self.tagStr message:nil];
}
- (void) goForward
{
    NSDictionary *msgDict = [[NSDictionary alloc]initWithObjectsAndKeys:username,@"username",password,@"password", nil];
    [self.delegate needGoForwardWithControllerTagStr:self.tagStr message:msgDict];
}
@end
