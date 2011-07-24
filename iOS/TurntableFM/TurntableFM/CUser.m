//
//  CUser.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CUser.h"

#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

#import "CAvatarLayer.h"

@implementation CUser

@synthesize bobbing;
@synthesize DJing;

- (NSString *)userID
    {
    return([self.parameters objectForKey:@"userid"]);
    }

- (NSString *)name
    {
    return([self.parameters objectForKey:@"name"]);
    }
    
- (NSInteger)avatarID
    {
    return([[self.parameters objectForKey:@"avatarid"] integerValue]);
    }

- (void)setBobbing:(BOOL)inBobbing
    {
    bobbing = inBobbing;

    CAvatarLayer *theLayer = objc_getAssociatedObject(self, "layer");
    theLayer.bobbing = inBobbing;
    }

// I wonder if DJing should just be a type of bobbing; an argument to it.
- (void)setDJing:(BOOL)inDJing
{
    DJing = inDJing;
    CAvatarLayer *theLayer = objc_getAssociatedObject(self, "layer");
    theLayer.DJing = DJing;
}


@end
