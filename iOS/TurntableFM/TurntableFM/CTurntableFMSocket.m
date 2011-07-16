//
//  CTurntableFMSocket.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CTurntableFMSocket.h"

#import "CJSONDeserializer.h"

@interface CTurntableFMSocket ()
@property (readwrite, nonatomic, assign) NSInteger nextMessageID;
@property (readwrite, nonatomic, retain) NSMutableDictionary *blocksForMessageID;
@end

@implementation CTurntableFMSocket

@synthesize clientID;
@synthesize userID;
@synthesize userAuth;

@synthesize nextMessageID;
@synthesize blocksForMessageID;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        clientID = @"1310833072120-0.4627539317589253";
        userID = @"4df032194fe7d063190425ca";
        userAuth = @"auth+live+ca822c8cb67e74722e3c350cfc0cbfea8a27c43b";
        
        blocksForMessageID = [[NSMutableDictionary alloc] init];
		}
	return(self);
	}

- (void)messageReceived:(id)inMessage;
    {
    if ([inMessage isKindOfClass:[NSString class]])
        {
        inMessage = [inMessage dataUsingEncoding:NSUTF8StringEncoding];
        }
    NSError *theError = NULL;
    NSDictionary *theDictionary = [[CJSONDeserializer deserializer] deserialize:inMessage error:&theError];
    
    NSNumber *theMessageID = [theDictionary objectForKey:@"msgid"];
    void (^theBlock)(NSArray *inRooms) = [self.blocksForMessageID objectForKey:theMessageID];
    if (theBlock)
        {
        NSArray *theRooms = [theDictionary objectForKey:@"rooms"];
        theBlock([theRooms objectAtIndex:0]);

        [self.blocksForMessageID removeObjectForKey:theMessageID];
        }
    
    }

- (void)listRooms:(void (^)(NSArray *inRooms))inHandler;
    {
    id theMessageID = [NSNumber numberWithInt:self.nextMessageID++];
    
    [self.blocksForMessageID setObject:[[inHandler copy] autorelease] forKey:theMessageID];
    
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
        @"room.list_rooms", @"api",
        theMessageID, @"msgid",
        self.clientID, @"clientid",
        self.userID, @"userid",
        self.userAuth, @"userauth",
        NULL];
    
    [self writeDictionary:theDictionary];
    }

@end
