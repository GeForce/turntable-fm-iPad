//
//  CWebSocket.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CWebSocket.h"

#import "CCircularBuffer.h"

typedef enum {
    WebSocketState_Initial,
    WebSocketState_RequestSent,
    WebSocketState_ResponseReceived,
    WebSocketState_Transceiving,
    } EWebSocketState;

static void MyCFReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo);
static void MyCFWriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType type, void *clientCallBackInfo);

@interface CWebSocket ()
@property (readwrite, nonatomic, assign) EWebSocketState state;
@property (readwrite, nonatomic, assign) CFReadStreamRef readStream;
@property (readwrite, nonatomic, assign) CFWriteStreamRef writeStream;
@property (readwrite, nonatomic, retain) CCircularBuffer *readBuffer;

- (void)writePacket:(NSData *)inData;
@end

@implementation CWebSocket

@synthesize state;
@synthesize readStream;
@synthesize writeStream;
@synthesize readBuffer;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        readBuffer = [[CCircularBuffer alloc] init];
		}
	return(self);
	}


- (void)main
    {


// http:///chat2.turntable.fm/socket.io/websocket

    CFStreamCreatePairWithSocketToHost(NULL, CFSTR("chat2.turntable.fm"), 80, &readStream, &writeStream);

    CFStreamClientContext theContext = { .info = self };

    if (CFReadStreamSetClient(self.readStream, -1, MyCFReadStreamClientCallBack, &theContext) == NO)
        {
        NSLog(@"NO");
        }
    if (CFWriteStreamSetClient(self.writeStream, -1, MyCFWriteStreamClientCallBack, &theContext) == NO)
        {
        NSLog(@"NO");
        }

    CFReadStreamScheduleWithRunLoop(self.readStream, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
    CFWriteStreamScheduleWithRunLoop(self.writeStream, CFRunLoopGetMain(), kCFRunLoopDefaultMode);

    CFWriteStreamOpen(writeStream);
    CFReadStreamOpen(readStream);
    }

- (void)readPacket
    {
    if (CFReadStreamHasBytesAvailable(self.readStream))
        {
        NSMutableData *theBuffer = [NSMutableData dataWithLength:64 * 1024];
        CFIndex theCount = CFReadStreamRead(self.readStream, theBuffer.mutableBytes, theBuffer.length);
        NSLog(@"Read: %lu", theCount);
        theBuffer.length = theCount;
        [self.readBuffer writeData:theBuffer];
        }
        
    if (self.readBuffer.lengthAvailableForReading == 0)
        {
        return;
        }

    if (self.state == WebSocketState_RequestSent)
        {
        NSData *theData = [self.readBuffer readDataToSentinal:[@"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        if (theData != NULL)
            {
            NSLog(@"WebSocketState_RequestSent: %d", theData.length);
            self.state = WebSocketState_ResponseReceived;
            }

        [self readPacket];
        }
    else if (self.state == WebSocketState_ResponseReceived)
        {
        NSData *theData = [self.readBuffer readDataOfLength:16];
        if (theData != NULL)
            {
            NSLog(@"WebSocketState_ResponseReceived: %d", theData.length);
            self.state = WebSocketState_Transceiving;
            }

        [self readPacket];
        }
    else if (self.state == WebSocketState_Transceiving)
        {
        UInt8 theFF = 0xFF;
        NSData *theData = [self.readBuffer readDataToSentinal:[NSData dataWithBytesNoCopy:&theFF length:1 freeWhenDone:NO]];
        if (theData.length > 2)
            {
            theData = [theData subdataWithRange:(NSRange){ .location = 1, .length = theData.length - 2 }];
            
            NSString *thePacket = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];
            [self packetReceived:thePacket];
            }
        else
            {
            NSLog(@"HUH? %@", theData);
            }

        [self readPacket];
        }
        
    }

- (void)packetReceived:(id)inPacket
    {
        
    }

- (void)writePacket:(id)inPacket
    {
    UInt8 theZeroByte = 0x00;
    UInt8 theFFByte = 0xFF;

    NSMutableData *theData = [NSMutableData data];
    [theData appendBytes:&theZeroByte length:1];
    if ([inPacket isKindOfClass:[NSString class]] == YES)
        {
        [theData appendData:[inPacket dataUsingEncoding:NSUTF8StringEncoding]];
        }
    else if ([inPacket isKindOfClass:[NSData class]] == YES)
        {
        [theData appendData:inPacket];
        }
    [theData appendBytes:&theFFByte length:1];
    
    CFIndex theCount = CFWriteStreamWrite(writeStream, [theData bytes], [theData length]);
    if (theCount != [theData length])
        {
        NSLog(@"OOPS");
        }
    
    }

@end

//    kCFStreamStatusNotOpen = 0,
//    kCFStreamStatusOpening,  /* open is in-progress */
//    kCFStreamStatusOpen,
//    kCFStreamStatusReading,
//    kCFStreamStatusWriting,
//    kCFStreamStatusAtEnd,    /* no further bytes can be read/written */
//    kCFStreamStatusClosed,
//    kCFStreamStatusError


static void MyCFReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo)
    {
    CWebSocket *self = clientCallBackInfo;
    if (type == kCFStreamStatusOpen)
        {
        [self readPacket];
        }
    }
    
static void MyCFWriteStreamClientCallBack(CFWriteStreamRef stream, CFStreamEventType type, void *clientCallBackInfo)
    {
    CWebSocket *self = clientCallBackInfo;
    NSLog(@"WRITE: %lu", type);
    if (type == kCFStreamStatusWriting)
        {
        if (self.state == WebSocketState_Initial)
            {
            NSArray *theLines = [NSArray arrayWithObjects:
                [NSString stringWithFormat:@"GET /socket.io/websocket HTTP/1.1"],
                [NSString stringWithFormat:@"Upgrade: WebSocket"],
                [NSString stringWithFormat:@"Connection: Upgrade"],
                [NSString stringWithFormat:@"Host: chat2.turntable.fm"],
                [NSString stringWithFormat:@"Cookie: __utma=113390594.280985840.1308591753.1310782420.1310785459.13; __utmb=113390594.4.10.1310785459; __utmc=113390594; __utmz=113390594.1308591753.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)"],
                [NSString stringWithFormat:@"Origin: http://turntable.fm"],
                [NSString stringWithFormat:@"Sec-WebSocket-Key1: 4 @1  46546xW%0l 1 5"],
                [NSString stringWithFormat:@"Sec-WebSocket-Key2: 12998 5 Y3 1  .P00"],
                @"",
                @"^n:ds[4U",
                NULL];
                
            NSString *theHeader = [theLines componentsJoinedByString:@"\r\n"];
            NSData *theHeaderData = [theHeader dataUsingEncoding:NSUTF8StringEncoding];

            CFIndex theCount = CFWriteStreamWrite(self.writeStream, [theHeaderData bytes], [theHeaderData length]);
            NSLog(@"Wrote: %lu", theCount);
            
            self.state = WebSocketState_RequestSent;
            }
        }
    }
    
