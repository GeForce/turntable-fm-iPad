//
//  CRoom.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CRoom.h"

#import "CTurntableFMModel.h"
#import "CTurntableFMSocket.h"
#import "CUser.h"
#import "CSong.h"

@interface CRoom ()
@property (readwrite, nonatomic, retain) NSMutableDictionary *usersByUserID;
@property (readwrite, nonatomic, retain) NSMutableArray *users;

- (void)handleVoteLog:(NSArray *)inVoteLog;
@end

#pragma mark -

@implementation CRoom

@synthesize usersByUserID;
@synthesize users;
@synthesize DJs;
@synthesize chatLog;
@synthesize currentSong;

- (void)didInitialize
    {
    }

#pragma mark -

- (NSString *)roomID
    {
    return([self.parameters objectForKey:@"roomid"]);
    }

- (NSString *)name
    {
    return([self.parameters objectForKey:@"name"]);
    }

#pragma mark -

- (void)subscribe
    {
    self.usersByUserID = [NSMutableDictionary dictionary];
    self.users = [NSMutableArray array];
    self.DJs = [NSMutableArray array];
    self.chatLog = [NSMutableArray array];
    
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:self.roomID forKey:@"roomid"];
    [[CTurntableFMModel sharedInstance].socket postMessage:@"room.info" dictionary:theDictionary handler:^(id inResult) {
    
        self.parameters = [inResult objectForKey:@"room"];

        NSDictionary *theSongParameters = [self.parameters valueForKeyPath:@"metadata.current_song"];
        if (theSongParameters)
            {
            self.currentSong = [[[CSong alloc] initWithParameters:theSongParameters] autorelease];
            }
    
        for (id theUserParameters in [inResult objectForKey:@"users"])
            {
            CUser *theUser = [[[CUser alloc] initWithParameters:theUserParameters] autorelease];
            [self.usersByUserID setObject:theUser forKey:theUser.userID];
        
            NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:self.users.count];
            [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"users"];
            [self.users addObject:theUser];
            [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"users"];
            }
            
        for (NSString *theDJUserID in [inResult valueForKeyPath:@"room.metadata.djs"])
            {
            NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:self.DJs.count];
            [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"DJs"];
            [self.DJs addObject:[self.usersByUserID objectForKey:theDJUserID]];
            [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"DJs"];
            }

        NSArray *theVotelog = [inResult valueForKeyPath:@"room.metadata.votelog"];
        [self handleVoteLog:theVotelog];

        // USER REGISTER ######################################################
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                CUser *theUser = [[[CUser alloc] initWithParameters:theUserParameters] autorelease];
                [self.usersByUserID setObject:theUser forKey:theUser.userID];
                
                NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:self.users.count];
                [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"users"];
                [self.users addObject:theUser];
                [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"users"];
                
                }


        } forCommand:@"registered"];

        // USER DEREGISTER ####################################################
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                CUser *theUser = [self.usersByUserID objectForKey:theUserID];

                NSInteger theIndex = [self.users indexOfObject:theUser];
                    /* 2011-07-20 18:41:08.291 TurntableFM[49326:207] *** Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[NSIndexSet initWithIndexesInRange:]: Range {2147483647, 1} exceeds maximum index value of NSNotFound - 1'
                        ...occurs when ttfm sends to dereg statements for the same user.  I have not seen a double-dereg event since I put the following if() in, unfortunately.
                    */
                    if (theIndex != NSNotFound) 
                        {
                        NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:theIndex];

                        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:theIndexes forKey:@"users"];
                        [self.users removeObjectAtIndex:theIndex];
                        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:theIndexes forKey:@"users"];

                        if (theUser)
                            {
                            [self.usersByUserID removeObjectForKey:theUserID];
                            }
                        } else { 
                            NSLog(@"Caught deregister event for non-existent user %@", theUserID); 
                            }
                }
            } forCommand:@"deregistered"];

        // ADD DJ ##############################################################
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:self.DJs.count];
                CUser *theUser = [self.usersByUserID objectForKey:theUserID];
                [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"DJs"];
                [self.DJs addObject:theUser];
                [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"DJs"];
                }
            } forCommand:@"add_dj"];

        // REM DJ ##############################################################
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                CUser *theUser = [self.usersByUserID objectForKey:theUserID];
                
                NSInteger theIndex = [self.DJs indexOfObject:theUser];
                if (theIndex != NSNotFound)
                    {
                    NSIndexSet *theIndexes = 
                    [NSIndexSet indexSetWithIndex:theIndex];
                    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:theIndexes forKey:@"DJs"];
                    [self.DJs removeObjectAtIndex:theIndex];
                    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:theIndexes forKey:@"DJs"];
                    }
                    }
            } forCommand:@"rem_dj"];

        // NEW SONG ############################################################
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            self.parameters = [inParam objectForKey:@"room"];
            NSDictionary *theSongParameters = [self.parameters valueForKeyPath:@"metadata.current_song"];
            if (theSongParameters)
                {
                self.currentSong = [[[CSong alloc] initWithParameters:theSongParameters] autorelease];
                
                [[CTurntableFMModel sharedInstance] playSong:self.currentSong.parameters preview:NO];
                
                for (CUser *theUser in self.users)
                    {
                    theUser.bobbing = NO;
                    }
                }
            } forCommand:@"newsong"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            // We're ignoring this... mostly.
            NSDictionary *updateParameters = inParam;
            NSString *userID = [updateParameters valueForKey:@"userid"];
            NSNumber *fanAdjustment = [updateParameters valueForKey:@"fans"];
            NSNumber *newAvatarID = [updateParameters valueForKey:@"avatarid"];
            if (fanAdjustment != nil) {
                NSLog(@"Found fan update: %@ %@ fans", userID, fanAdjustment);
                // TODO: Once we actually display fan totals somewhere, update that total here
            }
            if (newAvatarID != nil) {
                NSLog(@"Found avatar update: %@ -> avatar ID %@", userID, newAvatarID); 
            }
            // NSLog(@"%@", [updateParameters description]);
            } forCommand:@"update_user"];

        // #####################################################################
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
        
            NSArray *theVotelog = [inParam valueForKeyPath:@"room.metadata.votelog"];
            [self handleVoteLog:theVotelog];


//2011-07-17 15:05:46.961 TurntableFM[59881:cb03] {
//    command = "update_votes";
//    room =     {
//        metadata =         {
//            downvotes = 3;
//            listeners = 130;
//            upvotes = 2;
//            votelog =             (
//                                (
//                    4e145bd1a3f75114d80a75c9,
//                    down
//                )
//            );
//        };
//    };
//    success = 1;
//}



            } forCommand:@"update_votes"];

        // #####################################################################
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:self.chatLog.count];
            NSMutableDictionary *chatParameters = [NSMutableDictionary dictionaryWithDictionary:inParam];
            [chatParameters setObject:@"chat" forKey:@"type"]; // Really not sure this is the right/best way. 
            [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"chatLog"];
            [self.chatLog addObject:chatParameters];
            [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"chatLog"];
            NSLog(@"Chat parameters: %@", chatParameters);
            } forCommand:@"speak"];
        
        // #####################################################################
        // 20:11:40 Received: {"command": "booted_user", "reason": null, "userid": "4e0ce2704fe7d076b216d117", "success": true}
        // TODO: The more I think about this, the more I think that handling this through chat - while obvious at first, due to the main purpose being to log it in chat, but there's much more to do - going to refactor this once it's working.  
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            // Boot messages come in as 'success'ful even when that user isn't in the room anymore.
            CUser *theUser = [self.usersByUserID objectForKey:[inParam objectForKey:@"userid"]];
            if (theUser == NULL) { NSLog(@"Boot message received for user not in room"); return; };
            NSLog(@"Booted user: %@", theUser);
            NSMutableDictionary *bootParameters = [NSMutableDictionary dictionaryWithDictionary:inParam];
            [bootParameters setObject:@"boot" forKey:@"type"]; // Still not sure this is the right/best way.
            [bootParameters setObject:[theUser name] forKey:@"name"];
            NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:self.chatLog.count];
            [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"chatLog"];
            [self.chatLog addObject:bootParameters];
            [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"chatLog"];
            NSLog(@"Boot parameters: %@", bootParameters);
        } forCommand:@"booted_user"];

        }];
    }

- (void)unsubscribe
    {
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"registered"];
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"deregistered"];
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"add_dj"];
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"rem_dj"];
    }

- (void)handleVoteLog:(NSArray *)inVoteLog
    {
    for (NSArray *theVote in inVoteLog)
        {
        NSString *theUserID = [theVote objectAtIndex:0];
        NSString *theVoteChoice = [theVote objectAtIndex:1];
        
        CUser *theUser = [self.usersByUserID objectForKey:theUserID];
        if ([theVoteChoice isEqualToString:@"down"])
            theUser.bobbing = NO;
        else
            theUser.bobbing = YES;
        }
    }

@end
