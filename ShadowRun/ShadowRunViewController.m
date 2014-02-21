//
//  ShadowRunViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import "ShadowRunViewController.h"
#import "ShadowRun.h"
#import "ShadowRunStore.h"
#import "DetailViewController.h"

@implementation ShadowRunViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        
        [n setTitle:@"ShadowRun"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRun:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
        [[self view] setFrame:CGRectMake(0, 0, 320, 400)];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - View Functions

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"ShadowRunItemCell" bundle:nil];
    
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"ShadowRunItemCell"];
    
    //UIColor *clr = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    [[self view] setAlpha:0.85];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    [imageView setFrame:self.tableView.frame];
    
    UIImageView *imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez-4~5.png"]];
    [imageView5 setFrame:self.tableView.frame];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self.tableView.backgroundView = imageView5;
    } else {
        self.tableView.backgroundView = imageView;
    }
    [[self tableView] reloadData];
    
    //[[self view] setBackgroundColor:clr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ShadowRunViewController - ViewWillAppear");
    
    [[ShadowRunStore sharedStore] loadAllRuns];
    
    [self.tableView reloadData];
    
    [self.view setNeedsDisplay];
}

#pragma mark - TableView Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ShadowRunStore sharedStore] allRuns] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShadowRun *p = [[[ShadowRunStore sharedStore] allRuns] objectAtIndex:[indexPath row]];
    
    ShadowRunItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShadowRunItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    [[cell runTitle] setText:[p runTitle]];
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //BOOL milesOrKilometers = [prefs boolForKey:@"miles_kilometers"];
    
    NSString *mileKilos = [p mileKilos];
    
    if ([mileKilos isEqualToString:@"miles"]) {
        [[cell mphTitle] setText:[NSString stringWithFormat:@"%.2f MPH", [p avgMph]]];
    } else {
        [[cell mphTitle] setText:[NSString stringWithFormat:@"%.2f KPH", [p avgMph]]];
    }
    
    if ([[[cell mphTitle] text] isEqualToString:@"0.00 MPH"] || [[[cell mphTitle] text] isEqualToString:@"nan MPH"] || [[[cell mphTitle] text] isEqualToString:@"0.00 KPH"] || [[[cell mphTitle] text] isEqualToString:@"nan KPH"] || [[[cell mphTitle] text] isEqualToString:@"inf MPH"] || [[[cell mphTitle] text] isEqualToString:@"inf KPH"]) {
        if ([mileKilos isEqualToString:@"miles"]) {
            [[cell mphTitle] setText:@"0.00 MPH"];
        } else {    
            [[cell mphTitle] setText:@"0.00 KPH"];
        }
    }
    
    if ([[[cell runTitle] text] isEqualToString:@""]) {
        [[cell runTitle] setText:[NSString stringWithFormat:@"Unamed Run"]];
        [[cell runTitle] setTextColor:[UIColor lightGrayColor]];
    } else {
        [[cell runTitle] setTextColor:[UIColor blackColor]];
    }

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [p dateCreated];
    [[cell dateCreatedTitle] setText:[dateFormatter stringFromDate:date]];
    
    NSString *typeTitle = [[p type] valueForKey:@"label"];
    if (!typeTitle) {
        typeTitle = @"No Run Type";
    }
    [[cell runTypeTitle] setText:[NSString stringWithFormat:@"%@", typeTitle]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShadowRunStore *ps = [ShadowRunStore sharedStore];
        NSArray *runs = [ps allRuns];
        ShadowRun *p = [runs objectAtIndex:[indexPath row]];
        [ps removeRun:p];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        BOOL success = [[ShadowRunStore sharedStore] saveChanges];
        if (success) {
            NSLog(@"ShadowRunViewController - Saved all runs.");
        } else {
            NSLog(@"ShadowRunViewController - Could not save runs.");
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ShadowRunViewController - Row Selected.");
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewRun:NO isFromStopwatch:NO];
    
    NSArray *runs = [[ShadowRunStore sharedStore] allRuns];
    ShadowRun *selectedRun = [runs objectAtIndex:[indexPath row]];
    
    [detailViewController setRun:selectedRun];
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

#pragma mark Custom Functions

- (IBAction)addNewRun:(id)sender
{
    NSLog(@"ShadowRunViewController - Adding new run...");
    
    ShadowRun *newRun = [[ShadowRunStore sharedStore] createRun];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewRun:YES isFromStopwatch:NO];
    
    [detailViewController setRun:newRun];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:navController animated:YES completion:nil];
}

@end
