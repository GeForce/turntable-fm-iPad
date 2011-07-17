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
    
    [self.room addObserver:self forKeyPath:@"chatLog" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
    [self.room addObserver:self forKeyPath:@"users" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
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
    if ([keyPath isEqualToString:@"chatLog"])
        {
        for (NSDictionary *theSpeakDictionary in [change objectForKey:@"new"])
            {
            self.chatTextView.text = [self.chatTextView.text stringByAppendingFormat:@"%@: %@\n", [theSpeakDictionary objectForKey:@"name"], [theSpeakDictionary objectForKey:@"text"]];
            [self.chatTextView scrollRangeToVisible:(NSRange){ .location = self.chatTextView.text.length }];
            }
        }
    else if ([keyPath isEqualToString:@"users"])
        {

//    indexes = "<NSIndexSet: 0x559e3b0>[number of indexes: 1 (in 1 ranges), indexes: (22)]";
//    kind = 2;
//    new =     (
//        "<CUser: 0x553eb40>"
//    );

//2011-07-16 23:10:37.267 TurntableFM[26276:cb03] {
//    indexes = "<NSIndexSet: 0x558c960>[number of indexes: 1 (in 1 ranges), indexes: (13)]";
//    kind = 3;
//    old =     (
//        "<CUser: 0x55fb740>"
//    );
//}

        for (CUser *theUser in [change objectForKey:NSKeyValueChangeNewKey])
            {
            NSLog(@"NEW USER: %@", theUser.name);
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
            NSLog(@"REMOVED USER: %@", theUser.name);

            CALayer *theLayer = objc_getAssociatedObject(theUser, "layer");
            [theLayer removeFromSuperlayer];
            }
        }
    
    
    
    }

@end
