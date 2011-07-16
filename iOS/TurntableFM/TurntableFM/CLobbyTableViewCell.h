//
//  CLobbyTableViewCell.h
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLobbyTableViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UILabel *roomName;
@property(nonatomic, retain) IBOutlet UILabel *songTitle;

+ (NSString *)reuseIdentifier;
+ (CGFloat)cellHeight;

- (IBAction)preview:(id)sender;

@end
