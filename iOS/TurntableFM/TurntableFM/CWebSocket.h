//
//  CWebSocket.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWebSocket : NSObject

@property (readwrite, nonatomic, copy) void (^didConnectHandler)(void);
@property (readwrite, nonatomic, copy) void (^packetHandler)(id inPacket);

- (void)main;

- (void)didConnect;
- (void)packetReceived:(id)inPacket;

- (void)writePacket:(id)inPacket;

@end
