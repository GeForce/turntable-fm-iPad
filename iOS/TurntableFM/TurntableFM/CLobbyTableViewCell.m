//
//  CLobbyTableViewCell.m
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLobbyTableViewCell.h"

#import "CTurntableFMModel.h"

@interface CLobbyTableViewCell ()

@property(nonatomic, copy) NSString *coverArt;
@property(nonatomic, retain) NSMutableData *data;

@end

@implementation CLobbyTableViewCell

@synthesize number;
@synthesize roomName;
@synthesize songTitle;
@synthesize previewButton;
@synthesize coverArt;
@synthesize room;
@synthesize data;

+ (NSString *)reuseIdentifier
{
	static NSString *reuseIdentifier = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		reuseIdentifier = [NSStringFromClass([self class]) retain];
	});
	
	return reuseIdentifier;
}

+ (CGFloat)cellHeight
{
	return 50.0;
}

- (void)setRoom:(NSArray *)aRoom
{
	if (room != aRoom) {
		[room release];
		room = [aRoom retain];
		
		NSDictionary *description = [room objectAtIndex:0];
		NSDictionary *metadata = [description objectForKey:@"metadata"];
		self.number.text = [[metadata objectForKey:@"listeners"] stringValue];
		self.roomName.text = [description objectForKey:@"name"];
		NSDictionary *song = [metadata objectForKey:@"current_song"];
		metadata = [song objectForKey:@"metadata"];
		self.songTitle.text = [NSString stringWithFormat:@"%@ - %@", [metadata objectForKey:@"song"], [metadata objectForKey:@"artist"]];
		NSString *ca = [metadata objectForKey:@"coverart"];
		if (ca.length != 0) {
			self.coverArt = ca;
		}
		else {
			self.coverArt = nil;
		}
	}
}

- (void)setCoverArt:(NSString *)ca
{
	if (ca != coverArt) {
		[coverArt release];
		coverArt = [ca copy];
		
		[self.previewButton setImage:[UIImage imageNamed:@"rspeaker1.png"] forState:UIControlStateNormal];
		
		if (coverArt != nil) {
			NSURL *url = [NSURL URLWithString:coverArt];
			NSURLRequest *request = [NSURLRequest requestWithURL:url];
			[NSURLConnection connectionWithRequest:request delegate:self];
		}
	}
}

- (void)preview:(id)sender
{
    id theSong = [[self.room objectAtIndex:0] valueForKeyPath:@"metadata.current_song"];
	[[CTurntableFMModel sharedInstance] playSong:theSong preview:YES];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dt
{
	[self.data appendData:dt];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	UIImage *image = [UIImage imageWithData:self.data];
	self.data = nil;
	[self.previewButton setImage:image forState:UIControlStateNormal];
}

@end
