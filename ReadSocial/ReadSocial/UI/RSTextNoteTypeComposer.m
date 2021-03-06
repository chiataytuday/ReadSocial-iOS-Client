//
//  RSTextNoteTypeComposer.m
//  ReadSocial
//
//  Created by Daniel Pfeiffer on 2/20/12.
//  Copyright (c) 2012 Float Mobile Learning. All rights reserved.
//

#import "RSTextNoteTypeComposer.h"
#import <QuartzCore/QuartzCore.h>

@implementation RSTextNoteTypeComposer
@synthesize noteBody, rootComposerController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - RSNoteTypeComposer Methods
- (id) initWithRootComposerController: (RSComposeNoteViewController *) composerController
{
    self = [super init];
    if (self)
    {
        rootComposerController = composerController;
    }
    
    return self;
}
+ (id) composerWithRootComposerController: (RSComposeNoteViewController *)rootComposerController
{
    RSTextNoteTypeComposer *composer = [[RSTextNoteTypeComposer alloc] initWithRootComposerController:rootComposerController];
    return composer;
}
- (NSDictionary *) prepareRequestArguments
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            noteBody.text,          @"note_body",
            @"text",                @"mtype",
            nil];
}
- (BOOL) shouldEnableSubmitButton
{
    return noteBody.text.length!=0;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add a border to the note body
    noteBody.layer.cornerRadius = 5.0f;
    noteBody.delegate = self;
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
	return YES;
}

#pragma mark - UITextView delegate
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // Determine what the new value of the text field is going to be
    NSString *newValue = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (newValue.length!=0)
    {
        [rootComposerController enableSubmitButton];
    }
    else
    {
        [rootComposerController disableSubmitButton];
    }
    
    return YES;
}

@end
