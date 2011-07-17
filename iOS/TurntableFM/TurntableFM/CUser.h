//
//  CUser.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableObject.h"

@interface CUser : CTurntableObject

@property (readonly, nonatomic, retain) NSString *userID;
@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic, assign) NSInteger avatarID;
@property (readwrite, nonatomic, assign) BOOL bobbing;

@end
