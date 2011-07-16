//
//  CCircularBuffer.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCircularBuffer : NSObject

- (size_t)lengthAvailableForReading;

- (NSData *)readDataOfLength:(size_t)inLength;
- (NSData *)readDataToSentinal:(NSData *)inSentinel;
- (void)writeData:(NSData *)inData;

@end
