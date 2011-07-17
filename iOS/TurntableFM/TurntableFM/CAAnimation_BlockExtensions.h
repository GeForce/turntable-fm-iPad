//
//  CAAnimation_BlockExtensions.h
//  SigninTest
//
//  Created by Jonathan Wight on 07/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CAAnimation_BlockExtensions)

@property (readwrite, copy) void (^animationDidStartHandler)(CAAnimation *inAnimation);
@property (readwrite, copy) void (^animationDidStopHandler)(CAAnimation *inAnimation, BOOL inFinished);

@end
