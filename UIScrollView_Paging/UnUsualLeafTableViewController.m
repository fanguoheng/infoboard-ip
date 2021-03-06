//
//  UnUsualLeafTableViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-11-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UnUsualLeafTableViewController.h"
#import "agtLostTableViewCell.h"

@implementation UnUsualLeafTableViewController

@synthesize dataDictArray;
@synthesize sectionVeryBadOpend,sectionBadOpend;

- (id)initWithStyle:(UITableViewStyle)style dataDictArray:(NSArray* )dataDictArraySet Tag:(UnUsualLeafTableViewControllerSituation)situation;
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.view.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.showsHorizontalScrollIndicator = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.dataDictArray = dataDictArraySet;
        [self.view setTag:situation];
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
    switch (self.view.tag)
    {
        case UnUsualLeafTableViewControllerSituationVeryBad:
        case UnUsualLeafTableViewControllerSituationBad:
            switch (section) {
                case 0:
                    return sectionVeryBadOpend?[[dataDictArray objectAtIndex:0]count]*5:0;
                case 1:
                    return sectionBadOpend?[[dataDictArray objectAtIndex:1]count]*5:0;
                default:
                    return 0;
            }
        case UnUsualLeafTableViewControllerSituationAgtLost:
            return [dataDictArray count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
          switch (self.view.tag) {
        case UnUsualLeafTableViewControllerSituationVeryBad:
        case UnUsualLeafTableViewControllerSituationBad:
        {
            static NSString *CellIdentifier = @"UnusualLeafCell";
            
            
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
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.detailTextLabel.backgroundColor = [UIColor clearColor];
                cell.detailTextLabel.textColor = [UIColor orangeColor];
            }  
            switch (indexPath.row%5) {
                case 0:
                {
                    NSString *str = [[NSString alloc]initWithString:@"座席"];
                    cell.textLabel.text = str;
                    [str release];
                    NSString *nameStr = [[NSString alloc]initWithString:[[[dataDictArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row/5] objectForKey:@"name"]];
                    cell.detailTextLabel.text = nameStr;
                    [nameStr release];
                    break;
                }
                case 1:
                {
                    NSString *str = [[NSString alloc ]initWithString:@"组号"];
                    cell.textLabel.text = str;
                    [str release];
                    NSString *idStr = [[NSString alloc ]initWithString:[[[dataDictArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row/5]objectForKey:@"id"]];
                    cell.detailTextLabel.text = idStr;
                    [idStr release];
                    break;
                }
                case 2:
                {
                    NSString *str = [[NSString alloc ]initWithString:@"客户"];
                    cell.textLabel.text = str;
                    [str release];
                    NSString *aniStr = [[NSString alloc ]initWithString:[[[dataDictArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row/5]objectForKey:@"ani"]];
                    cell.detailTextLabel.text = aniStr;
                    [aniStr release];
                    break;
                }
                case 3:
                {
                    NSString *str = [[NSString alloc ]initWithString:@"时间"];
                    cell.textLabel.text = str;
                    [str release];
                    NSString *tmStr = [[NSString alloc ]initWithString:[[[dataDictArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row/5]objectForKey:@"tm"]];
                    cell.detailTextLabel.text = tmStr;
                    [tmStr release];
                    break;
                }
                default:
                    
                    cell.textLabel.text = nil;
                    cell.detailTextLabel.text = nil;
                    break;
            }
            return cell;
        }
        case UnUsualLeafTableViewControllerSituationAgtLost:
        {
            static NSString *CellIdentifier = @"UnusualLeafAgtLostCell";
            
            
            agtLostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"agtLostTableViewCell" owner:self options:nil];
                for (id oneObject in nib)
                    if([oneObject isKindOfClass:[agtLostTableViewCell class]])
                        cell = (agtLostTableViewCell *)oneObject;
                /*
                CVTableCellBGView *bgView = [[CVTableCellBGView alloc] init];
                bgView.cellStyle = CellStyleMiddle;
                bgView.gradientColor = GradientColorBlack;
                [cell setBackgroundView:bgView];*/
                cell.backgroundColor = [UIColor clearColor];
            }
            //cell.textLabel.text = [NSString stringWithFormat:@"%@(工号%@)",[[dataDictArray objectAtIndex:indexPath.row] objectForKey:@"Name"],[[dataDictArray objectAtIndex:indexPath.row] objectForKey:@"AgtID"]];
            cell.nameLabel.text = [[dataDictArray objectAtIndex:indexPath.row] objectForKey:@"name"];
             cell.agtIdLabel.text=[[dataDictArray objectAtIndex:indexPath.row] objectForKey:@"agtid"];
            NSMutableString *agtLostStr = [self mutableStringWithCommaConvertFromInteger:[[[dataDictArray objectAtIndex:indexPath.row] objectForKey:@"agtlost"]intValue]];
            [agtLostStr appendString:@"个"];
            cell.agtLostLabel.text = agtLostStr;
            return cell;
            }
        default:
            return  nil;
            break;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    switch (self.view.tag) {
            
        case UnUsualLeafTableViewControllerSituationVeryBad:
            return  2;//[dataDictArray count];
        case UnUsualLeafTableViewControllerSituationBad:
            return  2;//[dataDictArray count];
        case UnUsualLeafTableViewControllerSituationAgtLost:
            return 1;
        default:
            return 0;
    }
}

#pragma mark - UITableViewDelegate Methods
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            break;
            
        default:
            break;
    }
}
*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (self.view.tag) {
        case UnUsualLeafTableViewControllerSituationVeryBad:
        case UnUsualLeafTableViewControllerSituationBad:
        {
            NSMutableString *veryBadHeaderTitle = [self mutableStringWithCommaConvertFromInteger:[[dataDictArray objectAtIndex:0] count]];
            [veryBadHeaderTitle insertString:@"很不满意 "atIndex:0];
            [veryBadHeaderTitle appendString:@"个"];
            //;[[NSString alloc]initWithFormat:@"很不满意:%d",[[dataDictArray objectAtIndex:0] count]];
            NSMutableString *badHeaderTitle = [self mutableStringWithCommaConvertFromInteger:[[dataDictArray objectAtIndex:1] count]];
            [badHeaderTitle insertString:@"不满意 " atIndex:0];
            [badHeaderTitle appendString:@"个"];
            switch (section) {
                case 0:
                {
                    ClickableView *headerView = [[ClickableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 35.0f) title:veryBadHeaderTitle section:section opened:sectionVeryBadOpend delegate:self];
                    return  [headerView autorelease];
                }
                case 1:
                {
                    ClickableView *headerView = [[ClickableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 35.0f) title:badHeaderTitle section:section opened:sectionBadOpend delegate:self];
                    return [headerView autorelease];
                }
                default:
                    return nil;
            }
        }
        default:
            return nil;
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, 2.0f)] autorelease];
}

#pragma mark - ClickableHeaderViewDelegate
-(void)sectionHeaderView:(ClickableView*)sectionHeaderView sectionClosed:(NSInteger)section
{
    0==section?(sectionVeryBadOpend=NO):(sectionBadOpend=NO);
    [self.tableView reloadData];
}
-(void)sectionHeaderView:(ClickableView*)sectionHeaderView sectionOpened:(NSInteger)section
{
    0==section?(sectionVeryBadOpend=YES):(sectionBadOpend=YES);
    [self.tableView reloadData];
}

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
