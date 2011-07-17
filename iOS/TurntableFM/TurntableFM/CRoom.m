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
@end

#pragma mark -

@implementation CRoom

@synthesize usersByUserID;
@synthesize DJs;
@synthesize chatLog;

- (void)didInitialize
    {
    self.usersByUserID = [NSMutableDictionary dictionary];
    self.DJs = [NSMutableArray array];
    self.chatLog = [NSMutableArray array];
    
    NSDictionary *theDictionary = [NSDictionary dictionaryWithObject:self.roomID forKey:@"roomid"];
    [[CTurntableFMModel sharedInstance].socket postMessage:@"room.info" dictionary:theDictionary handler:^(id inResult) {
        for (id theUserParameters in [inResult objectForKey:@"users"])
            {
            CUser *theUser = [[[CUser alloc] initWithParameters:theUserParameters] autorelease];
            [self.usersByUserID setObject:theUser forKey:theUser.userID];
            }
            
        for (NSString *theDJUserID in [inResult valueForKeyPath:@"room.metadata.djs"])
            {
            [self.DJs addObject:[self.usersByUserID objectForKey:theDJUserID]];
            }
        
        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSLog(@"USER ADDED");
                CUser *theUser = [[[CUser alloc] initWithParameters:theUserParameters] autorelease];
                [self.usersByUserID setObject:theUser forKey:theUser.userID];
                }
            } forCommand:@"registered"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                if ([self.usersByUserID objectForKey:theUserID])
                    {
                    NSLog(@"USER REMOVED");
                    [self.usersByUserID removeObjectForKey:theUserID];
                    }
                }
            } forCommand:@"deregistered"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            NSLog(@"ADD_DJ");
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                [self.DJs addObject:[self.usersByUserID objectForKey:theUserID]];
                }
            NSLog(@"DJs: %@", [self.DJs valueForKey:@"name"]);
            } forCommand:@"add_dj"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            NSLog(@"REM_DJ");
            for (NSDictionary *theUserParameters in [inParam objectForKey:@"user"])
                {
                NSString *theUserID = [theUserParameters objectForKey:@"userid"];
                
                [self.DJs removeObjectAtIndex:[self.DJs indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    return([[obj userID] isEqualToString:theUserID]);
                    }]];
                NSLog(@"%@", self.DJs);
                NSLog(@"DJs: %@", [self.DJs valueForKey:@"name"]);
                }
            } forCommand:@"rem_dj"];

        [[CTurntableFMModel sharedInstance].socket addHandler:^(id inParam) {
            [self.chatLog addObject:inParam];
            } forCommand:@"speak"];
        
        }];
    }

- (NSString *)roomID
    {
    return([self.parameters objectForKey:@"roomid"]);
    }

@end
