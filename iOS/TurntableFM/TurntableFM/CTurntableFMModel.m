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

@interface CTurntableFMModel () <AVAudioPlayerDelegate>
@property (readwrite, nonatomic, retain) NSDictionary *userInfo;
@property (readwrite, nonatomic, retain) NSArray *rooms;
@property (readwrite, nonatomic, retain) NSDictionary *room;

@property (readwrite, nonatomic, retain) CTurntableFMSocket *turntableFMSocket;
@property (readwrite, nonatomic, retain) NSOperationQueue *queue;
@property (readwrite, nonatomic, assign) NSTimeInterval roomTime;
@property (readwrite, nonatomic, retain) AVPlayer *player;

@end

#pragma mark -

@implementation CTurntableFMModel

@synthesize userInfo;
@synthesize rooms;
@synthesize room;

@synthesize turntableFMSocket;
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


- (void)loginWithFacebookAccessToken:(NSString *)inFacebookAccessToken;
    {
    self.queue = [[[NSOperationQueue alloc] init] autorelease];

    
    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://turntable.fm/?fbtoken=%@", inFacebookAccessToken]];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    CURLOperation *theOperation = [[[CURLOperation alloc] initWithRequest:theRequest] autorelease];
    theOperation.completionBlock = ^(void) {
        self.turntableFMSocket = [[[CTurntableFMSocket alloc] init] autorelease];
        for (NSHTTPCookie *theCookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:theURL])
            {
            if ([theCookie.name isEqualToString:@"turntableUserAuth"])
                {
                self.turntableFMSocket.userAuth = theCookie.value;
                }
            else if ([theCookie.name isEqualToString:@"turntableUserId"])
                {
                self.turntableFMSocket.userID = theCookie.value;
                }
            }
         
        self.turntableFMSocket.didConnectHandler = ^(void) {
            [self.turntableFMSocket postMessage:@"user.authenticate" dictionary:NULL handler:^(id inResult) {
                NSLog(@"AUTHENTICATED? %@", inResult);
                
                [self.turntableFMSocket postMessage:@"user.info" dictionary:NULL handler:^(id inResult) {
                    NSLog(@"USER INFO: %@", inResult);
                    self.userInfo = inResult;
                    }];
                
                
                [self.turntableFMSocket postMessage:@"room.list_rooms" dictionary:NULL handler:^(id inResult) {
                    self.rooms = [inResult objectForKey:@"rooms"];
                    }];
                }];
            };
        
        [self.turntableFMSocket main];
        
        };

    [self.queue addOperation:theOperation];
    }

- (void)registerWithRoom:(NSDictionary *)inRoomDescription handler:(void (^)(void))inHandler
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        [inRoomDescription objectForKey:@"roomid"], @"roomid",
        NULL];
    
    [self.turntableFMSocket postMessage:@"room.register" dictionary:theDictionary handler:^(id inResult) {
        self.room = inRoomDescription;
    
        [self.turntableFMSocket postMessage:@"room.now" dictionary:NULL handler:^(id inResult) {
            NSLog(@"ROOM.NOW: %@", inResult);
            
            self.roomTime = [[inResult objectForKey:@"now"] doubleValue];
            
            
            NSDictionary *theSong = [self.room valueForKeyPath:@"metadata.current_song"];
            NSLog(@"%@", theSong);
            
            [self playSong:theSong preview:NO];

            
            if (inHandler)
                {
                inHandler();
                }
            }];
        }];
    }
    
- (void)unregisterWithRoom:(NSDictionary *)inRoomDescription handler:(void (^)(void))inHandler;
    {
    [self.turntableFMSocket postMessage:@"room.unregister" dictionary:NULL handler:^(id inResult) {
        NSLog(@"UNREGISTER");
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
        NSString *theRoomID = [self.room objectForKey:@"roomid"];
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
    
- (void)playSong:(NSDictionary *)inSong preview:(BOOL)inPreview;
    {
    NSTimeInterval theStartTime = [[inSong objectForKey:@"starttime"] doubleValue];
    int64_t theOffsetSeconds = floor((self.roomTime - theStartTime) * 1000.0);
    NSLog(@"OFFSET %lld", theOffsetSeconds / 1000);

#if TARGET_IPHONE_SIMULATOR == 0


    CMTime theOffset = CMTimeMake(theOffsetSeconds, 1000);


    NSURL *theSongURL = [self URLForSong:inSong preview:inPreview];

    AVPlayerItem *thePlayerItem = [[[AVPlayerItem alloc] initWithURL:theSongURL] autorelease];

    AVPlayer *thePlayer = [[[AVPlayer alloc] initWithPlayerItem:thePlayerItem] autorelease];
    self.player = thePlayer;

    [self.player seekToTime:theOffset];

    self.player.rate = 1.0;
#endif


    }
    
#pragma mark -

    
@end
