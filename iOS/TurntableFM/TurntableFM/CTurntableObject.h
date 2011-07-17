//
//  CTurntableObject.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTurntableObject : NSObject

@property (readonly, nonatomic, retain) NSDictionary *parameters;

- (id)initWithParameters:(NSDictionary *)inParameters;

- (void)didInitialize;

@end
