//
//  BackgroundPicker.m
//  ShadowRun
//
//  Created by Jonathan on 5/18/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import "BackgroundPicker.h"

@interface BackgroundPicker ()

@end

@implementation BackgroundPicker
@synthesize dismissBlock;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [[self navigationItem] setRightBarButtonItem:doneButton];
        //self.navigationController.toolbarHidden = NO;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    prefs = [NSUserDefaults standardUserDefaults];
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    UIImageView *imageView;
    
    if (IS_IPHONE_5) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch.png", backgroundSelected]]];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch.png", backgroundSelected]]];
    }
    
    [[self tableView] setBackgroundView:imageView];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(reset:)];
    
    NSArray *toolbarItemsArray = [[NSArray alloc] initWithObjects:flexSpace, resetButton, flexSpace, nil];
    self.toolbarItems = toolbarItemsArray;
}

- (void)done:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)reset:(id)sender
{
    NSLog(@"BackgroundPicker - Resetting Background Image to Default");
    
    [prefs setObject:@"Default" forKey:@"backgroundSelected"];
    
    if (IS_IPHONE_5) {
    }
    
    UIImageView *imageView;
    
    if (IS_IPHONE_5) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Track and Field-4-Inch.png"]];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Track and Field-3-5-Inch.png"]];
    }
    
    [[self tableView] setBackgroundView:imageView];
    
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((section == 0) ? 1 : 2);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"";
    } else {
        return @"Background Images";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [[cell textLabel] setText:@"Default"];
                
                if ([backgroundSelected isEqualToString:@"Default"]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [[cell textLabel] setTextColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0]];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    [[cell textLabel] setTextColor:[UIColor blackColor]];
                }
                
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                [[cell textLabel] setText:@"Track and Field"];
                
                if ([backgroundSelected isEqualToString:@"Track and Field"]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [[cell textLabel] setTextColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0]];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    [[cell textLabel] setTextColor:[UIColor blackColor]];
                }
                
                break;
                
            case 1:
                [[cell textLabel] setText:@"Lopez Lomong"];
                
                if ([backgroundSelected isEqualToString:@"Lopez Lomong"]) {
                    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                    [[cell textLabel] setTextColor:[UIColor colorWithRed:.196 green:0.3098 blue:0.52 alpha:1.0]];
                } else {
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    [[cell textLabel] setTextColor:[UIColor blackColor]];
                }
                
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                if (![backgroundSelected isEqualToString:@"Default"]) {
                    [prefs setObject:@"Default" forKey:@"backgroundSelected"];
                
                    UIImageView *imageView;
                
                    if (IS_IPHONE_5) {
                        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Track and Field-4-Inch.png"]];
                    } else {
                        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Track and Field-3-5-Inch.png"]];
                    }
                
                    [tableView setBackgroundView:imageView];
                }
            
                [tableView reloadData];
            
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                if (![backgroundSelected isEqualToString:@"Track and Field"]) {
                    [prefs setObject:@"Track and Field" forKey:@"backgroundSelected"];
                
                    UIImageView *imageView;
                    
                    if (IS_IPHONE_5) {
                        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Track and Field-4-Inch.png"]];
                    } else {
                        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Track and Field-3-5-Inch.png"]];
                    }
                
                    [tableView setBackgroundView:imageView];
                }
            
                [tableView reloadData];
            
                break;
            
            case 1:
            
                if (![backgroundSelected isEqualToString:@"Lopez Lomong"]) {
                    [prefs setObject:@"Lopez Lomong" forKey:@"backgroundSelected"];
                
                    UIImageView *imageView;
                
                    if (IS_IPHONE_5) {
                        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez Lomong-4-Inch.png"]];
                    } else {
                        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez Lomong-3-5-Inch.png"]];
                    }
                
                    [tableView setBackgroundView:imageView];
                }
            
                [tableView reloadData];
            
                break;
            
            default:
                break;
        }
    }
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
