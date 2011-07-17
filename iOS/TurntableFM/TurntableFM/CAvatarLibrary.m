//
//  CAvatarLibrary.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CAvatarLibrary.h"

@implementation CAvatarLibrary


static CAvatarLibrary *gSharedInstance = NULL;

+ (CAvatarLibrary *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CAvatarLibrary alloc] init];
        });
    return(gSharedInstance);
    }

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (UIImage *)imageForAvatar:(NSInteger)inID head:(BOOL)inHead front:(BOOL)inFront
    {
// UIGraphicsBeginImageContextWithOptions(<#CGSize size#>, <#BOOL opaque#>, <#CGFloat scale#>)
// DRAW
// UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
// UIGraphicsEndImageContext();
    }


@end
