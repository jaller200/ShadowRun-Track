//
//  ShadowClocksViewController.m
//  ShadowRun
//
//  Created by The Doctor on 2/14/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import "ShadowClocksViewController.h"

@interface ShadowClocksViewController ()

@end

@implementation ShadowClocksViewController

- (id)init
{
    if (IS_IPHONE_5) {
        self = [super initWithNibName:@"ShadowClocksViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"ShadowClocksViewController~4" bundle:nil];
    }
    
    if (self) {
        itemsArray = [[NSArray alloc] initWithObjects:@"Stopwatch", @"Alarm", nil];
        
        [[self navigationController] setTitle:@"Clock Functions"];
        
        UITabBarItem *tbi = [self tabBarItem];
        
        [tbi setTitle:@"Clocks"];
        [tbi setImage:[UIImage imageNamed:@"Time.png"]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
}

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Clocks_Cell"];
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    [label setText:[itemsArray objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [NSString stringWithFormat:@"Clock Functions"];
    return sectionTitle;
}

@end
