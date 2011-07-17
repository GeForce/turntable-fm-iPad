//
//  CRoomViewController.m
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRoomViewController.h"

#import <QuartzCore/QuartzCore.h>

#import <objc/runtime.h>

#import "CChatViewController.h"
#import "CSongViewController.h"
#import "CTurntableFMModel.h"
#import "CUser.h"
#import "CRoom.h"

@interface CRoomViewController () <UITextFieldDelegate>
@end

#pragma mark -

@implementation CRoomViewController

@synthesize room;
@synthesize chatButton, songButton;
@synthesize chatPopoverController, songPopoverController;
@synthesize chatViewController, songViewController;
@synthesize chatTextView;
@synthesize speakTextField;

- (id)initWithRoom:(CRoom *)inRoom;
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        room = [inRoom retain];
        [room subscribe];
        
        [self addObserver:self forKeyPath:@"room.chatLog" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"room.users" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
        }
    return self;
    }

- (void)dealloc
    {
    [self removeObserver:self forKeyPath:@"room.chatLog"];
    [self removeObserver:self forKeyPath:@"room.users"];

    [room unsubscribe];
    [room release];
    room = NULL;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = self.room.name;
	
	if (songButton == nil)
	{
		self.songButton = [[UIBarButtonItem alloc] initWithTitle:@"Songs" style:UIBarButtonItemStyleBordered target:self action:@selector(launchSongPopoverViewController)];
		[self.navigationItem setRightBarButtonItem:songButton];
	}
}

- (void)viewDidUnload
    {
    [super viewDidUnload];
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
    if ([keyPath isEqualToString:@"room.chatLog"])
        {
        for (NSDictionary *theSpeakDictionary in [change objectForKey:@"new"])
            {
            self.chatTextView.text = [self.chatTextView.text stringByAppendingFormat:@"%@: %@\n", [theSpeakDictionary objectForKey:@"name"], [theSpeakDictionary objectForKey:@"text"]];
            [self.chatTextView scrollRangeToVisible:(NSRange){ .location = self.chatTextView.text.length }];
            }
        }
    else if ([keyPath isEqualToString:@"room.users"])
        {
        for (CUser *theUser in [change objectForKey:NSKeyValueChangeNewKey])
            {
            CATextLayer *theLayer = [CATextLayer layer];
            theLayer.borderColor = [UIColor colorWithHue:(CGFloat)theUser.avatarID / 26.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
            theLayer.borderWidth = 1.0;
            
            theLayer.string = theUser.name;
            theLayer.bounds = (CGRect){ .size = {64, 64 } };
            theLayer.position = (CGPoint){ arc4random() % 768, arc4random() % 768 };
            [self.view.layer addSublayer:theLayer];
            
            objc_setAssociatedObject(theUser, "layer", theLayer, OBJC_ASSOCIATION_RETAIN);
            }
        for (CUser *theUser in [change objectForKey:@"old"])
            {
            CALayer *theLayer = objc_getAssociatedObject(theUser, "layer");
            [theLayer removeFromSuperlayer];
            }
        }
    }

@end
