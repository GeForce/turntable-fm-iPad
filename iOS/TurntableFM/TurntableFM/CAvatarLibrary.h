//
//  CAvatarLibrary.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAvatarLibrary : NSObject
{
	NSMutableArray *leftArmPointOffsets;
	NSMutableArray *torsoPointOffsets;
	NSMutableArray *rightArmPointOffsets;
	NSMutableArray *legsPointOffsets;
}

@property (nonatomic, retain) NSMutableArray *leftArmPointOffsets;
@property (nonatomic, retain) NSMutableArray *torsoPointOffsets;
@property (nonatomic, retain) NSMutableArray *rightArmPointOffsets;
@property (nonatomic, retain) NSMutableArray *legsPointOffsets;

+ (CAvatarLibrary *)sharedInstance;
- (UIImage *)imageForAvatar:(NSInteger)inID head:(BOOL)inHead front:(BOOL)inFront;

@end
