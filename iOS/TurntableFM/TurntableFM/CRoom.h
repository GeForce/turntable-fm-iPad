//
//  CRoom.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableObject.h"

@interface CRoom : CTurntableObject

@property (readonly, nonatomic, retain) NSString *roomID;
@property (readonly, nonatomic, retain) NSMutableDictionary *usersByUserID;
@property (readonly, nonatomic, retain) NSMutableArray *users;
@property (readwrite, nonatomic, retain) NSMutableArray *DJs;
@property (readwrite, nonatomic, retain) NSMutableArray *chatLog;

@end
