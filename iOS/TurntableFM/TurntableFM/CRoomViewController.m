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

@interface CRoomViewController () <UITextFieldDelegate>

@property (nonatomic, retain) UIPopoverController *usersPopoverController;
@property (nonatomic, retain) UIPopoverController *queuePopoverController;
@property (nonatomic, retain) CUsersViewController *usersViewController;
@property (nonatomic, retain) CQueueViewController *queueViewController;

- (void)launchQueuePopoverController;

@end

#pragma mark -

@implementation CRoomViewController

@synthesize room;
@synthesize usersButton, songButton;
@synthesize usersPopoverController, queuePopoverController;
@synthesize usersViewController, queueViewController;
@synthesize avatarView;
@synthesize chatTextView;
@synthesize speakTextField;
@synthesize marqueeView;

- (id)initWithRoom:(CRoom *)inRoom;
    {
    if ((self = [super initWithNibName:NSStringFromClass([self class]) bundle:NULL]) != NULL)
        {
        room = [inRoom retain];
        [room subscribe];
        
        NSLog(@"%@", room.currentSong.parameters);
        
        [self addObserver:self forKeyPath:@"room.currentSong" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"room.chatLog" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"room.users" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
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
	[queuePopoverController release];
	[usersViewController release];
	[queueViewController release];

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

    self.title = self.room.name;
	
	if (songButton == nil)
	{
		self.songButton = [[[UIBarButtonItem alloc] initWithTitle:@"Queue" style:UIBarButtonItemStyleBordered target:self action:@selector(launchQueuePopoverController)] autorelease];
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

- (void)launchQueuePopoverController
{
	if (queuePopoverController == nil) 
	{
		[self setQueueViewController:[[[CQueueViewController alloc] initWithNibName:nil bundle:nil] autorelease]];
		[self setQueuePopoverController:[[[UIPopoverController alloc] initWithContentViewController:queueViewController] autorelease]];
		[queuePopoverController setDelegate:self];
		CGSize popOverSize = CGSizeMake(240, 500);
		[queuePopoverController setPopoverContentSize:popOverSize];
	}
	[queuePopoverController presentPopoverFromBarButtonItem:songButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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
    if ([keyPath isEqualToString:@"room.currentSong"])
        {
        NSLog(@"%@", change);
        
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
            
            
            CALayer *theLayer = objc_getAssociatedObject(theUser, "layer");

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
				CAvatarLibrary *library = [CAvatarLibrary sharedInstance];
				UIImage *headImage = [library imageForAvatar:theUser.avatarID head:YES front:NO];
				UIImage *bodyImage = [library imageForAvatar:theUser.avatarID head:NO front:NO];
				
				CALayer *theLayer = [CALayer layer];
				theLayer.bounds = (CGRect) { .size = 
					(headImage.size.width > bodyImage.size.width) ? headImage.size.width : bodyImage.size.width,
					headImage.size.height + bodyImage.size.height };
					theLayer.position = (CGPoint){ .x = arc4random() % (int)(theBounds.size.width * 3) - theBounds.size.width, .y = arc4random() % (int)theBounds.size.height + theBounds.size.height };
            
				CALayer *headImageLayer = [CALayer layer];
				headImageLayer.bounds = (CGRect){ .size = headImage.size };
				headImageLayer.contents = (id)headImage.CGImage;
				[theLayer addSublayer:headImageLayer];
				
				CALayer *bodyImageLayer = [CALayer layer];
				bodyImageLayer.bounds = (CGRect){ .size = bodyImage.size };
				bodyImageLayer.contents = (id)bodyImage.CGImage;
				bodyImageLayer.position = (CGPoint){ .x = 0, .y = headImage.size.height };
				[theLayer addSublayer:bodyImageLayer];
            /*theImageLayer.bounds = (CGRect){ .size = { 130, 130 } };
            NSString *theImageName = [NSString stringWithFormat:@"avatars_%d_fullfront.png", theUser.avatarID];
            theImageLayer.contents = (id)[UIImage imageNamed:theImageName].CGImage;
            [theLayer addSublayer:theImageLayer];*/			
            
            
//            CATextLayer *theTextLayer = [CATextLayer layer];
//            theTextLayer.bounds = (CGRect){ .size = {64, 64 } };
//            theTextLayer.borderColor = [UIColor colorWithHue:(CGFloat)theUser.avatarID / 26.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
//            theTextLayer.borderWidth = 1.0;
//            theTextLayer.string = theUser.name;
//            [theLayer addSublayer:theTextLayer];

            [self.avatarView.layer addSublayer:theLayer];
            
            objc_setAssociatedObject(theUser, "layer", theLayer, OBJC_ASSOCIATION_RETAIN);
            
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
            CALayer *theLayer = objc_getAssociatedObject(theUser, "layer");
            
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
