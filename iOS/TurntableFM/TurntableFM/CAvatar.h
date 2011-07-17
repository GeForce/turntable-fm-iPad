//
//  CAvatar.h
//  TurntableFM
//
//  Created by Jon Conner on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CAvatar : UIView 
{
    UIImageView *headFront;
	UIImageView *headBack;
	UIImageView *torsoFront;
	UIImageView *torsoBack;
	
	BOOL isHeadBobbing;
	BOOL isDJ;
}

- (id)initWithStyle:(NSInteger)styleNumber;
- (void)bobHead;

@end
