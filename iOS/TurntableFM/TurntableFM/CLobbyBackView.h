//
//  CLobbyBackView.h
//  TurntableFM
//
//  Created by August Joki on 8/6/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLobbyBackView : UIView

@property (retain, nonatomic) IBOutlet UIView *flipView;
@property (retain, nonatomic) IBOutlet UIImageView *bigArtwork;
@property (retain, nonatomic) IBOutlet UIView *backside;
@property (retain, nonatomic) IBOutlet UIImageView *smallArtwork;
@property (retain, nonatomic) IBOutlet UILabel *roomName;
@property (retain, nonatomic) IBOutlet UILabel *currentSong;

@property(nonatomic, retain) NSArray *room;
@property(nonatomic, retain) UIView *fromView;

- (void)show;

- (IBAction)viewTapped:(id)sender;

@end
