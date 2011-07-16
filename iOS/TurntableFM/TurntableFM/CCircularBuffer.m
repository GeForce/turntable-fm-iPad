//
//  CCircularBuffer.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CCircularBuffer.h"

// NOTE: this is NOT a circular buffer. It just acts like one to consuming code.

@interface CCircularBuffer ()
@property (readwrite, nonatomic, retain) NSMutableData *data;
@end

#pragma mark -

@implementation CCircularBuffer

@synthesize data;

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        data = [[NSMutableData alloc] initWithLength:0];
		}
	return(self);
	}
    
- (size_t)lengthAvailableForReading;
    {
    return(self.data.length);
    }

- (NSData *)readDataOfLength:(size_t)inLength;
    {
    NSData *theData = NULL;
    if (self.data.length >= inLength)
        {
        theData = [data subdataWithRange:(NSRange){ .location = 0, .length = inLength }];
        
        self.data = [[[data subdataWithRange:(NSRange){ .location = inLength, data.length - inLength }] mutableCopy] autorelease];
        }
    return(theData);
    }


- (NSData *)readDataToSentinal:(NSData *)inSentinel
    {
    NSData *theData = NULL;
    NSRange theRange = [data rangeOfData:inSentinel options:0 range:(NSRange){ .location = 0, .length = data.length }];
    if (theRange.location != NSNotFound)
        {
        theData = [data subdataWithRange:(NSRange){ .location = 0, .length = theRange.location + theRange.length }];
        
        self.data = [[[data subdataWithRange:(NSRange){ .location = theRange.location + theRange.length, data.length - (theRange.location + theRange.length) }] mutableCopy] autorelease];
        }
    return(theData);
    }

- (void)writeData:(NSData *)inData
    {
    [data appendData:inData];
    }


@end
