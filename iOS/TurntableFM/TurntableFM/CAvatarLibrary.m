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
	NSString *fileName = [@"avatars_" stringByAppendingString:[NSString stringWithFormat:@"%d_", inID]];
	NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"];
	NSString *filePath = [resourcePath stringByAppendingString:fileName];
	
	NSLog(@"Resource path: %@", resourcePath);
	
	UIImage *headImage = nil;
	UIImage *torsoImage = nil;	
	UIImage *rightArmImage = nil;
	UIImage *leftArmImage = nil;	
	UIImage *legsImage = nil;
	UIImage *returnImage = nil;
	
	CGSize imageSize;
	
	BOOL exists;
	
	if (inHead)
	{
		if (inFront)
			headImage = [UIImage imageNamed:[fileName stringByAppendingString:@"headfront.png"]];
		else
			headImage = [UIImage imageNamed:[fileName stringByAppendingString:@"headback.png"]];
		
		imageSize = headImage.size;
		
		UIGraphicsBeginImageContext(imageSize);
		[headImage drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
		returnImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return returnImage;
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
			
			imageSize.width += leftArmImage.size.width + rightArmImage.size.width;
			
			// Load leg images if they exist
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"frontlegs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"frontlegs.png"]];
			else if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"legs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"legs.png"]];
			
			if (legsImage != nil)
				imageSize.height += legsImage.size.height;
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
			
			imageSize.width += leftArmImage.size.width + rightArmImage.size.width;
			
			// Load leg images if they exist
			if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"backlegs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"backlegs.png"]];
			else if ([[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingString:@"legs.png"]])
				legsImage = [UIImage imageNamed:[fileName stringByAppendingString:@"legs.png"]];
			
			if (legsImage != nil)
				imageSize.height += legsImage.size.height;
		}
		
		UIGraphicsBeginImageContext(imageSize);
		[leftArmImage drawAtPoint:CGPointMake(0, 0)];
		[rightArmImage drawAtPoint:CGPointMake(leftArmImage.size.width + torsoImage.size.width - contextOffset * 2, 0)];
		
		if (legsImage != nil)
			[legsImage drawAtPoint:CGPointMake(imageSize.width / 2 - torsoImage.size.width / 2 - contextOffset, torsoImage.size.height - contextOffset)];
		
		[torsoImage drawAtPoint:CGPointMake(leftArmImage.size.width - contextOffset, 0)];
		
		returnImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		return returnImage;
	}				
}


@end
