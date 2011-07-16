//
//  CRoomViewController.h
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CChatViewController;
@class CSongViewController;

@interface CRoomViewController : UIViewController <UIPopoverControllerDelegate>
{
    IBOutlet UIBarButtonItem *chatButton;
	UIBarButtonItem *songButton;
	UIPopoverController *chatPopoverController;
	UIPopoverController *songPopoverController;	
	CChatViewController *chatViewController;
	CSongViewController *songViewController;
}

@property (nonatomic, retain) UIBarButtonItem *chatButton;
@property (nonatomic, retain) UIBarButtonItem *songButton;
@property (nonatomic, retain) UIPopoverController *chatPopoverController;
@property (nonatomic, retain) UIPopoverController *songPopoverController;
@property (nonatomic, retain) CChatViewController *chatViewController;
@property (nonatomic, retain) CSongViewController *songViewController;

- (void)launchSongPopoverController;
- (void)launchChatPopoverController;
- (IBAction)voteAwesome;
- (IBAction)voteLame;

@end
