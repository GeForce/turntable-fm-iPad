//
//  CSideViewController.m
//  TurntableFM
//
//  Created by August Joki on 7/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSideViewController.h"

#import "CRoom.h"
#import "CChatViewController.h"
#import "CUsersViewController.h"
#import "CQueueViewController.h"

typedef enum {
	CSideViewSegmentChat = 0,
	CSideViewSegmentUsers,
	CSideViewSegmentQueue
} CSideViewSegments;

static NSString *CSideViewControllerSelectedSegment = @"CSideViewControllerSelectedSegment";

@interface CSideViewController ()

@property(nonatomic, retain) UIViewController *currentViewController;
@property(nonatomic, assign) NSInteger currentIndex;

@end

@implementation CSideViewController

@synthesize segmentedControl;
@synthesize containerView;
@synthesize room;
@synthesize currentViewController;
@synthesize currentIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [segmentedControl release];
    [containerView release];
	[room release];
	[currentViewController release];
	
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	NSInteger selected = [[NSUserDefaults standardUserDefaults] integerForKey:CSideViewControllerSelectedSegment];
	self.segmentedControl.selectedSegmentIndex = selected;
	[self segmentChanged:self.segmentedControl];
}

- (void)viewDidUnload
{
    self.segmentedControl = nil;
    self.containerView = nil;
	self.currentViewController = nil;
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (IBAction)segmentChanged:(id)sender
{
	NSInteger selected = self.segmentedControl.selectedSegmentIndex;
	[[NSUserDefaults standardUserDefaults] setInteger:selected forKey:CSideViewControllerSelectedSegment];
	UIViewController *nextViewController = nil;
	switch (selected) {
		case CSideViewSegmentChat:
		{
			CChatViewController *cvc = [[[CChatViewController alloc] initWithNibName:nil bundle:nil] autorelease];
			//cvc.room = self.room;
			nextViewController = cvc;
		}
			break;
		case CSideViewSegmentUsers:
		{
			CUsersViewController *uvc = [[[CUsersViewController alloc] initWithNibName:nil bundle:nil] autorelease];
			uvc.room = self.room;
			nextViewController = uvc;
		}
			break;
		case CSideViewSegmentQueue:
		{
			CQueueViewController *qvc = [[[CQueueViewController alloc] initWithNibName:nil bundle:nil] autorelease];
			qvc.room = self.room;
			nextViewController = qvc;
		}
			break;
		default:
			break;
	}
	
	[self.currentViewController viewWillDisappear:YES];
	[nextViewController viewWillAppear:YES];
	nextViewController.view.frame = self.containerView.bounds;
	[UIView transitionFromView:self.currentViewController.view
						toView:nextViewController.view
					  duration:(self.currentViewController.view == nil) ? 0.0 : 0.3
					   options:(selected > self.currentIndex) ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft
					completion:^(BOOL finished) {
						[nextViewController viewDidAppear:YES];
						[self.currentViewController viewDidDisappear:YES];
						self.currentViewController = nextViewController;
						self.currentIndex = selected;
					}];
}

@end
