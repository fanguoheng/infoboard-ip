//
//  UnUsualRootTableViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UnUsualRootTableViewController.h"
#import "CVTableCellBGView.h"

@implementation UnUsualRootTableViewController

@synthesize dataDictArray;


- (id)initWithStyle:(UITableViewStyle)style dataDictArray:(NSArray *)dataDictArraySet delegate:(id<UITableViewDelegate>)delegateSet
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor=[UIColor darkGrayColor];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = delegateSet;
        self.dataDictArray = dataDictArraySet;
        self.view.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
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
    
    static NSString *CellIdentifier = @"UnUsualRootCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        
        /*
        CVTableCellBGView *bgView = [[CVTableCellBGView alloc] init];
        bgView.cellStyle = CellStyleMiddle;
        bgView.gradientColor = GradientColorBlack;
        [cell setBackgroundView:bgView];
        [bgView release];*/
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor orangeColor];
        cell.textLabel.font=[UIFont systemFontOfSize:18];
    }
    //此时cell != nil
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"很不满意"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0] objectForKey:@"VeryBad"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0] objectForKey:@"verybad"]intValue]];                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"不满意"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0] objectForKey:@"Bad"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0] objectForKey:@"bad"]intValue]];                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"丢失数"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //cell.detailTextLabel.frame = CGRectMake(cell.detailTextLabel.frame.origin.x-40.0f, cell.detailTextLabel.frame.origin.y, cell.detailTextLabel.frame.size.width, cell.detailTextLabel.frame.size.height);
                    //cell.accessoryView = [[[UIView alloc]init] autorelease];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0 ] objectForKey:@"LostCnt"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0 ] objectForKey:@"lostcnt"]intValue]];                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"丢失率"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //cell.accessoryView = [[[UIView alloc]init] autorelease];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f%%",[[[dataDictArray objectAtIndex:0] objectForKey:@"LostRate"]floatValue]*100];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f%%",[[[dataDictArray objectAtIndex:0] objectForKey:@"lostrate"]floatValue]*100];
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
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0] objectForKey:@"AgtLost"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0] objectForKey:@"agtlost"]intValue]];                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"客户主动挂机"];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0] objectForKey:@"CusLost"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0] objectForKey:@"cuslost"]intValue]];                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"电话队列排满"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //cell.accessoryView = [[[UIView alloc]init] autorelease];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0] objectForKey:@"SysLost"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0] objectForKey:@"syslost"]intValue]];                    break;
                case 3:
                    cell.textLabel.text = [NSString stringWithFormat:@"无在线座席"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //cell.accessoryView = [[[UIView alloc]init] autorelease];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0] objectForKey:@"OffLost"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0] objectForKey:@"offlost"]intValue]];                    break;
                case 4:
                    cell.textLabel.text = [NSString stringWithFormat:@"其他"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    //cell.accessoryView = [[[UIView alloc]init] autorelease];
                    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[[[dataDictArray objectAtIndex:0] objectForKey:@"OthLost"]intValue]];
                    cell.detailTextLabel.text = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:0] objectForKey:@"othlost"]intValue]];                    break;
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
/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"客户差评(个)"];
        case 1:
            return [NSString stringWithFormat:@"电话丢失统计(个)"];
        case 2:
            return [NSString stringWithFormat:@"电话丢失原因分类统计(个)"];
        default:
            return nil;
    }
}*/

#pragma mark - utiles


- (NSMutableString *)mutableStringWithCommaConvertFromInteger:(NSInteger)number
{
    if (number < 1000) {
        NSMutableString *resultString = [[NSMutableString alloc ]initWithFormat:@"%d", number];
        return [resultString autorelease];
    }
    else
    {
        NSMutableString *resultString = [[NSMutableString alloc ]initWithFormat:@"%d,%d", number/1000, number%1000];
        if ((number%1000)<10) 
        {
            NSRange range = [resultString rangeOfString:@","];
            [resultString insertString:@"00" atIndex:range.location+1]; 
        }
        else if ((number%1000)<100) 
        {
            NSRange range = [resultString rangeOfString:@","];
            [resultString insertString:@"0" atIndex:range.location+1]; 
        }
        return [resultString autorelease];
    }
}


@end
