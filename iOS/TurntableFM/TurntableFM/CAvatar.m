//
//  CAvatar.m
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CAvatar.h"


@implementation CAvatar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithStyle:(NSInteger)styleNumber atPoint:(CGPoint)point
{
	[super init];
	
	NSString *filePath = [@"avatars" stringByAppendingString:[NSString stringWithFormat:@"%d", styleNumber]];
	
	UIImage *torsoFrontImage = nil;
	UIImage *torsoBackImage = nil;
	
	UIImage *rightArmFrontImage = nil;
	UIImage *rightArmBackImage = nil;
	
	UIImage *leftArmFrontImage = nil;
	UIImage *leftArmBackImage = nil;
	
	UIImage *legsFrontImage = nil;
	UIImage *legsBackImage = nil;
	
	UIImage *headBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"headback.png"]];
	UIImage *headFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"headfront.png"]];
	
	// Load arm images
	if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"leftarm_back.png"]])
	{
		leftArmBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"leftarm_back.png"]];
		leftArmFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"leftarm_front.png"]];
		rightArmBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"rightarm_back.png"]];
		rightArmFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"rightarm_front.png"]];
	}
	else
	{
		leftArmBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"leftarm.png"]];
		leftArmFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"leftarm.png"]];
		rightArmBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"rightarm.png"]];
		rightArmFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"rightarm.png"]];
	}
	
	// Load leg images if they exist
	if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"frontlegs.png"]])
	{
		legsFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"frontlegs.png"]];
		legsBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"backlegs.png"]];
	}
	else if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"legs.png"]])
	{
		legsFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"legs.png"]];
		legsBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"legs.png"]];
	}
	
	// Load torso image
	if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"backtorso.png"]]) {		
		torsoBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"backtorso.png"]];
		torsoFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"fronttorso.png"]];
	}
	else
	{
		torsoBackImage = [UIImage imageNamed:[filePath stringByAppendingString:@"torso.png"]];
		torsoFrontImage = [UIImage imageNamed:[filePath stringByAppendingString:@"torso.png"]];
	}
	
	CGSize headSize;
	CGSize torsoSize;
	
	return self;
}

- (void)bobHead
{
	
}

@end
