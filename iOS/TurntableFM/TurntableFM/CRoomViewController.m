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
#import "CQueueViewController.h"
#import "CTurntableFMModel.h"
#import "CUser.h"
#import "CRoom.h"
#import "CSong.h"
#import "CMarqueeView.h"
#import "CAvatarLibrary.h"
#import "CAvatarLayer.h"

@interface CRoomViewController () <UITextFieldDelegate>

@property (nonatomic, retain) UIPopoverController *usersPopoverController;
@property (nonatomic, retain) UIPopoverController *queuePopoverController;
@property (nonatomic, retain) CUsersViewController *usersViewController;
@property (nonatomic, retain) CQueueViewController *queueViewController;

- (void)launchQueuePopoverController;

- (void)keyboardWillShowNotification:(NSNotification *)notification;
- (void)keyboardWillHideNotification:(NSNotification *)notification;

@end

#pragma mark -

@implementation CRoomViewController

#define Neck 30

@synthesize room;
@synthesize usersButton, songButton;
@synthesize usersPopoverController, queuePopoverController;
@synthesize usersViewController, queueViewController;
@synthesize avatarView;
@synthesize DJView;
@synthesize chatTextView;
@synthesize speakTextField;
@synthesize marqueeView;
@synthesize chatView;
@synthesize neckOffsets;
@synthesize toolBar;

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
			
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
        }
    return self;
    }

- (void)dealloc

{
    [self removeObserver:self forKeyPath:@"room.currentSong"];
    [self removeObserver:self forKeyPath:@"room.chatLog"];
    [self removeObserver:self forKeyPath:@"room.users"];
    [self removeObserver:self forKeyPath:@"room.DJs"];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];

    [room unsubscribe];
    [room release];
    room = NULL;
    [usersButton release];
    [usersPopoverController release];
	[queuePopoverController release];
	[usersViewController release];
	[queueViewController release];
	[neckOffsets release];

	[chatView release];
	[toolBar release];
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
	
	self.neckOffsets = [[[NSMutableArray alloc] initWithObjects:
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 1 long brown hair
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 2
						[NSValue valueWithCGPoint:CGPointMake(0, -50)],// 3 red fauxhawk pig tails
						[NSValue valueWithCGPoint:CGPointMake(0, -15)],// 4 orange pig tails
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 5
						[NSValue valueWithCGPoint:CGPointMake(0, -10)],// 6 red pig tails
						[NSValue valueWithCGPoint:CGPointMake(0, -20)],// 7 brown hair kid
						[NSValue valueWithCGPoint:CGPointMake(0, -20)],// 8
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 9
						[NSValue valueWithCGPoint:CGPointMake(0, -50)],// 10 pin bear
						[NSValue valueWithCGPoint:CGPointMake(0, -25)],// 11 green bear
						[NSValue valueWithCGPoint:CGPointMake(0, -25)],// 12 evil drone bear
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 13
						[NSValue valueWithCGPoint:CGPointMake(0, -20)],// 14
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 15
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 16 evil queen bear
						[NSValue valueWithCGPoint:CGPointMake(0, -20)],// 17
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 18
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 19
						[NSValue valueWithCGPoint:CGPointMake(0, -40)],// 20
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 21
						[NSValue valueWithCGPoint:CGPointMake(0, -30)],// 22
						[NSValue valueWithCGPoint:CGPointMake(63, 50)],// 23 gorilla
						[NSValue valueWithCGPoint:CGPointMake(0, -55)],// 24 red mouse
						[NSValue valueWithCGPoint:CGPointMake(0, 0)], // 25 unused
						[NSValue valueWithCGPoint:CGPointMake(0, -30)], // 26 superuser
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 27 New cosmic avatars
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 28 "
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 29 "
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 30 "
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 31 "
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 32 "
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 33 End new cosmic avatars
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 34 strange little boy
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 35 Daft Punk II
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 36 He-Monkey
                        [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 37 She-Monkey
						nil] autorelease]; 

    self.title = self.room.name;
	
	if (songButton == nil)
	{
		self.songButton = [[[UIBarButtonItem alloc] initWithTitle:@"Queue" style:UIBarButtonItemStyleBordered target:self action:@selector(launchQueuePopoverController)] autorelease];
		[self.navigationItem setRightBarButtonItem:songButton];
	}
}

- (void)viewDidUnload
    {
		[self setChatView:nil];
		[self setToolBar:nil];
    [super viewDidUnload];
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)launchQueuePopoverController
{
	if (queuePopoverController == nil) 
	{
		[self setQueueViewController:[[[CQueueViewController alloc] initWithNibName:nil bundle:nil] autorelease]];
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			[self setQueuePopoverController:[[[UIPopoverController alloc] initWithContentViewController:queueViewController] autorelease]];
			[queuePopoverController setDelegate:self];
		}
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[queuePopoverController presentPopoverFromBarButtonItem:songButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	}
	else {
		[self.navigationController pushViewController:self.queueViewController animated:YES];
	}
}

- (IBAction)voteAwesome
    {	
        [[CTurntableFMModel sharedInstance] voteAwesome];
    }

- (IBAction)voteLame
    {	
        [[CTurntableFMModel sharedInstance] voteLame];
    }

- (void)usersTapped:(id)sender
{
	if (self.usersPopoverController == nil) {
		self.usersViewController = [[[CUsersViewController alloc] initWithNibName:nil bundle:nil] autorelease];
		self.usersViewController.room = self.room;
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.usersPopoverController = [[[UIPopoverController alloc] initWithContentViewController:self.usersViewController] autorelease];
			self.usersPopoverController.delegate = self;
		}
	}
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[self.usersPopoverController presentPopoverFromBarButtonItem:usersButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
	else {
		[self.navigationController pushViewController:self.usersViewController animated:YES];
	}
}

- (IBAction)djTapped:(id)sender {
	[[CTurntableFMModel sharedInstance] becomeDJ];
}

#pragma mark -

- (CAvatarLayer *)layerForUser:(CUser *)inUser
    {
    CAvatarLayer *theLayer = objc_getAssociatedObject(inUser, "layer");
    if (theLayer == NULL)   
        {

		NSInteger avatarID = inUser.avatarID;
			CGPoint neckOffset = [[neckOffsets objectAtIndex:avatarID - 1] CGPointValue];
		CAvatarLibrary *library = [CAvatarLibrary sharedInstance];
		UIImage *headImage = [library imageForAvatar:inUser.avatarID head:YES front:NO];
		UIImage *bodyImage = [library imageForAvatar:inUser.avatarID head:NO front:NO];
				
		theLayer = [CAvatarLayer layer];
            
		CALayer *bodyImageLayer = [CALayer layer];
		bodyImageLayer.bounds = (CGRect){ .size = bodyImage.size };
		bodyImageLayer.contents = (id)bodyImage.CGImage;
		bodyImageLayer.position = (CGPoint){ .x = neckOffset.x, .y = headImage.size.height + neckOffset.y };
		[theLayer addSublayer:bodyImageLayer];
            
		CALayer *headImageLayer = [CALayer layer];
		headImageLayer.bounds = (CGRect){ .size = headImage.size };
		headImageLayer.contents = (id)headImage.CGImage;
		[theLayer addSublayer:headImageLayer];

        theLayer.headLayer = headImageLayer;
        theLayer.bodyLayer = bodyImageLayer;

        objc_setAssociatedObject(inUser, "layer", theLayer, OBJC_ASSOCIATION_RETAIN);
        }
    
    return(theLayer);
    }

- (void)DJUser:(CUser *)inUser
    {
    NSLog(@"DJUSER");
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGRect theDJViewBounds = self.DJView.layer.bounds;
    
    CAvatarLayer *theLayer = [self layerForUser:inUser];
    theLayer.headLayer.contents = (id)[[CAvatarLibrary sharedInstance] imageForAvatar:inUser.avatarID head:YES front:YES].CGImage;
    theLayer.bodyLayer.contents = (id)[[CAvatarLibrary sharedInstance] imageForAvatar:inUser.avatarID head:NO front:YES].CGImage;
;

//    for (CALayer *theSublayer in theLayer.sublayers)
//        {
//        theSublayer.borderWidth = 1.0;
//        theSublayer.borderColor = [UIColor greenColor].CGColor;
//        }

    NSInteger theIndex = [self.room.DJs indexOfObject:inUser];
    
    theLayer.position = (CGPoint){ .x = CGRectGetMaxX(theDJViewBounds) * (theIndex / 5.0), .y = CGRectGetMidY(theDJViewBounds) };
    
    [self.DJView.layer addSublayer:theLayer];
    
    [CATransaction commit];
    }

- (void)UnDJUser:(CUser *)inUser
    {
    CGRect theDJViewBounds = self.DJView.layer.bounds;
    CGRect theAvatarViewBounds = self.avatarView.layer.bounds;


    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    for (CUser *theDJ in self.room.DJs)
        {
        NSInteger theIndex = [self.room.DJs indexOfObject:theDJ];
        CALayer *theDJLayer = [self layerForUser:theDJ];
        theDJLayer.position = (CGPoint){ .x = CGRectGetMaxX(theDJViewBounds) * (theIndex / 5.0), .y = CGRectGetMidY(theDJViewBounds) };
        }

    CAvatarLayer *theLayer = [self layerForUser:inUser];
    theLayer.headLayer.contents = (id)[[CAvatarLibrary sharedInstance] imageForAvatar:inUser.avatarID head:YES front:NO].CGImage;
    theLayer.bodyLayer.contents = (id)[[CAvatarLibrary sharedInstance] imageForAvatar:inUser.avatarID head:NO front:NO].CGImage;

//    for (CALayer *theSublayer in theLayer.sublayers)
//        {
//        theSublayer.borderWidth = 1.0;
//        theSublayer.borderColor = [UIColor redColor].CGColor;
//        }


    theLayer.position = (CGPoint){ .x = arc4random() % (int)theAvatarViewBounds.size.width, .y = arc4random() % (int)theAvatarViewBounds.size.height };
    [self.avatarView.layer addSublayer:theLayer];

    [CATransaction commit];

    }

#pragma mark -

- (void)keyboardWillShowNotification:(NSNotification *)inNotification
    {
    //self.speakTextField.inputAccessoryView = self.speakTextField;
		if (CGAffineTransformIsIdentity(self.chatView.transform)) {
			[UIView animateWithDuration:0.3 animations:^(void) {
				self.chatView.transform = CGAffineTransformMakeTranslation(0, -264 + self.toolBar.bounds.size.height);
			}];
		}
    }

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
	[UIView animateWithDuration:0.3 animations:^(void) {
		self.chatView.transform = CGAffineTransformIdentity;
	}];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[CTurntableFMModel sharedInstance] speak:textField.text];
	textField.text = nil;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // I posit that half-finished chat should not vanish if you go to vote on a song.
	// textField.text = nil; 	
    return YES;
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
            // TODO: add "/me emotes" handling
            if ([[theSpeakDictionary objectForKey:@"type"] isEqualToString:@"chat"])
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
            else if ([[theSpeakDictionary objectForKey:@"type"] isEqualToString:@"boot"]) 
                {
                self.chatTextView.text = [self.chatTextView.text stringByAppendingFormat:@"%@ was booted from the room.\n", [theSpeakDictionary objectForKey:@"name"]];
                [self.chatTextView scrollRangeToVisible:(NSRange){ .location = self.chatTextView.text.length }];
                }
            else if ([[theSpeakDictionary objectForKey:@"type"] isEqualToString:@"newsong"]) 
                {
                self.chatTextView.text = [self.chatTextView.text stringByAppendingFormat:@"♫♪ %@ started playing \"%@\" by %@ ♪♫\n", [theSpeakDictionary objectForKey:@"name"], [theSpeakDictionary valueForKeyPath:@"metadata.song"], [theSpeakDictionary valueForKeyPath:@"metadata.artist"]];
                [self.chatTextView scrollRangeToVisible:(NSRange){ .location = self.chatTextView.text.length }];
                }
            else if ([theSpeakDictionary objectForKey:@"type"] == nil)
                {
                NSLog(@"Null chatlog event type!"); 
                }
            else
                {
                NSLog(@"Unknown chatlog event type: %@", [theSpeakDictionary objectForKey:@"type"]);
                }
            }
        }
    else if ([keyPath isEqualToString:@"room.users"])
        {
        NSMutableArray *theNewUsers = [NSMutableArray array];

        CGRect theBounds = self.avatarView.layer.bounds;

        for (CUser *theUser in [change objectForKey:NSKeyValueChangeNewKey])
            {
            if ([self.room.DJs containsObject:theUser] == NO)
                {
                CALayer *theLayer = [self layerForUser:theUser];
                [self.avatarView.layer addSublayer:theLayer];
                [theNewUsers addObject:theUser];
                }
            }

        if (theNewUsers.count > 0)
            {
            double delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [CATransaction begin];
                [CATransaction setAnimationDuration:0.5];
                [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

                for (CUser *theUser in theNewUsers)
                    {
                    if ([self.room.DJs containsObject:theUser] == NO)
                        {
                        CALayer *theLayer = [self layerForUser:theUser];
                        theLayer.position = (CGPoint){ .x = arc4random() % (int)theBounds.size.width, .y = arc4random() % (int)theBounds.size.height };
                        }
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
