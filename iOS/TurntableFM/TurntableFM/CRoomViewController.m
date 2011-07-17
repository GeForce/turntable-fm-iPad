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

#import "CUsersViewController.h"
#import "CSongViewController.h"
#import "CTurntableFMModel.h"
#import "CUser.h"
#import "CRoom.h"
#import "CSong.h"
#import "CMarqueeView.h"
#import "CAvatarLibrary.h"

@interface CRoomViewController () <UITextFieldDelegate>

@property (nonatomic, retain) UIPopoverController *usersPopoverController;
@property (nonatomic, retain) UIPopoverController *songPopoverController;
@property (nonatomic, retain) CUsersViewController *usersViewController;
@property (nonatomic, retain) CSongViewController *songViewController;

@end

#pragma mark -

@implementation CRoomViewController

#define Neck 30

@synthesize room;
@synthesize usersButton, songButton;
@synthesize usersPopoverController, songPopoverController;
@synthesize usersViewController, songViewController;
@synthesize avatarView;
@synthesize DJView;
@synthesize chatTextView;
@synthesize speakTextField;
@synthesize marqueeView;
@synthesize neckOffsets;

- (id)initWithRoom:(CRoom *)inRoom;
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        room = [inRoom retain];
        [room subscribe];
        
        [self addObserver:self forKeyPath:@"room.currentSong" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"room.chatLog" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"room.users" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        [self addObserver:self forKeyPath:@"room.DJs" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL]            ;
        }
    return self;
    }

- (void)dealloc

{
    [self removeObserver:self forKeyPath:@"room.currentSong"];
    [self removeObserver:self forKeyPath:@"room.chatLog"];
    [self removeObserver:self forKeyPath:@"room.users"];

    [room unsubscribe];
    [room release];
    room = NULL;
    [usersButton release];
    [usersPopoverController release];
	[songPopoverController release];
	[usersViewController release];
	[songViewController release];
	[neckOffsets release];

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

	self.marqueeView.font = [UIFont fontWithName:@"DS Dots" size:40.0];
	
	self.neckOffsets = [[NSMutableArray alloc] initWithObjects:
						[NSNumber numberWithInt:30],// 1
						[NSNumber numberWithInt:30],// 2
						[NSNumber numberWithInt:60],// 3
						[NSNumber numberWithInt:10],// 4 orange pig tails
						[NSNumber numberWithInt:30],// 5
						[NSNumber numberWithInt:30],// 6
						[NSNumber numberWithInt:15],// 7 brown hair kid
						[NSNumber numberWithInt:20],// 8
						[NSNumber numberWithInt:30],// 9
						[NSNumber numberWithInt:50],// 10 pin bear
						[NSNumber numberWithInt:30],// 11
						[NSNumber numberWithInt:30],// 12
						[NSNumber numberWithInt:30],// 13
						[NSNumber numberWithInt:20],// 14
						[NSNumber numberWithInt:30],// 15
						[NSNumber numberWithInt:20],// 16
						[NSNumber numberWithInt:20],// 17
						[NSNumber numberWithInt:30],// 18
						[NSNumber numberWithInt:30],// 19
						[NSNumber numberWithInt:40],// 20
						[NSNumber numberWithInt:30],// 21
						[NSNumber numberWithInt:30],// 22
						[NSNumber numberWithInt:30],// 23
						[NSNumber numberWithInt:30],// 24
						[NSNumber numberWithInt:0], // 25 unused
						[NSNumber numberWithInt:30],nil];

    self.title = self.room.name;
	
	if (songButton == nil)
	{
		self.songButton = [[UIBarButtonItem alloc] initWithTitle:@"Songs" style:UIBarButtonItemStyleBordered target:self action:@selector(launchSongPopoverViewController)];
		[self.navigationItem setRightBarButtonItem:songButton];
	}
	
	/*for (int i = 1; i < 25; i++)
	{
		CAvatarLibrary *lib = [[CAvatarLibrary alloc] init];
		UIImage *image = [lib imageForAvatar:i head:NO front:NO];
		UIImageView *avatar = [[UIImageView alloc] initWithFrame:CGRectMake(200, 200 + i * 100, image.size.width, image.size.height)];
		[avatar setImage:image];
		[self.view addSubview:avatar];
	}*/
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

- (void)launchSongPopoverController
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

- (void)launchChatPopoverController
{
	/*
	if (chatPopoverController == nil) 
	{
		[self setChatViewController:[[CChatViewController alloc] initWithStyle:UITableViewStylePlain]];
		[self setChatPopoverController:[[UIPopoverController alloc] initWithContentViewController:chatViewController]];
		[chatPopoverController setDelegate:self];
		CGSize popOverSize = CGSizeMake(240, 500);
		[chatPopoverController setPopoverContentSize:popOverSize];
	}
	[chatPopoverController presentPopoverFromBarButtonItem:chatButton permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
	*/
}

- (IBAction)voteAwesome
    {	
    }

- (IBAction)voteLame
    {	
    }

- (void)usersTapped:(id)sender
{
	if (self.usersPopoverController == nil) {
		self.usersViewController = [[[CUsersViewController alloc] initWithNibName:nil bundle:nil] autorelease];
		self.usersViewController.room = self.room;
		self.usersPopoverController = [[[UIPopoverController alloc] initWithContentViewController:self.usersViewController] autorelease];
		self.usersPopoverController.delegate = self;
	}
	[self.usersPopoverController presentPopoverFromBarButtonItem:usersButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark -

- (CALayer *)layerForUser:(CUser *)inUser
    {
    CALayer *theLayer = objc_getAssociatedObject(inUser, "layer");
    if (theLayer == NULL)   
        {

		NSInteger avatarID = theUser.avatarID;
		NSInteger neck = [[neckOffsets objectAtIndex:avatarID - 1] intValue];
		CAvatarLibrary *library = [CAvatarLibrary sharedInstance];
		UIImage *headImage = [library imageForAvatar:theUser.avatarID head:YES front:NO];
		UIImage *bodyImage = [library imageForAvatar:theUser.avatarID head:NO front:NO];
				
		CALayer *theLayer = [CALayer layer];
		theLayer.bounds = (CGRect) { .size = 
			(headImage.size.width > bodyImage.size.width) ? headImage.size.width : bodyImage.size.width,
			headImage.size.height + bodyImage.size.height - neck };
			theLayer.position = (CGPoint){ .x = arc4random() % (int)(theBounds.size.width * 3) - theBounds.size.width, .y = arc4random() % (int)theBounds.size.height + theBounds.size.height };
            
		CALayer *bodyImageLayer = [CALayer layer];
		bodyImageLayer.bounds = (CGRect){ .size = bodyImage.size };
		bodyImageLayer.contents = (id)bodyImage.CGImage;
		bodyImageLayer.position = (CGPoint){ .x = 0, .y = headImage.size.height - neck };
		[theLayer addSublayer:bodyImageLayer];
				
		CALayer *headImageLayer = [CALayer layer];
		headImageLayer.bounds = (CGRect){ .size = headImage.size };
		headImageLayer.contents = (id)headImage.CGImage;
		[theLayer addSublayer:headImageLayer];


        objc_setAssociatedObject(inUser, "layer", theLayer, OBJC_ASSOCIATION_RETAIN);
        }
    
    return(theLayer);
    }

- (void)DJUser:(CUser *)inUser
    {
    }

- (void)UnDJUser:(CUser *)inUser
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
    if ([keyPath isEqualToString:@"room.DJs"])
        {
        for (CUser *theUser in [change objectForKey:NSKeyValueChangeNewKey])
            {
            [self DJUser:theUser];
            }

        for (CUser *theUser in [change objectForKey:NSKeyValueChangeOldKey])
            {
            [self UnDJUser:theUser];
            }
        
        }
    else if ([keyPath isEqualToString:@"room.currentSong"])
        {
        CSong *theSong = [change objectForKey:NSKeyValueChangeNewKey];
        if ((id)theSong == [NSNull null])
            {
            return;
            }
        self.marqueeView.text = theSong.name;
        }
    else if ([keyPath isEqualToString:@"room.chatLog"])
        {
        for (NSDictionary *theSpeakDictionary in [change objectForKey:@"new"])
            {
            self.chatTextView.text = [self.chatTextView.text stringByAppendingFormat:@"%@: %@\n", [theSpeakDictionary objectForKey:@"name"], [theSpeakDictionary objectForKey:@"text"]];
            [self.chatTextView scrollRangeToVisible:(NSRange){ .location = self.chatTextView.text.length }];

            NSString *theUserID = [theSpeakDictionary objectForKey:@"userid"];
            
            CUser *theUser = [self.room.usersByUserID objectForKey:theUserID];
            
            CALayer *theLayer = [self layerForUser:theUser];

            CABasicAnimation *thePulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            thePulseAnimation.duration = 0.2;
            thePulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            thePulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            thePulseAnimation.toValue = [NSNumber numberWithFloat:1.2];

            [theLayer addAnimation:thePulseAnimation forKey:@"pulse"];
            }
        }
    else if ([keyPath isEqualToString:@"room.users"])
        {
        NSMutableArray *theNewLayers = [NSMutableArray array];

        CGRect theBounds = self.avatarView.layer.bounds;

        for (CUser *theUser in [change objectForKey:NSKeyValueChangeNewKey])
            {
            CALayer *theLayer = [self layerForUser:theUser];
            [self.avatarView.layer addSublayer:theLayer];
            
            [theNewLayers addObject:theLayer];
            }

        if (theNewLayers.count > 0)
            {
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [CATransaction begin];
                [CATransaction setAnimationDuration:0.5];
                [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

                for (CALayer *theLayer in theNewLayers)
                    {
                    theLayer.position = (CGPoint){ .x = arc4random() % (int)theBounds.size.width, .y = arc4random() % (int)theBounds.size.height };
                    }

                [CATransaction commit];
                });
            }


        for (CUser *theUser in [change objectForKey:@"old"])
            {
            CALayer *theLayer = [self layerForUser:theUser];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:0.5];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setCompletionBlock:^(void) {
                [theLayer removeFromSuperlayer];
                objc_setAssociatedObject(theUser, "layer", NULL, OBJC_ASSOCIATION_RETAIN);
                }];
            theLayer.position = (CGPoint){ .x = CGRectGetMaxX(theLayer.superlayer.bounds), .y = theLayer.position.y };

            [CATransaction commit];
            }
        }
    }

@end
