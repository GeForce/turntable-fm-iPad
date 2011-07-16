//
//  CSocketIO.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CWebSocket.h"

@interface CSocketIO : CWebSocket

- (void)writeMessage:(id)inPacket;
- (void)writeDictionary:(NSDictionary *)inDictionary;

- (void)messageReceived:(id)inMessage;


@end
