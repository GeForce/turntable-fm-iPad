//
//  CRoomViewController.m
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRoomViewController.h"
#import "CChatViewController.h"
#import "CSongViewController.h"
#import "CTurntableFMModel.h"
#import "CRoom.h"

@interface CRoomViewController () <UITextFieldDelegate>
@property (readonly, nonatomic, retain) CRoom *room;
@end

#pragma mark -

@implementation CRoomViewController

@synthesize chatButton, songButton;
@synthesize chatPopoverController, songPopoverController;
@synthesize chatViewController, songViewController;
@synthesize chatTextView;
@synthesize speakTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[chatButton release];
    [chatPopoverController release];
	[songPopoverController release];
	[chatViewController release];
	[songViewController release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (CRoom *)room
    {
    return([CTurntableFMModel sharedInstance].room);
    }

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:NULL];
    
    [self.room addObserver:self forKeyPath:@"chatLog" options:NSKeyValueObservingOptionNew context:NULL];
    
	if (songButton == nil)
	{
		self.songButton = [[UIBarButtonItem alloc] initWithTitle:@"Songs" style:UIBarButtonItemStyleBordered target:self action:@selector(launchSongPopoverViewController)];
		[self.navigationItem setRightBarButtonItem:songButton];
	}
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

- (void)launchSongPopoverViewController
{
	if (songPopoverController == nil) 
	{
		[self setSongViewController:[[CSongViewController alloc] initWithStyle:UITableViewStylePlain]];
		[self setSongPopoverController:[[UIPopoverController alloc] initWithContentViewController:songViewController]];
		[songPopoverController setDelegate:self];
		CGSize popOverSize = CGSizeMake(240, 500);
		[songPopoverController setPopoverContentSize:popOverSize];
	}
	[songPopoverController presentPopoverFromBarButtonItem:songButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)launchChatPopoverViewController
{
	if (chatPopoverController == nil) 
	{
		[self setChatViewController:[[CChatViewController alloc] initWithStyle:UITableViewStylePlain]];
		[self setChatPopoverController:[[UIPopoverController alloc] initWithContentViewController:chatViewController]];
		[chatPopoverController setDelegate:self];
		CGSize popOverSize = CGSizeMake(240, 500);
		[chatPopoverController setPopoverContentSize:popOverSize];
	}
	[chatPopoverController presentPopoverFromBarButtonItem:chatButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

- (IBAction)voteAwesome
{
	
}

- (IBAction)voteLame
{
	
}

#pragma mark -

- (void)keyboardWillShowNotification:(NSNotification *)inNotification
    {
    self.speakTextField.inputAccessoryView = self.speakTextField;
    
    }

- (BOOL)textFieldShouldReturn:(UITextField *)textField
    {
    return(YES);
    }

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
    {
    for (NSDictionary *theSpeakDictionary in [change objectForKey:@"new"])
        {
        self.chatTextView.text = [self.chatTextView.text stringByAppendingFormat:@"%@: %@\n", [theSpeakDictionary objectForKey:@"name"], [theSpeakDictionary objectForKey:@"text"]];
        [self.chatTextView scrollRangeToVisible:(NSRange){ .location = self.chatTextView.text.length }];
        }
    
    
    }

@end
