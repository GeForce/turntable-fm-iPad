//
//  CTurntableFMSocket.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSocketIO.h"

@interface CTurntableFMSocket : CSocketIO

@property (readwrite, nonatomic, retain) NSString *clientID;
@property (readwrite, nonatomic, retain) NSString *userID;
@property (readwrite, nonatomic, retain) NSString *userAuth;

- (void)addHandler:(void (^)(id))inHandler forCommand:(NSString *)inCommand;
- (void)removeHandler:(void (^)(id))inHandler forCommand:(NSString *)inCommand;


- (void)postMessage:(NSString *)inAPI dictionary:(NSDictionary *)inDictionary handler:(void (^)(id inResult))inHandler;

@end
