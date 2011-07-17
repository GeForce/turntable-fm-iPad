//
//  CTurntableObject.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableObject.h"

@interface CTurntableObject ()

@property (readwrite, nonatomic, retain) NSDictionary *parameters;

@end

@implementation CTurntableObject

@synthesize parameters;

- (id)initWithParameter:(NSDictionary *)inDictionary;
	{
	if ((self = [super init]) != NULL)
		{
		}
	return(self);
	}


@end
