//
//  CRoom.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableObject.h"

@class CSong;

@interface CRoom : CTurntableObject

@property (readonly, nonatomic, retain) NSString *roomID;
@property (readonly, nonatomic, retain) NSString *name;

@property (readonly, nonatomic, retain) NSMutableDictionary *usersByUserID;
@property (readonly, nonatomic, retain) NSMutableArray *users;
@property (readwrite, nonatomic, retain) NSMutableArray *DJs;
@property (readwrite, nonatomic, retain) NSMutableArray *chatLog;

@property (readwrite, nonatomic, retain) CSong *currentSong;

- (void)subscribe;
- (void)unsubscribe;

@end
