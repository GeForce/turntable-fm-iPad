//
//  CAvatarLayer.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAvatarLayer : CALayer

@property (readwrite, nonatomic, retain) CALayer *headLayer;
@property (readwrite, nonatomic, retain) CALayer *bodyLayer;
@property (readwrite, nonatomic, assign) BOOL DJing;
@property (readwrite, nonatomic, assign) BOOL bobbing;

@end
