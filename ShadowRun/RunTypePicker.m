//
//  RunTypePicker.m
//  ShadowRun
//
//  Created by The Doctor on 8/31/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//

#import "RunTypePicker.h"
#import "ShadowRunStore.h"
#import "ShadowRun.h"

@implementation RunTypePicker
@synthesize run;

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *clr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    
    [[self tableView] setBackgroundView:clr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.20];
    self.view.frame = CGRectMake(0, 0, 320, 367);
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[ShadowRunStore sharedStore] allRunTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSArray *allTypes = [[ShadowRunStore sharedStore] allRunTypes];
    NSManagedObject *runType = [allTypes objectAtIndex:[indexPath row]];
    
    NSString *typeLabel = [runType valueForKey:@"label"];
    [[cell textLabel] setText:typeLabel];
    
    if (runType == [run type]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allTypes = [[ShadowRunStore sharedStore] allRunTypes];
    NSManagedObject *runType = [allTypes objectAtIndex:[indexPath row]];
    [run setType:runType];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
