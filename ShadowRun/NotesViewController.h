//
//  NotesViewController.h
//  ShadowRun
//
//  Created by The Doctor on 1/6/14.
//  Copyright (c) 2014 ShadowPress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShadowRun;

@interface NotesViewController : UIViewController <UITextViewDelegate>
{
    __weak IBOutlet UITextView *textViewView;
    UIToolbar *toolbar;
}

@property (nonatomic, strong) ShadowRun *run;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (id)initWithRun:(ShadowRun *)newRun;

- (IBAction)backgroundTapped:(id)sender;

- (IBAction)close:(id)sender;
- (void)moveTextViewForKeyboard:(NSNotification *)aNotification up:(BOOL)up;

@end
