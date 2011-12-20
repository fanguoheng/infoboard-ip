//
//  PreferencesController.m
//  UIScrollView_Paging
//
//  Created by Mac on 11-11-1.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
//#import "PreferencesTableViewCell.h"
#import "PreferencesController.h"

@implementation PreferencesController
@synthesize viewBoardName_refreshIntervals;
//@synthesize statisticsRefreshIntervalLabel,statisticsRefreshIntervalSlider, realtimeMonitorRefreshIntervalLabel,realtimeMonitorRefreshIntervalSlider, detailsRefreshIntervalLabel, detailsRefreshIntervalSlider;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.view setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 416.0f)];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger numberOfRows;
    switch (section) {
        case 0:
            numberOfRows = 3;
            break;
        case 1:
            numberOfRows = 1;
            break;
        default:
            numberOfRows = 0;
            break;
    }
    return numberOfRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [NSString stringWithFormat:@"刷新间隔"];
        case 1:
            return [NSString stringWithFormat:@"关于"];
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"PreferencesTableViewCell";
    
    PreferencesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PreferencesTableViewCell" owner:self options:nil];
        for (id oneObject in nib)
            if([oneObject isKindOfClass:[PreferencesTableViewCell class]])
                cell = (PreferencesTableViewCell *)oneObject;
    }
    //cell.refreshIntervalLable.text = [NSString stringWithFormat:@"test"];
    */
     static NSString *CellIdentifier = @"Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
     }
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"统计数据：10秒"];
            //[cell.accessoryView setFrame:CGRectMake(180.0f, 0.0f, 100.0f, 44.0f)];
            cell.accessoryView = [[UISlider alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 140.0f, 44.0f)];
            UISlider *theSlider = (UISlider *)cell.accessoryView;
            theSlider.minimumValue = 3;
            theSlider.maximumValue = 30;
            //theSlider.value = 10;
            theSlider.tag = indexPath.row;
            [theSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:(UIControlEvents)UIControlEventValueChanged];
            break;
        case 1:
            break;
        default:
            break;
    }
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (IBAction)sliderChanged:(id)sender
{
    UISlider *theSlider = (UISlider *)sender;
    /*
    switch (theSlider.tag) {
        case 0:
            <#statements#>
            break;
            
        default:
            break;
    }
     */
    NSLog(@"slider value change");
    
}
@end
