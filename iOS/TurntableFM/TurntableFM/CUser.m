//
//  CUser.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CUser.h"

@implementation CUser

- (NSString *)userID
    {
    return([self.parameters objectForKey:@"userid"]);
    }

- (NSString *)name
    {
    return([self.parameters objectForKey:@"name"]);
    }

@end
