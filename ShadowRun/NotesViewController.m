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

@interface NotesViewController ()

@end

@implementation NotesViewController
@synthesize run, dismissBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        self = [super initWithNibName:@"NotesViewController~5" bundle:nil];
    } else {
        self = [super initWithNibName:@"NotesViewController~4" bundle:nil];
    }
    
    if (self) {
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(close:)];
        [[self navigationItem] setRightBarButtonItem:doneItem];
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
        [textViewView setText:@"Notes..."];
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else if ([[textViewView text] isEqualToString:@" "]) {
        [textViewView setText:@"Notes..."];
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else {
        [textViewView setTextColor:[UIColor blackColor]];
        [textViewView setText:[run runNotes]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lopez-4.jpg"]];
    [imageView setFrame:self.view.frame];
    [self.view insertSubview:imageView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setText:@"Notes..."];
        [textViewView setTextColor:[UIColor lightGrayColor]];
    } else {
        [textViewView setTextColor:[UIColor blackColor]];
    }*/
}

#pragma mark - Setters and Getters

- (void)setRun:(ShadowRun *)r
{
    run = r;
}

#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([[textViewView text] isEqualToString:@"Notes..."]) {
        [textViewView setText:@""];
        [textViewView setTextColor:[UIColor blackColor]];
    }
    [textViewView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textViewView text] isEqualToString:@""]) {
        [textViewView setTextColor:[UIColor lightGrayColor]];
        [textViewView setText:@"Notes..."];
    }
    
    [textViewView resignFirstResponder];
}

#pragma mark - Custom Methods

- (IBAction)close:(id)sender
{
    NSLog(@"NotesViewController - Closing");
    
    [run setRunNotes:[textViewView text]];
    [[self navigationController] dismissViewControllerAnimated:YES completion:dismissBlock];
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
        newFrame.size.height -= keyboardFrame.size.height * (up?0.25:-0.25);
    } else {
        newFrame.size.height -= keyboardFrame.size.height * (up?0.75:-0.75);
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
