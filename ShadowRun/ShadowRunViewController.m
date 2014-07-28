//
//  ShadowRunViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/21/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "ShadowRunViewController.h"
#import "ShadowRun.h"
#import "ShadowRunStore.h"
#import "DetailViewController.h"
#import "HeightAndWeightViewController.h"
#import "ShadowRunAppDelegate.h"

@implementation ShadowRunViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        
        [n setTitle:NSLocalizedString(@"ShadowRun Track", @"ShadowRun Track")];
        
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
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    // Register TableView Cell NIB
    UINib *nib = [UINib nibWithNibName:@"ShadowRunItemCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"ShadowRunItemCell"];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // Reload the tableView
    [[self tableView] reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"ShadowRunViewController - ViewWillAppear");
    
    UIImageView *imageView;
    
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    NSLog(@"Background Selected: %@", backgroundSelected);
    
    ShadowRunAppDelegate *appDelegate = (ShadowRunAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (IS_IPHONE_5) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch.png", backgroundSelected]]];
        [imageView setFrame:self.view.frame];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch.png", backgroundSelected]]];
    }
    
    [imageView setFrame:self.view.frame];
    self.tableView.backgroundView = imageView;
    
    // - This is info for the theme options (migrated from Keyboard Appearance) that will
    // - Be release in Release 2.1.0
    /*NSString *theme = [prefs stringForKey:@"keyboardAppearance"];
    
    if ([theme isEqualToString:@"light"]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
        self.tabBarController.tabBar.translucent = YES;
        self.tabBarController.tabBar.alpha = 1;
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        self.tabBarController.tabBar.barTintColor = [UIColor blackColor];
        self.tabBarController.tabBar.translucent = YES;
        self.tabBarController.tabBar.alpha = 1;
    }*/
    
    [[appDelegate window] setNeedsDisplay];
    
    [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - UIRefreshControl Function

- (void)refresh:(id)sender
{
    [[ShadowRunStore sharedStore] loadAllRuns];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

#pragma mark - TableView Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ShadowRunStore sharedStore] allRuns] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize the cell
    ShadowRun *p = [[[ShadowRunStore sharedStore] allRuns] objectAtIndex:[indexPath row]];
    
    ShadowRunItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShadowRunItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    [[cell runTitle] setText:[p runTitle]];
    [[cell mphTitle] setText:[NSString stringWithFormat:NSLocalizedString(@"%.2f Pace", @"%.2f Pace"), [p avgMph]]];
    
    if ([[[cell mphTitle] text] isEqualToString:@"0.00"] || [[[cell mphTitle] text] isEqualToString:@"nan"] || [[[cell mphTitle] text] isEqualToString:@"inf"] || [[[cell mphTitle] text] isEqualToString:@"inf Pace"] || [[[cell mphTitle] text] isEqualToString:@"nan Pace"] || [[[cell mphTitle] text] isEqualToString:@"0.00 Pace"]) {
        [[cell mphTitle] setText:@"0.00 Pace"];
    }
    
    if ([[[cell runTitle] text] isEqualToString:@""]) {
        [[cell runTitle] setText:[NSString stringWithFormat:NSLocalizedString(@"Unamed Run", @"Unamed Run")]];
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
        typeTitle = NSLocalizedString(@"No Run Type", @"No Run Type");
    }
    [[cell runTypeTitle] setText:[NSString stringWithFormat:@"%@", typeTitle]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Add ability to delete
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ShadowRunStore *ps = [ShadowRunStore sharedStore];
        NSArray *runs = [ps allRuns];
        ShadowRun *p = [runs objectAtIndex:[indexPath row]];
        [ps removeRun:p];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Save after deletion
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
