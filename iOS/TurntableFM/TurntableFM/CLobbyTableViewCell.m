//
//  CLobbyTableViewCell.m
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLobbyTableViewCell.h"

@interface CLobbyTableViewCell ()

@property(nonatomic, retain) NSMutableData *data;

@end

@implementation CLobbyTableViewCell

@synthesize number;
@synthesize roomName;
@synthesize songTitle;
@synthesize previewButton;
@synthesize coverArt;
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
	
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	UIImage *image = [UIImage imageWithData:self.data];
	self.data = nil;
	[self.previewButton setImage:image forState:UIControlStateNormal];
}

@end
