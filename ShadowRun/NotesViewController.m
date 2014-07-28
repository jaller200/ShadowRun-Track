//
//  NotesViewController.m
//  ShadowRun
//
//  Created by The Doctor on 1/6/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import "NotesViewController.h"
#import "ShadowRun.h"
#import "ShadowRunStore.h"
#import "DetailViewController.h"

#import "UIImage+ImageEffects.h"

@interface NotesViewController ()

@end

@implementation NotesViewController
@synthesize run, dismissBlock;
@synthesize closeItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"NotesViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"NotesViewController~4" bundle:nil];
    }
    
    if (self) {
        closeItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
        [[self navigationItem] setRightBarButtonItem:closeItem];
    }
    
    return self;
}

- (id)initWithRun:(ShadowRun *)newRun
{
    @throw [NSException exceptionWithName:@"Unused initializer" reason:@"initWithRun: is not in use right now. I may use it later." userInfo:nil];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [textViewView setDelegate:self];
    
    [textViewView setText:[run runNotes]];
    
    if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setText:NSLocalizedString(@"Notes...", @"Notes...")];
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else if ([[textViewView text] isEqualToString:@" "]) {
        [textViewView setText:NSLocalizedString(@"Notes...", @"Notes...")];
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else {
        [textViewView setTextColor:[UIColor blackColor]];
        [textViewView setText:[run runNotes]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    // Create blurred background
    NSString *backgroundSelected = [prefs stringForKey:@"backgroundSelected"];
    
    UIImage *image;
    
    if (IS_IPHONE_5) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-4-Inch-Blurred.png", backgroundSelected]];
    } else {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-3-5-Inch-Blurred.png", backgroundSelected]];
    }
    
    [backgroundView setImage:image];
    
    [textViewView.layer setBorderWidth:0.3f];
    [textViewView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [textViewView setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    close = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *theme = [prefs stringForKey:@"keyboardAppearance"];
    
    if ([theme isEqualToString:@"light"]) {
        [textViewView setKeyboardAppearance:UIKeyboardAppearanceLight];
    } else {
        [textViewView setKeyboardAppearance:UIKeyboardAppearanceDark];
    }
}

#pragma mark - Setters and Getters

- (void)setRun:(ShadowRun *)r
{
    run = r;
}

#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([[textViewView text] isEqualToString:NSLocalizedString(@"Notes...", @"Notes...")]) {
        [textViewView setText:@""];
        [textViewView setTextColor:[UIColor blackColor]];
    }
    
    [closeItem setTitle:@"Done"];
    close = NO;

    [textViewView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setTextColor:[UIColor lightGrayColor]];
        [textViewView setText:NSLocalizedString(@"Notes...", @"Notes...")];
    }
    
    [closeItem setTitle:@"Close"];
    close = YES;
    
    [textViewView resignFirstResponder];
}

#pragma mark - Custom Methods

- (IBAction)close:(id)sender
{
    if (close) {
        NSLog(@"NotesViewController - Closing");
    
        [run setRunNotes:[textViewView text]];
        [[self navigationController] dismissViewControllerAnimated:YES completion:dismissBlock];
    } else {
        [textViewView endEditing:YES];
    }
}

- (IBAction)backgroundTapped:(id)sender
{
    NSLog(@"NotesViewController - Background Tapped");
    
    [textViewView endEditing:YES];
    [textViewView resignFirstResponder];
}

- (void)moveTextViewForKeyboard:(NSNotification *)aNotification up:(BOOL)up
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = textViewView.frame;
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    if (IS_IPHONE_5) {
        newFrame.size.height -= keyboardFrame.size.height * (up ? 0.25 : -0.25);
    } else {
        newFrame.size.height -= keyboardFrame.size.height * (up ? 0.75 : -0.75);
    }

    textViewView.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillShown:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO];
}

@end
