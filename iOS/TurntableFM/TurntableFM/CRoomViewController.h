//
//  CRoomViewController.h
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRoomViewController : UIViewController <UIPopoverControllerDelegate>
{
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *usersButton;
@property (nonatomic, retain) UIBarButtonItem *songButton;
@property (readwrite, nonatomic, retain) IBOutlet UITextView *chatTextView;
@property (readwrite, nonatomic, retain) IBOutlet UITextField *speakTextField;

- (void)launchSongPopoverController;
- (void)launchChatPopoverController;
- (IBAction)voteAwesome;
- (IBAction)voteLame;
- (IBAction)usersTapped:(id)sender;

@end
