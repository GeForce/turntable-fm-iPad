//
//  CTurntableFMModel.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableFMModel.h"

#import "CTurntableFMSocket.h"
#import "CURLOperation.h"

@interface CTurntableFMModel ()
@property (readwrite, nonatomic, retain) CTurntableFMSocket *turntableFMSocket;
@property (readwrite, nonatomic, retain) NSOperationQueue *queue;
@property (readwrite, nonatomic, retain) NSArray *rooms;
@end

#pragma mark -

@implementation CTurntableFMModel

@synthesize turntableFMSocket;
@synthesize queue;
@synthesize rooms;

static CTurntableFMModel *gSharedInstance = NULL;

+ (CTurntableFMModel *)sharedInstance
    {
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        gSharedInstance = [[CTurntableFMModel alloc] init];
        });
    return(gSharedInstance);
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
                NSLog(@"USER AUTH: %@", self.turntableFMSocket.userAuth);
                }
            else if ([theCookie.name isEqualToString:@"turntableUserId"])
                {
                self.turntableFMSocket.userID = theCookie.value;
                NSLog(@"USER ID: %@", self.turntableFMSocket.userID);
                }
            }
         
        self.turntableFMSocket.didConnectHandler = ^(void) {
            [self.turntableFMSocket postMessage:@"room.list_rooms" dictionary:NULL handler:^(id inResult) {
                self.rooms = [inResult objectForKey:@"rooms"];
                }];
            };
        
        [self.turntableFMSocket main];
        
        };

    [self.queue addOperation:theOperation];
    }

- (void)registerWithRoom:(NSString *)inRoomID
    {
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        inRoomID, @"roomid",
        NULL];
    
    [self.turntableFMSocket postMessage:@"room.register" dictionary:theDictionary handler:^(id inResult) {
        NSLog(@">>> %@", inResult);
        }];
    
//
//12:19
//paul.blair@me.com
//12:19
//12:18:13 Preparing message {"api":"room.register","roomid":"4e01710f14169c1c4400241f","msgid":14,"clientid":"1310841990581-0.6640265875030309","userid":"4df032194fe7d063190425ca","userauth":"auth+live+ca822c8cb67e74722e3c350cfc0cbfea8a27c43b"}
//response
//12:18:14 Received: {"command": "registered", "user": [{"name": "@Masque", "created": 1307587096.74, "laptop": "mac", "userid": "4df032194fe7d063190425ca", "acl": 1, "fans": 540, "points": 9808, "avatarid": 26}], "success": true}    
    
    
    }

@end
