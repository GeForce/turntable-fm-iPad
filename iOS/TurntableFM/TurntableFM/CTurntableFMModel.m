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

    self.turntableFMSocket = [[[CTurntableFMSocket alloc] init] autorelease];
    
    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://turntable.fm/?fbtoken=%@", inFacebookAccessToken]];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL];
    CURLOperation *theOperation = [[[CURLOperation alloc] initWithRequest:theRequest] autorelease];
    theOperation.completionBlock = ^(void) {
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
            [self.turntableFMSocket listRooms:^(NSArray *inRooms) {
                self.rooms = inRooms;
                }];
            };
        
        [self.turntableFMSocket main];
        
        };

    [self.queue addOperation:theOperation];
    }


@end
