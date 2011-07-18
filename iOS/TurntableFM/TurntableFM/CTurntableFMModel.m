;
//
//  CTurntableFMModel.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableFMModel.h"

#import <AVFoundation/AVFoundation.h>

#import "CTurntableFMSocket.h"
#import "CURLOperation.h"
#import "NSData_DigestExtensions.h"
#import "NSData_Extensions.h"
#import "CRoom.h"
#import "CUser.h"
#import "CSong.h"

@interface CTurntableFMModel () <AVAudioPlayerDelegate>
@property (readwrite, nonatomic, retain) NSDictionary *userInfo;
@property (readwrite, nonatomic, retain) NSArray *rooms;
@property (readwrite, nonatomic, retain) CRoom *room;
@property (readwrite, nonatomic, retain) NSArray *songQueue;
@property (readwrite, nonatomic, retain) NSOperationQueue *queue;
@property (readwrite, nonatomic, assign) NSTimeInterval roomTime;
@property (readwrite, nonatomic, retain) AVPlayer *player;

@end

#pragma mark -

@implementation CTurntableFMModel

@synthesize socket;
@synthesize userInfo;
@synthesize rooms;
@synthesize room;
@synthesize songQueue;

@synthesize queue;
@synthesize roomTime;
@synthesize player;

static CTurntableFMModel *gSharedInstance = NULL;

+ (CTurntableFMModel *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CTurntableFMModel alloc] init];
        });
    return(gSharedInstance);
    }

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
		}
	return(self);
	}

- (void)dealloc
    {
    // TODO
    //
    [super dealloc];
    }

- (void)loginWithFacebookAccessToken:(NSString *)inFacebookAccessToken;
    {
    self.queue = [[[NSOperationQueue alloc] init] autorelease];

    
    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://turntable.fm/?fbtoken=%@", inFacebookAccessToken]];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    CURLOperation *theOperation = [[[CURLOperation alloc] initWithRequest:theRequest] autorelease];
    theOperation.completionBlock = ^(void) {
        self.socket = [[[CTurntableFMSocket alloc] init] autorelease];
        for (NSHTTPCookie *theCookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:theURL])
            {
            if ([theCookie.name isEqualToString:@"turntableUserAuth"])
                {
                self.socket.userAuth = theCookie.value;
                }
            else if ([theCookie.name isEqualToString:@"turntableUserId"])
                {
                self.socket.userID = theCookie.value;
                }
            }
         
        self.socket.didConnectHandler = ^(void) {
            [self.socket postMessage:@"user.authenticate" dictionary:NULL handler:^(id inResult) {
                [self.socket postMessage:@"user.info" dictionary:NULL handler:^(id inResult) {
                    self.userInfo = inResult;
                    }];
                
                
                [self.socket postMessage:@"room.list_rooms" dictionary:NULL handler:^(id inResult) {
                    self.rooms = [inResult objectForKey:@"rooms"];
                    }];
                }];
            };
        
        [self.socket main];
        
        };

    [self.queue addOperation:theOperation];
    }

- (void)registerWithRoom:(NSDictionary *)inRoomDescription handler:(void (^)(CRoom *))inHandler;
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        [inRoomDescription objectForKey:@"roomid"], @"roomid",
        NULL];
    
    [self.socket postMessage:@"room.register" dictionary:theDictionary handler:^(id inResult) {
        self.room = [[[CRoom alloc] initWithParameters:inRoomDescription] autorelease];
    
        [self.socket postMessage:@"room.now" dictionary:NULL handler:^(id inResult) {
            self.roomTime = [[inResult objectForKey:@"now"] doubleValue];
            
            NSDictionary *theSong = [self.room valueForKeyPath:@"parameters.metadata.current_song"];
            [self playSong:theSong preview:NO];
            
            if (inHandler)
                {
                inHandler(self.room);
                }
            }];
        }];
        
    [self fetchPlaylist:NULL];
    }
    
- (void)unregisterWithRoom:(NSDictionary *)inRoomDescription handler:(void (^)(CRoom *))inHandler;
    {
    [self.socket postMessage:@"room.deregister" dictionary:NULL handler:^(id inResult) {
		if (inHandler) {
			inHandler(self.room);
		}
        self.room = NULL;
        }];
    
    }
    
- (NSURL *)URLForSong:(NSDictionary *)inSong preview:(BOOL)inPreview
    {
    NSURL *theURL = NULL;
    NSString *theSongID = [inSong objectForKey:@"_id"];
    if (inPreview == YES)
        {
        NSString *theURLString = [NSString stringWithFormat:@"http://turntable.fm/previewfile/?fileid=%@", theSongID];
        theURL = [NSURL URLWithString:theURLString];
        }
    else
        {
        NSString *theRoomID = self.room.roomID;
        NSString *theRandom = [NSString stringWithFormat:@"%d", arc4random()];
        NSData *theData = [[NSString stringWithFormat:@"%@%@", theRoomID, theSongID] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *theDownloadKey = [[theData SHA1Digest] hexString];
        
    //    http://turntable.fm/getfile/?roomid=4e20dcca14169c25a400baea&rand=0.6888595288619399&fileid=4dd85949e8a6c42aa70005a3&downloadKey=846c95ef6abfa0a162d0f0651277900df2ea5c0c&userid=4df032194fe7d063190425ca&client=web
        
        NSString *theURLString = [NSString stringWithFormat:@"http://turntable.fm/getfile/?roomid=%@&rand=%@&fileid=%@&downloadKey=%@&userid=%@&client=web",
            theRoomID,
            theRandom,
            theSongID,
            theDownloadKey,
            [self.userInfo objectForKey:@"userid"]];
            
        theURL = [NSURL URLWithString:theURLString];
        }
    return(theURL);
    }

- (void)fanUser:(CUser *)inUser handler:(void (^)(void))inHandler
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:inUser.userID forKey:@"djid"];
    [self.socket postMessage:@"user.become_fan" dictionary:theDictionary handler:^(id inResult) {
        if (inHandler)
            {
            inHandler();
            }
        }];
    }

- (void)unfanUser:(CUser *)inUser handler:(void (^)(void))inHandler
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:inUser.userID forKey:@"djid"];
    [self.socket postMessage:@"user.remove_fan" dictionary:theDictionary handler:^(id inResult) {
        if (inHandler)
            {
            inHandler();
            }
        }];
    }
    
- (void)bootUser:(CUser *)inUser handler:(void (^)(void))inHandler
{
    // NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:inUser.userID forKey:@"target_userid"];
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.room.roomID, @"roomid",
                                   inUser.userID, @"target_userid",
                                   NULL];

    [self.socket postMessage:@"room.boot_user" dictionary:theDictionary handler:^(id inResult) {
        if (inHandler)
        {
            inHandler();
        }
    }];
}

// Below really should be removeSong:fromPlaylist: or similar when they do multiple playlists
- (void)removeSongFromPlaylist:(NSInteger)inTeger handler:(void (^)(void))inHandler
{
   // NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:inTeger forKey:@"index"];
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"default", @"playlist_name",
                                   [NSNumber numberWithInteger:inTeger], @"index",
                                   NULL];
    [self.socket postMessage:@"playlist.remove" dictionary:theDictionary handler:^(id inResult) {
        if (inHandler)
        {
            inHandler();
        }
    }];
}

- (void)becomeDJ
{
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:self.room.roomID forKey:@"roomid"];
    [self.socket postMessage:@"room.add_dj" dictionary:theDictionary handler:^(id inResult) {
    }];
}

- (void)playSong:(NSDictionary *)inSong preview:(BOOL)inPreview;
    {

#if TARGET_IPHONE_SIMULATOR == 0
    NSURL *theSongURL = [self URLForSong:inSong preview:inPreview];

    AVPlayerItem *thePlayerItem = [[[AVPlayerItem alloc] initWithURL:theSongURL] autorelease];

    AVPlayer *thePlayer = [[[AVPlayer alloc] initWithPlayerItem:thePlayerItem] autorelease];
    self.player = thePlayer;

    if (inPreview == NO)
        {
        NSTimeInterval theStartTime = [[inSong objectForKey:@"starttime"] doubleValue];
        int64_t theOffsetSeconds = floor((self.roomTime - theStartTime) * 1000.0);
        CMTime theOffset = CMTimeMake(theOffsetSeconds, 1000);
        [self.player seekToTime:theOffset];
        }
        
    self.player.rate = 1.0;
#endif
    }

- (void)stopSong
    {
	self.player.rate = 0.0;
	self.player = nil;
    }

- (void)fetchPlaylist:(void (^)(void))inHandler
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        @"default", @"playlist_name",
        NULL];
    
    [[CTurntableFMModel sharedInstance].socket postMessage:@"playlist.all" dictionary:theDictionary handler:^(id inResult) {

        NSMutableArray *theSongs = [NSMutableArray array];

        for (NSDictionary *theSongDictionary in [inResult objectForKey:@"list"])
            {
            CSong *theSong = [[[CSong alloc] initWithParameters:theSongDictionary] autorelease];
            [theSongs addObject:theSong];
            }
        
        self.songQueue = theSongs;

        if (inHandler)
            {
            inHandler();
            }
        }];
    }


- (BOOL)playing
{
	return (self.player.rate != 0.0);
}

    
@end
