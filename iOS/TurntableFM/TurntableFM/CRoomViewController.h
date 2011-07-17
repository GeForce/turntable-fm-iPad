//
//  CRoomViewController.h
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRoom;
@class CChatViewController;
@class CSongViewController;
@class CMarqueeView;

@interface CRoomViewController : UIViewController <UIPopoverControllerDelegate>
{
    IBOutlet UIBarButtonItem *chatButton;
	UIBarButtonItem *songButton;
	UIPopoverController *chatPopoverController;
	UIPopoverController *songPopoverController;	
	CChatViewController *chatViewController;
	CSongViewController *songViewController;
}

@property (readonly, nonatomic, retain) CRoom *room;

@property (nonatomic, retain) UIBarButtonItem *chatButton;
@property (nonatomic, retain) UIBarButtonItem *songButton;
@property (nonatomic, retain) UIPopoverController *chatPopoverController;
@property (nonatomic, retain) UIPopoverController *songPopoverController;
@property (nonatomic, retain) CChatViewController *chatViewController;
@property (nonatomic, retain) CSongViewController *songViewController;
@property (readwrite, nonatomic, retain) IBOutlet UITextView *chatTextView;
@property (readwrite, nonatomic, retain) IBOutlet UITextField *speakTextField;
@property (readwrite, nonatomic, retain) IBOutlet CMarqueeView *marqueeView;


- (id)initWithRoom:(CRoom *)inRoom;

- (void)launchSongPopoverController;
- (void)launchChatPopoverController;
- (IBAction)voteAwesome;
- (IBAction)voteLame;

@end
