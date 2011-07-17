//
//  CSideViewController.h
//  TurntableFM
//
//  Created by August Joki on 7/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRoom;

@interface CSideViewController : UIViewController

@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, retain) IBOutlet UIView *containerView;

@property(nonatomic, retain) CRoom *room;

- (IBAction)segmentChanged:(id)sender;

@end
