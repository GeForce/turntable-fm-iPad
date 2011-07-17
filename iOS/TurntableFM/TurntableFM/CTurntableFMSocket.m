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
@property (readwrite, nonatomic, retain) NSMutableDictionary *handlerForCommands;
@end

@implementation CTurntableFMSocket

@synthesize clientID;
@synthesize userID;
@synthesize userAuth;

@synthesize nextMessageID;
@synthesize blocksForMessageID;
@synthesize handlerForCommands;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        NSString *theClientID = [[NSUserDefaults standardUserDefaults] objectForKey:@"TurntableFMClientID"];
        if (theClientID == NULL)
            {
            theClientID = [NSString stringWithFormat:@"%d", arc4random()];
            [[NSUserDefaults standardUserDefaults] setObject:theClientID forKey:@"TurntableFMClientID"];
            }
        clientID = [theClientID retain];
        
        blocksForMessageID = [[NSMutableDictionary alloc] init];
        handlerForCommands = [[NSMutableDictionary alloc] init];
		}
	return(self);
	}
    
- (void)dealloc
    {
    [super dealloc];
    }

- (void)addHandler:(void (^)(id))inHandler forCommand:(NSString *)inCommand
    {
    [self.handlerForCommands setObject:[[inHandler copy] autorelease] forKey:inCommand];    
    }
    
- (void)removeHandlerForCommand:(NSString *)inCommand
    {
    [self.handlerForCommands removeObjectForKey:inCommand];    
    }

- (void)messageReceived:(id)inMessage;
    {
    if ([inMessage isKindOfClass:[NSString class]])
        {
        inMessage = [inMessage dataUsingEncoding:NSUTF8StringEncoding];
        }
    NSError *theError = NULL;
    
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;
    NSDictionary *theDictionary = [theDeserializer deserialize:inMessage error:&theError];
    
    NSNumber *theSuccess = [theDictionary objectForKey:@"success"];
    if (theSuccess != NULL && [theSuccess intValue] != 1)
        {
        NSLog(@"FAILURE!! %@", theDictionary);
        return;
        }
    
    NSNumber *theMessageID = [theDictionary objectForKey:@"msgid"];
    void (^theBlock)(id) = [self.blocksForMessageID objectForKey:theMessageID];
    if (theBlock)
        {
        theBlock(theDictionary);

        [self.blocksForMessageID removeObjectForKey:theMessageID];
        return;
        }
    else 
        {
        NSString *theCommand = [theDictionary objectForKey:@"command"];
        if (theCommand)
            {
            void (^theHandler)(id) = [self.handlerForCommands objectForKey:theCommand];
            if (theHandler)
                {
                theHandler(theDictionary);
                return;
                }
            else
                {
                NSLog(@"No handler for: %@", theCommand);
                return;
                }
            }
        }
        
    NSLog(@"Don't know how to deal with: %@", theDictionary);
    }

- (void)postMessage:(NSString *)inAPI dictionary:(NSDictionary *)inDictionary handler:(void (^)(id inResult))inHandler;
    {
    id theMessageID = [NSNumber numberWithInt:self.nextMessageID++];
    
    NSMutableDictionary *theDictionary = [NSMutableDictionary dictionary];
    
    if (inDictionary)
        {
        [theDictionary addEntriesFromDictionary:inDictionary];
        }
        
    NSAssert(self.clientID.length > 0, @"Bad client id");
    NSAssert(self.userID.length > 0, @"Bad user id");
    NSAssert(self.userAuth.length > 0, @"Bad user auth");
    
    [theDictionary setObject:inAPI forKey:@"api"];
    [theDictionary setObject:self.clientID forKey:@"clientid"];
    [theDictionary setObject:self.userID forKey:@"userid"];
    [theDictionary setObject:self.userAuth forKey:@"userauth"];
    [theDictionary setObject:theMessageID forKey:@"msgid"];
        
    [self.blocksForMessageID setObject:[[inHandler copy] autorelease] forKey:theMessageID];
    
    [self writeDictionary:theDictionary];
    }

@end
