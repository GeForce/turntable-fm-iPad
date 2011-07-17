//
//  CAvatarLibrary.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CAvatarLibrary.h"

#define contextOffset 4


@implementation CAvatarLibrary

@synthesize leftArmPointOffsets, torsoPointOffsets, rightArmPointOffsets, legsPointOffsets;


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
	
	self.leftArmPointOffsets = [[NSMutableArray alloc] initWithObjects:
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 1 long brown hair
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 2
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 3 red fauxhawk pig tails
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 4 orange pig tails
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 5
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 6 red pig tails
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 7 brown hair kid
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 8
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 9
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 10 pin bear
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 11 green bear
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 12 evil drone bear
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 13
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 14
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 15
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 16 evil queen bear
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 17
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 18
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 19
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 20
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 21
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 22
							   [NSValue valueWithCGPoint:CGPointMake(0, 40)],// 23 gorilla
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],// 24 red mouse
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)], // 25 unused
							   [NSValue valueWithCGPoint:CGPointMake(0, 0)],nil];
	
	self.torsoPointOffsets = [[NSMutableArray alloc] initWithObjects:
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 1 long brown hair
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 2
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 3 red fauxhawk pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 4 orange pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 5
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 6 red pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 7 brown hair kid
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 8
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 9
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 10 pin bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 11 green bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 12 evil drone bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 13
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 14
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 15
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 16 evil queen bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 17
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 18
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 19
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 20
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 21
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 22
							   [NSValue valueWithCGPoint:CGPointMake(-35, 0)],// 23 gorilla
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 24 red mouse
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)], // 25 unused
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],nil];
	
	self.rightArmPointOffsets = [[NSMutableArray alloc] initWithObjects:
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 1 long brown hair
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 2
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 3 red fauxhawk pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 4 orange pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 5
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 6 red pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 7 brown hair kid
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 8
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 9
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 10 pin bear
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 11 green bear
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 12 evil drone bear
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 13
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 14
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 15
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 16 evil queen bear
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 17
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 18
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 19
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 20
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 21
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 22
							   [NSValue valueWithCGPoint:CGPointMake(-70, 30)],// 23 gorilla
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],// 24 red mouse
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)], // 25 unused
							   [NSValue valueWithCGPoint:CGPointMake(-4, 0)],nil];
	
	self.legsPointOffsets = [[NSMutableArray alloc] initWithObjects:
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 1 long brown hair
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 2
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 3 red fauxhawk pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 4 orange pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 5
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 6 red pig tails
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 7 brown hair kid
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 8
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 9
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 10 pin bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 11 green bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 12 evil drone bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 13
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 14
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 15
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 16 evil queen bear
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 17
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 18
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 19
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 20
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 21
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 22
							   [NSValue valueWithCGPoint:CGPointMake(-3, 0)],// 23 gorilla
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],// 24 red mouse
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)], // 25 unused
							   [NSValue valueWithCGPoint:CGPointMake(-2, 0)],nil];
    
    return self;
}

- (UIImage *)imageForAvatar:(NSInteger)inID head:(BOOL)inHead front:(BOOL)inFront
{
	NSString *fileName = [@"avatars_" stringByAppendingString:[NSString stringWithFormat:@"%d_", inID]];
	NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"];
	NSString *filePath = [resourcePath stringByAppendingString:fileName];
	
	
	UIImage *headImage = nil;
	UIImage *torsoImage = nil;	
	UIImage *rightArmImage = nil;
	UIImage *leftArmImage = nil;	
	UIImage *legsImage = nil;
	UIImage *returnImage = nil;
	
	CGSize imageSize;
	CGPoint leftArmOffset = [[leftArmPointOffsets objectAtIndex:inID - 1] CGPointValue];
	CGPoint torsoOffset = [[torsoPointOffsets objectAtIndex:inID - 1] CGPointValue];
	CGPoint rightArmOffset = [[rightArmPointOffsets objectAtIndex:inID - 1] CGPointValue];
	CGPoint legsOffset = [[legsPointOffsets objectAtIndex:inID - 1] CGPointValue];

	
	BOOL exists;
	
	if (inHead)
	{
		if (inFront)
			headImage = [UIImage imageNamed:[fileName stringByAppendingString:@"headfront.png"]];
		else
			headImage = [UIImage imageNamed:[fileName stringByAppendingString:@"headback.png"]];
            
		return headImage;
	}
	else
	{		
		if (inFront)
		{
			// Load torso image
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"fronttorso.png"]])	
				torsoImage = [UIImage imageNamed:[fileName stringByAppendingString:@"fronttorso.png"]];
			else
				torsoImage = [UIImage imageNamed:[fileName stringByAppendingString:@"torso.png"]];
			
			imageSize = torsoImage.size;
			
			// Load arm images
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"leftarm_front.png"]])
			{
				leftArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"leftarm_front.png"]];
				rightArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"rightarm_front.png"]];
			}
			else
			{
				leftArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"leftarm.png"]];
				rightArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"rightarm.png"]];
			}
			
			imageSize.width += leftArmImage.size.width + leftArmOffset.x + rightArmImage.size.width + rightArmOffset.y;
			
			// Load leg images if they exist
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"frontlegs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"frontlegs.png"]];
			else if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"legs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"legs.png"]];
			
			if (legsImage != nil)
				imageSize.height += legsImage.size.height + torsoOffset.y;
		}
		else
		{
			// Load torso image
			exists = [[NSFileManager defaultManager] fileExistsAtPath:[resourcePath stringByAppendingString:@"backtorso.png"]];
			
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"backtorso.png"]])
				torsoImage = [UIImage imageNamed:[fileName stringByAppendingString:@"backtorso.png"]];
			else
				torsoImage = [UIImage imageNamed:[fileName stringByAppendingString:@"torso.png"]];
			
			imageSize = torsoImage.size;
			
			// Load arm images
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"leftarm_back.png"]])
			{
				leftArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"leftarm_back.png"]];
				rightArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"rightarm_back.png"]];
			}
			else
			{
				leftArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"leftarm.png"]];
				rightArmImage = [UIImage imageNamed:[fileName stringByAppendingString:@"rightarm.png"]];
			}
			
			imageSize.width += leftArmImage.size.width + leftArmOffset.x + rightArmImage.size.width + rightArmOffset.y;
			
			// Load leg images if they exist
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"backlegs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"backlegs.png"]];
			else if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"legs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"legs.png"]];
			
			if (legsImage != nil)
				imageSize.height += legsImage.size.height + torsoOffset.y;
		}
		
		UIGraphicsBeginImageContext(imageSize);
		[leftArmImage drawAtPoint:CGPointMake(leftArmOffset.x, leftArmOffset.y)];
		[rightArmImage drawAtPoint:CGPointMake(leftArmImage.size.width + torsoImage.size.width + torsoOffset.x + rightArmOffset.x, rightArmOffset.y)];
		
		if (legsImage != nil)
			[legsImage drawAtPoint:CGPointMake(imageSize.width / 2 - torsoImage.size.width / 2 + legsOffset.x, torsoImage.size.height + legsOffset.y)];
		
		[torsoImage drawAtPoint:CGPointMake(leftArmImage.size.width + torsoOffset.x, torsoOffset.y)];
		
		returnImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return returnImage;
	}				
}


@end
