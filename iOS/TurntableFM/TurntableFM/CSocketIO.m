//
//  CSocketIO.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CSocketIO.h"

#import "CJSONSerializer.h"

@implementation CSocketIO

- (void)packetReceived:(id)inPacket
    {
    NSScanner *theScanner = [[[NSScanner alloc] initWithString:inPacket] autorelease];
    if ([theScanner scanString:@"~m~" intoString:NULL] == NO)
        {
        NSLog(@"OOPS");
        return;
        }

    NSString *theString = NULL;
    if ([theScanner scanCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:&theString] == NO)
        {
        NSLog(@"OOPS");
        return;
        }

    if ([theScanner scanString:@"~m~" intoString:NULL] == NO)
        {
        NSLog(@"OOPS");
        return;
        }
    
    NSInteger theLength = [theString integerValue];
                
    NSString *thePacket = [inPacket substringFromIndex:theScanner.scanLocation];
    
    if (theLength != thePacket.length)
        {
        NSLog(@"Socket.io doesn't match packet length");
        }
    
    if ([[thePacket substringToIndex:3] isEqualToString:@"~h~"])
        {
        [self writeMessage:[thePacket dataUsingEncoding:NSUTF8StringEncoding]];
        return;
        }
    
    if (self.packetHandler)
        {
        self.packetHandler(thePacket);
        }

    [self messageReceived:thePacket];
    }

- (void)writeMessage:(id)inPacket
    {
    NSMutableData *theData = [NSMutableData data];
    [theData appendData:[[NSString stringWithFormat:@"~m~%d~m~", [inPacket length]] dataUsingEncoding:NSUTF8StringEncoding]];
    [theData appendData:inPacket];
    [super writePacket:theData];
    }

- (void)writeDictionary:(NSDictionary *)inDictionary;
    {
    NSData *theData = [[CJSONSerializer serializer] serializeDictionary:inDictionary error:NULL];
    [self writeMessage:theData];
    }

- (void)messageReceived:(id)inMessage;
    {
    }

@end
