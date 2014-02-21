//
//  TOSViewController.m
//  ShadowRun
//
//  Created by The Doctor on 9/9/13.
//  Copyright (c) 2013 ShadowPress. All rights reserved.
//  Dedicated to Isabelle Smoke.
//

#import "TOSViewController.h"

@implementation TOSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TOSViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    //UIColor *clr = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    //[[self view] setBackgroundColor:clr];
    
    /*UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    [imageView setFrame:self.view.frame];
    
    [self.view insertSubview:imageView atIndex:0];*/
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)close:(id)sender
{
    NSLog(@"Closing...");
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
