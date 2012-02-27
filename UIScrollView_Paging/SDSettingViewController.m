//
//  SDSettingViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 12-2-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SDSettingViewController.h"
#import "JSON.h"
@implementation SDSettingViewController
@synthesize responseStr,selectedShopId;
@synthesize picker;
@synthesize provincesShops,provinces,shops;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedShopId = [[NSString alloc]init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil tagStr:(NSString*)tagStrOrNil responseStr:(NSString *)responseStrOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil tagStr:tagStrOrNil];
    if (self){
        self.responseStr = responseStr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [selectedShopId release];
    [provincesShops release];
    [provinces release];
    [shops release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    exitButton.tag = 3;
    toSettingViewButton.tag = 4;
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



#pragma mark - UIPickerView datasource Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (0==component)?[provinces count]:[shops count];
}
#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 78.0f;  
            break;
        default:
            return 208.0f;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return (0==component)?[provinces objectAtIndex:row]:[[shops objectAtIndex:row]objectForKey:@"shopname"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{   
    switch (component) {
        case 0:
        {
            self.shops = [provincesShops objectForKey:[provinces objectAtIndex:row]];
            [picker reloadComponent:1];
            break;
        }  
        default:
            break;
    }
    
}

#pragma mark - go back or forward
-(void) goBack
{
    //do nothing by default
    [self.delegate needGoBackWithControllerTagStr:self.tagStr message:nil];
}
-(void) goForward
{
    [super goForward];
    NSInteger provinceSelected = [picker selectedRowInComponent:0];
    NSInteger shopSelected = [picker selectedRowInComponent:1];
    self.selectedShopId = [[[provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]] objectAtIndex:shopSelected] objectForKey:@"shopid"];
    NSString *provinceName = [[provinces objectAtIndex:provinceSelected]retain];
    NSString *shopName = [[[[provincesShops objectForKey:[provinces objectAtIndex:provinceSelected]] objectAtIndex:shopSelected] objectForKey:@"shopname"]retain];
    NSString *province_shopStr = [[NSString alloc]initWithFormat:@"%@ %@",provinceName,shopName];
    [provinceName release];
    [shopName release];
    NSDictionary *msg = [[NSDictionary alloc]initWithObjectsAndKeys:selectedShopId,@"selectedShopId",province_shopStr,@"province_shopStr", nil];
    [self.delegate needGoForwardWithControllerTagStr:self.tagStr message:msg];
    [msg release];
}

- (IBAction)goBackOrForward:(id)sender
{
    switch (((UIButton*)sender).tag) {
        case 3:
            [self goBack];
            break;
        case 4:
            [self goForward];
            break;
        default:
            break;
    }
}

- (void) reloadWithResponseStr:(NSString*)responseStrOrNil
{
    self.responseStr = responseStrOrNil;
    NSArray *tmpArray = [responseStr JSONValue];
    if([tmpArray count] && ![[tmpArray objectAtIndex:0] isMemberOfClass:[NSNull class]])
    {
        provincesShops = [[NSMutableDictionary alloc]init ];
        for (NSDictionary* anyShop in tmpArray) {
            //provincesShops中已存在以此省名为key的字典
            NSString *provinceName = [[NSString alloc]initWithString:[anyShop objectForKey:@"province"]];
            if ([provincesShops objectForKey:provinceName])
            {
                [(NSMutableArray*)[provincesShops objectForKey:provinceName] addObject:anyShop];
            }
            //provincesShops中未存在以此省名为key的字典
            else
            {
                NSString *allShopsID = [[NSString alloc]initWithFormat:@"%@*",[[anyShop objectForKey:@"shopid"]substringToIndex:3]];
                NSDictionary *AllShops = [[NSDictionary alloc]initWithObjectsAndKeys:allShopsID,@"shopid",@"所有站点",@"shopname", nil];
                [allShopsID release];
                NSMutableArray *shopsOfTheProvice = [[NSMutableArray alloc]initWithObjects:AllShops,anyShop, nil];
                [AllShops release];
                [provincesShops setObject:shopsOfTheProvice forKey:provinceName];
            }
            [provinceName release];
        }
        provinces = [[NSMutableArray alloc]initWithArray:[provincesShops allKeys]];
        [provinces insertObject:@"全国" atIndex:0];
        NSDictionary *nationwideShopsDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"all",@"shopid",@"所有站点",@"shopname", nil];
        NSArray *nationwideShopsArray = [[NSArray alloc]initWithObjects:nationwideShopsDic, nil];
        [provincesShops setObject:nationwideShopsArray forKey:@"全国"];
        self.shops = [provincesShops objectForKey:[provinces objectAtIndex:0]];
        [picker reloadAllComponents];
        [picker selectRow:0 inComponent:0 animated:NO]; 
        [picker selectRow:0 inComponent:1 animated:NO]; 
    }
    else
    {
        
    }
    [picker reloadAllComponents];
}

@end
