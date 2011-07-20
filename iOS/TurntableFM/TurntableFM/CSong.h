//
//  CSong.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableObject.h"

@interface CSong : CTurntableObject

@property (readonly, nonatomic, retain) NSString *songID;
@property (readonly, nonatomic, retain) NSString *name;
@property (readonly, nonatomic, retain) NSString *artist;
@property (readonly, nonatomic, retain) NSString *album;
@property (readonly, nonatomic, retain) NSString *length;
@property (readonly, nonatomic, retain) NSURL *coverartURL;

@end
