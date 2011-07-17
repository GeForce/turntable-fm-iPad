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

@interface CRoom ()
@property (readwrite, nonatomic, retain) NSMutableDictionary *usersByUserID;
@property (readwrite, nonatomic, retain) NSMutableArray *users;
@end

#pragma mark -

@implementation CRoom

@synthesize usersByUserID;
@synthesize users;
@synthesize DJs;
@synthesize chatLog;

- (void)didInitialize
    {
    }

#pragma mark -

- (NSString *)roomID
    {
    return([self.parameters objectForKey:@"roomid"]);
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
            [self.DJs addObject:[self.usersByUserID objectForKey:theDJUserID]];
            }
        
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

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];

                CUser *theUser = [self.usersByUserID objectForKey:theUserID];

                NSInteger theIndex = [self.users indexOfObject:theUser];
                NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:theIndex];
                [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:theIndexes forKey:@"users"];
                [self.users removeObjectAtIndex:theIndex];
                [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:theIndexes forKey:@"users"];

                if (theUser)
                    {
                    [self.usersByUserID removeObjectForKey:theUserID];
                    }
                }
            } forCommand:@"deregistered"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                [self.DJs addObject:[self.usersByUserID objectForKey:theUserID]];
                
                
                }
            } forCommand:@"add_dj"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                
                [self.DJs removeObjectAtIndex:[self.DJs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    return([[obj userID] isEqualToString:theUserID]);
                    }]];
                }
            } forCommand:@"rem_dj"];

//        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
//            // We're ignoring this...
//            } forCommand:@"update_user"];
//
//        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
//            NSLog(@"%@", inParam);
//            } forCommand:@"update_votes"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {

            NSIndexSet *theIndexes = [NSIndexSet indexSetWithIndex:self.chatLog.count];
            [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"chatLog"];
            [self.chatLog addObject:inParam];
            [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:theIndexes forKey:@"chatLog"];

            NSLog(@"CHAT COUNT: %d", self.chatLog.count);
            } forCommand:@"speak"];
        
        }];
    }

- (void)unsubscribe
    {
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"registered"];
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"deregistered"];
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"add_dj"];
    [[CTurntableFMModel sharedInstance].socket removeHandlerForCommand:@"rem_dj"];
    }


@end
