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
    if (DJing == YES) 
        { // This animation should be re-done with useful 
        self.headLayer.anchorPoint = (CGPoint){ .x = 0.5, .y = 1.0 };
        self.headLayer.position = (CGPoint){ .x = 0, .y = self.headLayer.bounds.size.height * 0.5 };
        CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        theAnimation.speed = 0.48;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        theAnimation.fromValue=[NSValue valueWithCGPoint:CGPointMake(0.0,32.0)];
        theAnimation.toValue=[NSValue valueWithCGPoint:CGPointMake(0.0,41.0)];
        theAnimation.repeatCount = HUGE_VALF;
        theAnimation.autoreverses = YES;

        [self.headLayer addAnimation:theAnimation forKey:@"DJing"];
        }
    else
        {
        [self.headLayer removeAllAnimations]; // All?
        }
    }


- (void)setBobbing:(BOOL)inBobbing
    {
    bobbing = inBobbing;
    
    self.headLayer.anchorPoint = (CGPoint){ .x = 0.5, .y = 1.0 };
    self.headLayer.position = (CGPoint){ .x = 0, .y = self.headLayer.bounds.size.height * 0.5 };
    
    if (bobbing == YES)
        {
        CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        theAnimation.speed = 0.32;
        theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        theAnimation.fromValue = [NSNumber numberWithDouble:-13 * 0.0174532925];
        theAnimation.toValue = [NSNumber numberWithDouble:13 * 0.0174532925];
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
