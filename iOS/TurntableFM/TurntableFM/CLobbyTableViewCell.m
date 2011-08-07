//
//  CLobbyTableViewCell.m
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLobbyTableViewCell.h"

#import <QuartzCore/QuartzCore.h>

#import "CTurntableFMModel.h"

@interface CLobbyTableViewCell ()

@property(nonatomic, retain) NSMutableArray *connections;
@property(nonatomic, retain) NSMutableArray *datas;
@property(nonatomic, retain) NSMutableArray *imageViews;

@end

@implementation CLobbyTableViewCell

@synthesize artworks;
@synthesize names;
@synthesize rooms;
@synthesize delegate;
@synthesize connections;
@synthesize datas;
@synthesize imageViews;

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
	return 114.0;
}

+ (NSInteger)roomCount
{
	return 5;
}

- (void)awakeFromNib
{
	for (UIImageView *imageView in self.artworks) {
		UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(artworkTapped:)];
		[imageView addGestureRecognizer:recog];
		[recog release];
	}
}

- (void)setRooms:(NSArray *)aRooms
{
	if (rooms != aRooms) {
		[rooms release];
		rooms = [aRooms copy];
		
		NSInteger ii = 0;
		for (NSArray *room in rooms) {
			NSDictionary *description = [room objectAtIndex:0];
			UILabel *label = [self.names objectAtIndex:ii];
			label.text = [description objectForKey:@"name"];
			
			UIImageView *imageView = [self.artworks objectAtIndex:ii];
			imageView.image = [UIImage imageNamed:@"images_record_logo.gif"];
			CGPathRef path = CGPathCreateWithRect(imageView.bounds, NULL);
			imageView.layer.shadowPath = path;
			CGPathRelease(path);
			imageView.layer.shadowOpacity = 0.5;
			imageView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
			NSDictionary *metadata = [description objectForKey:@"metadata"];
			NSDictionary *song = [metadata objectForKey:@"current_song"];
			metadata = [song objectForKey:@"metadata"];
			NSString *coverArt = [metadata objectForKey:@"coverart"];
			if (coverArt.length != 0) {
				NSURL *url = [NSURL URLWithString:coverArt];
				NSURLRequest *request = [NSURLRequest requestWithURL:url];
				NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
				
				if (connection != nil) {
					[self.connections addObject:connection];
					[self.datas addObject:[NSMutableData data]];
					[self.imageViews addObject:imageView];
				}
			}
			/*
			NSDictionary *song = [metadata objectForKey:@"current_song"];
			metadata = [song objectForKey:@"metadata"];
			NSString *songName = [metadata objectForKey:@"song"];
			NSString *artistName = [metadata objectForKey:@"artist"];
			if (songName.length != 0 && artistName.length != 0) {
				self.songTitle.text = [NSString stringWithFormat:@"%@ - %@", [metadata objectForKey:@"song"], [metadata objectForKey:@"artist"]];
			}
			else if (songName.length == 0 && artistName.length == 0) {
				self.songTitle.text = @"No song currently playing.";
			}
			else if (songName.length != 0) {
				self.songTitle.text = songName;
			}
			else { // artistName.length != 0
				self.songTitle.text = artistName;
			}
			NSString *ca = [metadata objectForKey:@"coverart"];
			if (ca.length != 0) {
				self.coverArt = ca;
			}
			else {
				self.coverArt = nil;
			}
			
			NSArray *array = [room objectAtIndex:1];
			NSInteger count = array.count;
			if (count != 0) {
				self.friendsView.hidden = NO;
				self.friends.text = [NSString stringWithFormat:@"%d", count];
				self.listenersView.transform = CGAffineTransformIdentity;
			}
			else {
				self.friendsView.hidden = YES;
				self.listenersView.transform = CGAffineTransformMakeTranslation(0, 19);
			}
			*/
			ii++;
		}
		for (NSInteger jj = ii; ii < self.artworks.count; jj++) {
			UILabel *label = [self.names objectAtIndex:ii];
			label.text = nil;
			
			UIImageView *imageView = [self.artworks objectAtIndex:ii];
			imageView.image = nil;
		}
	}
}

#pragma mark - Properties

- (NSMutableArray *)connections
{
	if (connections == nil) {
		self.connections = [NSMutableArray array];
	}
	return connections;
}

- (NSMutableArray *)datas
{
	if (datas == nil) {
		self.datas = [NSMutableArray array];
	}
	return datas;
}

- (NSMutableArray *)imageViews
{
	if (imageViews == nil) {
		self.imageViews = [NSMutableArray array];
	}
	return imageViews;
}

/*
- (void)preview:(id)sender
{
	CTurntableFMModel *model = [CTurntableFMModel sharedInstance];
	if (model.playing) {
		[model stopSong];
	}
	else {
		id theSong = [[self.room objectAtIndex:0] valueForKeyPath:@"metadata.current_song"];
		[model playSong:theSong preview:YES];
	}
}
*/

#pragma mark - IBActions

- (void)artworkTapped:(UIGestureRecognizer *)sender
{
	NSInteger ii = 0;
	for (UIImageView *imageView in self.artworks) {
		for (UIGestureRecognizer *recognizer in imageView.gestureRecognizers) {
			if (sender == recognizer) {
				NSArray *room = [self.rooms objectAtIndex:ii];
				[self.delegate lobbyCell:self didSelectRoom:room];
				return;
			}
		}
		ii++;
	}
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData
{
	NSInteger idx = [self.connections indexOfObject:connection];
	NSMutableData *data = [self.datas objectAtIndex:idx];
	[data appendData:aData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSInteger idx = [self.connections indexOfObject:connection];
	NSMutableData *data = [self.datas objectAtIndex:idx];
	UIImage *image = [UIImage imageWithData:data];
	UIImageView *imageView = [self.imageViews objectAtIndex:idx];
	imageView.image = image;
	
	[self.connections removeObject:connection];
	[self.datas removeObject:data];
	[self.imageViews removeObject:imageView];
}

- (void)dealloc {
    [artworks release];
    [names release];
	
	[rooms release];
	
	[connections release];
	[datas release];
	[imageViews release];
	
    [super dealloc];
}
@end
