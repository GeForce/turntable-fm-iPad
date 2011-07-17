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

- (id)initWithParameters:(NSDictionary *)inParameters;
	{
	if ((self = [super init]) != NULL)
		{
        self.parameters = inParameters;
        [self didInitialize];
		}
	return(self);
	}

- (void)dealloc
    {
    // TODO
    //
    [super dealloc];
    }


- (void)didInitialize
    {
    }


@end
