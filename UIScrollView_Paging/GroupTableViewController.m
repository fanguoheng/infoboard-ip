//
//  GroupTableViewController.m
//  UIScrollView_Paging
//
//  Created by crazysnow on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "GroupTableViewController.h"
#import "CustomCellPortrait.h"
#import "BSTableHeadView.h"
@implementation GroupTableViewController
@synthesize dataDictArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        dataDictArray = [[NSArray alloc]init];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [dataDictArray release];
    [super dealloc];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataDictArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CustomCellPortraitIdentifier = @"CustomCellPortraitIdentifier";
    CustomCellPortrait *cellPortrait = (CustomCellPortrait *)[tableView dequeueReusableCellWithIdentifier:CustomCellPortraitIdentifier];
    if (cellPortrait == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellPortrait" owner:self options:nil];
        for (id oneObject in nib)
            if([oneObject isKindOfClass:[CustomCellPortrait class]])
                cellPortrait = (CustomCellPortrait *)oneObject;
    } 
    
    NSDictionary *grpDict =  [dataDictArray objectAtIndex:indexPath.row];
    float answerRate = [[grpDict objectForKey:@"answerrate"]floatValue];
    UIColor *answerRateColor = [UIColor colorWithRed:(1.0f-answerRate) green:answerRate blue:0.25f alpha:1.0f];
    cellPortrait.groupIcon.backgroundColor = answerRateColor;
    cellPortrait.grpName.text = [grpDict objectForKey:@"grpname"];
    cellPortrait.grpName.textColor = answerRateColor;
    //cellPortrait.login.text = [NSString stringWithFormat:@"%d",[[grpDict objectForKey:@"login"]intValue]];
    cellPortrait.transAgt.text = [self mutableStringWithCommaConvertFromInteger:[[grpDict objectForKey:@"transagt"]intValue]];
    cellPortrait.agtAnswer.text = [self mutableStringWithCommaConvertFromInteger:[[grpDict objectForKey:@"agtanswer"]intValue]];
    cellPortrait.answerRate.text = [NSString stringWithFormat:@"%d",(NSInteger)(answerRate*100)];
    cellPortrait.answerRate.textColor = answerRateColor;
    cellPortrait.percentSign.textColor = answerRateColor;
    //cellPortrait.queueLen.text = [NSString stringWithFormat:@"%d",[[grpDict objectForKey:@"queuelen"]intValue]];
    /*
    CVTableCellBGView *bgView = [[CVTableCellBGView alloc] init];
    bgView.cellStyle = CellStyleMiddle;
    bgView.gradientColor = GradientColorBlack;
    [cellPortrait setBackgroundView:bgView];
    [bgView release];*/
    
    return cellPortrait;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - string format methods
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
