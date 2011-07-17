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
@synthesize bobbing;

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
        theAnimation.fromValue = [NSNumber numberWithDouble:-15 * 0.0174532925];
        theAnimation.toValue = [NSNumber numberWithDouble:15 * 0.0174532925];
        theAnimation.repeatCount = 10000000;
        theAnimation.autoreverses = YES;
        [self.headLayer addAnimation:theAnimation forKey:@"bobbing"];
        }
    else
        {
        [self.headLayer removeAllAnimations];
        }
    }


@end
