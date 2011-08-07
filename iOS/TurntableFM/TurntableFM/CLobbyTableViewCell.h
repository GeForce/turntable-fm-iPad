//
//  CLobbyTableViewCell.h
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLobbyTableViewCellDelegate;

@interface CLobbyTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutletCollection(UIImageView) NSArray *artworks;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *names;

@property(nonatomic, copy) NSArray *rooms;
@property(nonatomic, assign) id<CLobbyTableViewCellDelegate> delegate;

+ (NSString *)reuseIdentifier;
+ (CGFloat)cellHeight;
+ (NSInteger)roomCount;

- (IBAction)artworkTapped:(UIGestureRecognizer *)sender;

@end

@protocol CLobbyTableViewCellDelegate <NSObject>

- (void)lobbyCell:(CLobbyTableViewCell *)cell didSelectRoom:(NSArray *)room;

@end
