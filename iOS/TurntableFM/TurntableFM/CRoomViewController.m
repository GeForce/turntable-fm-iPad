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
#import "CSong.h"
#import "CMarqueeView.h"

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

    self.marqueeView.font = [UIFont boldSystemFontOfSize:30];

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
    if ([keyPath isEqualToString:@"room.currentSong"])
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
            
            
            CALayer *theLayer = objc_getAssociatedObject(theUser, "layer");

            CABasicAnimation *thePulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            thePulseAnimation.duration = 0.2;
            thePulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            thePulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            thePulseAnimation.toValue = [NSNumber numberWithFloat:1.2];

            [theLayer addAnimation:thePulseAnimation forKey:@"pulse"];
            
//            [CATransaction begin];
//            [CATransaction setAnimationDuration:0.5];
//            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//            [CATransaction setCompletionBlock:^(void) {
//                [theLayer removeFromSuperlayer];
//                objc_setAssociatedObject(theUser, "layer", NULL, OBJC_ASSOCIATION_RETAIN);
//                }];
//            theLayer.position = (CGPoint){ .x = CGRectGetMaxX(theLayer.superlayer.bounds), .y = theLayer.position.y };
//
//            [CATransaction commit];




            }
        }
    else if ([keyPath isEqualToString:@"room.users"])
        {
        NSMutableArray *theNewLayers = [NSMutableArray array];

        for (CUser *theUser in [change objectForKey:NSKeyValueChangeNewKey])
            {
            CATextLayer *theLayer = [CATextLayer layer];
            theLayer.borderColor = [UIColor colorWithHue:(CGFloat)theUser.avatarID / 26.0 saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
            theLayer.borderWidth = 1.0;
            
            theLayer.string = theUser.name;
            theLayer.bounds = (CGRect){ .size = {64, 64 } };
            theLayer.position = (CGPoint){ .x = arc4random() % (768 * 3) - 768, .y = arc4random() % 768 + 768 };
            [self.view.layer addSublayer:theLayer];
            
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
                    theLayer.position = (CGPoint){ .x = arc4random() % 768, .y = arc4random() % 768 };
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
