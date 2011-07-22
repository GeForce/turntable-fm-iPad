//
//  CRoomViewController.h
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRoom;
@class CMarqueeView;

@interface CRoomViewController : UIViewController <UIPopoverControllerDelegate>
{
	NSMutableArray *neckOffsets;
}

@property (nonatomic, retain) IBOutlet UIBarButtonItem *usersButton;
@property (readonly, nonatomic, retain) CRoom *room;
@property (nonatomic, retain) UIBarButtonItem *songButton;
@property (readwrite, nonatomic, retain) IBOutlet UIView *avatarView;
@property (readwrite, nonatomic, retain) IBOutlet UIView *DJView;
@property (nonatomic, retain) IBOutlet UIView *chatView;
@property (readwrite, nonatomic, retain) IBOutlet UITextView *chatTextView;
@property (readwrite, nonatomic, retain) IBOutlet UITextField *speakTextField;
@property (readwrite, nonatomic, retain) IBOutlet CMarqueeView *marqueeView;
@property (nonatomic, retain) NSMutableArray *neckOffsets;
@property (nonatomic, retain) IBOutlet UIToolbar *toolBar;


- (id)initWithRoom:(CRoom *)inRoom;

- (IBAction)voteAwesome;
- (IBAction)voteLame;
- (IBAction)usersTapped:(id)sender;
- (IBAction)djTapped:(id)sender;

@end
