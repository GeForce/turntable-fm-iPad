//
//  CWebSocket.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWebSocket : NSObject

- (void)main;

- (void)packetReceived:(id)inPacket;

@end
