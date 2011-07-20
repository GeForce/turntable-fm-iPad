//
//  CSong.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSong.h"

@implementation CSong

- (NSString *)songID
    {
        return([self.parameters valueForKeyPath:@"_id"]);
    // return([self.parameters objectForKey:@"songID"]);
    }

- (NSString *)name
    {
    return([self.parameters valueForKeyPath:@"metadata.song"]);
    }

- (NSString *)artist
    {
	return [self.parameters valueForKeyPath:@"metadata.artist"];
    }

- (NSString *)album
    {
    return([self.parameters valueForKeyPath:@"metadata.album"]);
    }

- (NSString *)length
    {
    return([self.parameters valueForKeyPath:@"metadata.length"]);
    }

- (NSURL *)coverartURL
    {
    return([NSURL URLWithString:[self.parameters valueForKeyPath:@"metadata.album"]]);
    }


@end
