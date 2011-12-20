//
//  FlipsideViewController.m
//  AppSettings
//
//  Created by crazysnow on 11-5-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "PreferencesController.h"

@implementation FlipsideViewController

@synthesize delegate=_delegate;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor]; 
    PreferencesController *preferencesTableViewController = [[PreferencesController alloc]initWithStyle:UITableViewStyleGrouped];
    [self.view addSubview:preferencesTableViewController.view];
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait)| (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)|(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
