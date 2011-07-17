//
//  CTurntableFMModel.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTurntableFMSocket;

@class CRoom;
@class CUser;
@class CSong;

@interface CTurntableFMModel : NSObject

@property (readwrite, nonatomic, retain) CTurntableFMSocket *socket;

@property (readonly, nonatomic, retain) NSDictionary *userInfo;
@property (readonly, nonatomic, retain) NSArray *rooms;
@property (readonly, nonatomic, retain) CRoom *room;
@property (readonly, nonatomic, retain) NSArray *songQueue;
@property (readonly, nonatomic) BOOL playing;

+ (CTurntableFMModel *)sharedInstance;

- (void)loginWithFacebookAccessToken:(NSString *)inFacebookAccessToken;

- (void)registerWithRoom:(NSDictionary *)inRoomDescription handler:(void (^)(CRoom *))inHandler;
- (void)unregisterWithRoom:(NSDictionary *)inRoomDescription handler:(void (^)(CRoom *))inHandler;

- (NSURL *)URLForSong:(NSDictionary *)inSong preview:(BOOL)inPreview;

- (void)fanUser:(CUser *)inUser handler:(void (^)(void))inHandler;
- (void)unfanUser:(CUser *)inUser handler:(void (^)(void))inHandler;
- (void)bootUser:(CUser *)inUser handler:(void (^)(void))inHandler;
- (void)removeSongFromPlaylist:(NSInteger)inTeger handler:(void (^)(void))inHandler;
- (void)becomeDJ;

- (void)playSong:(NSDictionary *)inSong preview:(BOOL)inPreview;
- (void)stopSong;

- (void)fetchPlaylist:(void (^)(void))inHandler;

@end
