//
//  CAvatarLayer.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CAvatarLayer.h"

@implementation CAvatarLayer

@synthesize headLayer;
@synthesize bodyLayer;
@synthesize DJing;
@synthesize bobbing;

- (void)setDJing:(BOOL)inDJing
    {
    DJing = inDJing;
    }


- (void)setBobbing:(BOOL)inBobbing
    {
    bobbing = inBobbing;
    
    self.headLayer.anchorPoint = (CGPoint){ .x = 0.5, .y = 1.0 };
    self.headLayer.position = (CGPoint){ .x = 0, .y = self.headLayer.bounds.size.height * 0.5 };
    
    if (bobbing == YES)
        {
        CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        theAnimation.speed = 0.4;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        theAnimation.fromValue = [NSNumber numberWithDouble:-14 * 0.0174532925];
        theAnimation.toValue = [NSNumber numberWithDouble:14 * 0.0174532925];
        theAnimation.repeatCount = HUGE_VALF;
        theAnimation.autoreverses = YES;
        [self.headLayer addAnimation:theAnimation forKey:@"bobbing"];
        }
    else
        {
        [self.headLayer removeAllAnimations];
        }
    }


@end
