//
//  CAAnimation_BlockExtensions.m
//  SigninTest
//
//  Created by Jonathan Wight on 07/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CAAnimation_BlockExtensions.h"

#import <objc/runtime.h>

@interface CAAnimationDelegateStandin : NSObject /*<CAAnimationDelegate>*/ {
}

@end

#pragma mark -

@implementation CAAnimation (CAAnimation_BlockExtensions)

- (void (^)(CAAnimation *))animationDidStartHandler
    {
    return([self valueForKey:@"S9AnimationDidStartHandler"]);
    }

- (void)setAnimationDidStartHandler:(void (^)(CAAnimation *))inHandler
    {
    void  (^theHandler)(CAAnimation *) = [self valueForKey:@"S9AnimationDidStartHandler"];
    if (theHandler != inHandler)
        {
        [self setValue:[[inHandler copy] autorelease] forKey:@"S9AnimationDidStartHandler"];
        
        CAAnimationDelegateStandin *theStandin = [self valueForKey:@"S9DelegateStandin"];
        if (theStandin == NULL)
            {
            theStandin = [[[CAAnimationDelegateStandin alloc] init] autorelease];
            objc_setAssociatedObject(self, "S9DelegateStandin", theStandin, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            self.delegate = theStandin;
            }
        }
    }

- (void (^)(CAAnimation *, BOOL))animationDidStopHandler
    {
    return([self valueForKey:@"S9AnimationDidStopHandler"]);
    }

- (void)setAnimationDidStopHandler:(void (^)(CAAnimation *, BOOL))inHandler
    {
    void  (^theHandler)(CAAnimation *, BOOL) = [self valueForKey:@"S9AnimationDidStopHandler"];
    if (theHandler != inHandler)
        {
        [self setValue:[[inHandler copy] autorelease] forKey:@"S9AnimationDidStopHandler"];
        
        CAAnimationDelegateStandin *theStandin = [self valueForKey:@"S9DelegateStandin"];
        if (theStandin == NULL)
            {
            theStandin = [[[CAAnimationDelegateStandin alloc] init] autorelease];
            objc_setAssociatedObject(self, "S9DelegateStandin", NULL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

            self.delegate = theStandin;
            }
        }
    }

@end

#pragma mark -

@implementation CAAnimationDelegateStandin

- (void)animationDidStart:(CAAnimation *)anim
    {
    if (anim.animationDidStartHandler)
        {
        anim.animationDidStartHandler(anim);
        }
    }

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
    {
    if (anim.animationDidStopHandler)
        {
        anim.animationDidStopHandler(anim, flag);
        }
    }

@end