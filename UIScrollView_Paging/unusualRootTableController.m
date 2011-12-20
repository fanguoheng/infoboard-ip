//
//  unusualRootTableController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "unusualRootTableController.h"

@implementation unusualRootTableController
@synthesize dataDict;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dataDict:(NSDictionary *)dataDictSet{
    [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.dataDict = dataDictSet;
    
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
#pragma mark - UITableView DataSource Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 2;
        case 2:
            return 5;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"很不满意"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"VeryBad"]intValue]];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"不满意"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"Bad"]intValue]];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"丢失数"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"LostCnt"]intValue]];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"丢失率"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                                        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f%%",[[dataDict objectForKey:@"LostRate"]floatValue]*100];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"座席主动放弃"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"AgtLost"]intValue]];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"客户主动挂机"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"CusLost"]intValue]];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"电话线路占满"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"SysLost"]intValue]];
                    break;
                case 3:
                    cell.textLabel.text = [NSString stringWithFormat:@"无在线座席"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"OffLost"]intValue]];
                    break;
                case 4:
                    cell.textLabel.text = [NSString stringWithFormat:@"其他"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[dataDict objectForKey:@"OthLost"]intValue]];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"客户差评"];
        case 1:
            return [NSString stringWithFormat:@"电话丢失数量"];
        case 2:
            return [NSString stringWithFormat:@"电话丢失原因"];
        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            break;
            
        default:
            break;
    }
}

@end
