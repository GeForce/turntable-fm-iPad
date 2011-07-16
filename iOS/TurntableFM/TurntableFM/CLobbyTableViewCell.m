//
//  CLobbyTableViewCell.m
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLobbyTableViewCell.h"

@implementation CLobbyTableViewCell

@synthesize roomName;
@synthesize songTitle;

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
	return 44.0;
}

- (void)preview:(id)sender
{
	
}

@end
