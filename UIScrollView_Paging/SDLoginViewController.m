//
//  SDLoginViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 12-2-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SDLoginViewController.h"
#import "MD5.h"
#import "NSDataAdditions.h"
#include <CommonCrypto/CommonCryptor.h>
#import "JSON.h"
#import "ASIHTTPRequest.h"
#import "ASIAuthenticationDialog.h"
@implementation SDLoginViewController
@synthesize username,password,encryptIpAddr,ipAddr;
@synthesize webData,soapResults,xmlParser;
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
    exitButton.tag = 3;
    toSettingViewButton.tag = 4;
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    usernameTextField.text = [df objectForKey:@"username"];
    if ([[df objectForKey:@"autoLogin"]intValue]) {
        passwordTextField.text = [df objectForKey:@"password"];
        [autoLoginSwitch setOn:YES];
        [self goForward];
    }else
    {
        [autoLoginSwitch setOn:NO];
    }
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
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (IBAction)aotoLoginOrNot:(id)sender
{
    NSNumber *autoLoginNum = [[NSNumber alloc]initWithInt:autoLoginSwitch.isOn];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults]; 
    if (df) {
        if (!autoLoginSwitch.isOn) {
            passwordTextField.text = nil;
            [df setValue:nil forKey:@"password"];
        }
        [df setValue:autoLoginNum forKey:@"autoLogin"];
        [df synchronize];
    }
}
#pragma mark - Decrypt
- (void) requestEncryptedIpWithHostStr:(NSString*)hostStrOrNil username:(NSString*)usernameOrNil password:(NSString*)passwordOrNil
{
    
    if (!usernameOrNil || !passwordOrNil) {
        resultLabel.text = @"用户名或密码不能为空，请重新输入";
        return;
    }
    //封装soap请求消息
    self.soapResults=nil;
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
	if( theConnection )
	{
		webData = [[NSMutableData alloc]init];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}

}
- (void) goBack
{
    [self.delegate needGoBackWithControllerTagStr:self.tagStr message:nil];
}
- (void) goForward
{
    self.username = usernameTextField.text;
    self.password = passwordTextField.text;
    NSNumber *autoLoginNum = [[NSNumber alloc]initWithInt:autoLoginSwitch.isOn];
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults]; 
    if (df) {
        [df setValue:self.username forKey:@"username"];
        autoLoginSwitch.isOn?[df setValue:self.password forKey:@"password"]:[df setValue:nil forKey:@"password"];
        [df setValue:autoLoginNum forKey:@"autoLogin"];
        [df synchronize];
    }
    [autoLoginNum release];
    [self requestEncryptedIpWithHostStr:@"172.16.23.73:8080" username:self.username password:self.password];
}

- (IBAction)goBackOrForward:(id)sender
{
    switch (((UIButton*)sender).tag) {
        case 3:
            [self goBack];
            break;
        case 4:
            [self goForward];
        default:
            break;
    }
}
#pragma mark - url connect

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}

//如果电脑没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	[theXML release];
	
	//重新加載xmlParser
	if( xmlParser )
	{
		[xmlParser release];
	}
	
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
	[connection release];
	//[webData release];
}
#pragma mark - XML
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{ 
    if( [elementName isEqualToString:@"return"])
	{
		if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
		recordResults = YES;
	}
	
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordResults )
	{
		[soapResults appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"return"])
	{
		recordResults = FALSE;
        NSDictionary *recordResultsDict = [[soapResults JSONValue] objectAtIndex:0];
        if (1 == [[recordResultsDict objectForKey:@"state"] intValue]) {
            resultLabel.text = @"登陆成功";
            self.encryptIpAddr = [recordResultsDict objectForKey:@"value"];
            
            NSData *base64DecodedIpAddr =[[NSData alloc]initWithBase64EncodedString:self.encryptIpAddr];
            self.ipAddr = [self DESDecrypt:base64DecodedIpAddr];
            [self requestAllShopsFromHostAddr:ipAddr];
        }
        else{
            resultLabel.text = @"用户名或密码错误";
        }
	}
}

#pragma mark - DES
- (NSString*) DESDecrypt:(NSData*)data
{
    char* encryptBytes = (char *)[data bytes];
    char buffer [58] ;
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesEncrypted ;
    char key [] = "546789231068" ;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, 
                                          kCCAlgorithmDES,                                 
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,                                          
                                          key,                                           
                                          kCCKeySizeDES,                                          
                                          NULL,                                           
                                          encryptBytes,                                          
                                          strlen(encryptBytes),                                          
                                          buffer,                                           
                                          58,                                          
                                          &numBytesEncrypted);    
    if(kCCSuccess==cryptStatus){
        
        NSMutableData *myData = [NSMutableData dataWithBytes:(const void *)buffer length:(NSUInteger)numBytesEncrypted];
        NSString *decryptStr = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
        return [decryptStr autorelease];
    }
    return nil;
}

#pragma mark - shops selection
-(void)requestAllShopsFromHostAddr:(NSString*)hostAddrOrNil
{
    NSString *shopListAddr = [[NSString alloc]initWithFormat:@"http://%@/STMC/ScanData.json?methodName=GetClientPermission&shopId=0",hostAddrOrNil]; 
    ASIHTTPRequest *allShopsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:shopListAddr]];
    [shopListAddr release];
    [allShopsRequest setDelegate:self];
    [allShopsRequest startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];    
    NSDictionary *msgDict = [[NSDictionary alloc]initWithObjectsAndKeys:username,@"username",password,@"password", ipAddr,@"ipAddr",responseString,@"responseStr",nil];
    [responseString release];
    [self.delegate needGoForwardWithControllerTagStr:self.tagStr message:msgDict];    
}

-(void)didFailAllShopsRequest:(ASIHTTPRequest *)request
{
//    NSString *reachFailText = [[NSString alloc]initWithString:@"连接服务器失败"];
//    hostReachResultLabel.text = reachFailText;
//    [reachFailText release];
}
@end
