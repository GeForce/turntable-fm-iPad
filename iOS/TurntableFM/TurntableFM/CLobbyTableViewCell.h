//
//  CLobbyTableViewCell.h
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLobbyTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *listeners;
@property(nonatomic, retain) IBOutlet UIView *listenersView;
@property(nonatomic, retain) IBOutlet UILabel *friends;
@property(nonatomic, retain) IBOutlet UIButton *friendsButton;
@property(nonatomic, retain) IBOutlet UIView *friendsView;
@property(nonatomic, retain) IBOutlet UILabel *roomName;
@property(nonatomic, retain) IBOutlet UILabel *songTitle;
@property(nonatomic, retain) IBOutlet UIButton *previewButton;

@property(nonatomic, retain) NSArray *room;

+ (NSString *)reuseIdentifier;
+ (CGFloat)cellHeight;

- (IBAction)preview:(id)sender;

@end
