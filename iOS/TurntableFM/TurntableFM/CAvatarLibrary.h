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
	NSMutableArray *leftShoulderPoint;
	NSMutableArray *rightShoulderPoint;
	NSMutableArray *legsPoint;
}

@property (nonatomic, retain) NSMutableArray *leftShoulderPoint;
@property (nonatomic, retain) NSMutableArray *rightShoulderPoint;
@property (nonatomic, retain) NSMutableArray *legsPoint;

+ (CAvatarLibrary *)sharedInstance;
- (UIImage *)imageForAvatar:(NSInteger)inID head:(BOOL)inHead front:(BOOL)inFront;

@end
