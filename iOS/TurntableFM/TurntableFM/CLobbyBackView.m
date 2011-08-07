//
//  CLobbyBackView.m
//  TurntableFM
//
//  Created by August Joki on 8/6/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLobbyBackView.h"

#import <QuartzCore/QuartzCore.h>

const NSTimeInterval CLobbyBackViewDuration = 0.5;

@implementation CLobbyBackView

@synthesize flipView;
@synthesize bigArtwork;
@synthesize backside;
@synthesize smallArtwork;
@synthesize roomName;
@synthesize currentSong;

@synthesize room;
@synthesize fromView;

- (void)dealloc
{
	[flipView release];
    [bigArtwork release];
    [backside release];
    [smallArtwork release];
    [roomName release];
    [currentSong release];
	
	[room release];
	[fromView release];
	
    [super dealloc];
}

- (void)awakeFromNib
{
	UITapGestureRecognizer *recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
	[self addGestureRecognizer:recog];
	[recog release];
	
	CGPathRef path = CGPathCreateWithRect(self.flipView.bounds, NULL);
	self.flipView.layer.shadowPath = path;
	CGPathRelease(path);
	self.flipView.layer.shadowOpacity = 0.5;
	self.flipView.layer.shadowOffset = CGSizeMake(0, 3);
}

- (void)show
{
	self.bigArtwork.image = [(UIImageView *)self.fromView image];
	self.backside.frame = self.bigArtwork.frame;
	[self.flipView insertSubview:self.backside belowSubview:self.bigArtwork];
	self.fromView.hidden = YES;
	
	CGRect start = [self convertRect:self.fromView.frame fromView:self.fromView.superview];
	CGPoint center = [self convertPoint:self.fromView.center fromView:self.fromView.superview];
	CATransform3D transform = CATransform3DMakeTranslation(center.x - self.flipView.center.x, center.y - self.flipView.center.y, 0.0);
	transform = CATransform3DScale(transform, start.size.width / self.flipView.bounds.size.width, start.size.height / self.flipView.bounds.size.height, 1.0);
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	self.flipView.layer.transform = transform;
	self.flipView.layer.shadowRadius = 3.0;
	self.backside.layer.transform = CATransform3DMakeRotation(-M_PI, 0, 1, 0);
	self.backside.layer.zPosition = -1;
	self.bigArtwork.layer.zPosition = 1;
	[CATransaction commit];
	
	[CATransaction begin];
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.fromValue = [NSValue valueWithCATransform3D:transform];
	transform = CATransform3DMakeRotation(-M_PI, 0, 1, 0);
	animation.toValue = [NSValue valueWithCATransform3D:transform];
	animation.duration = CLobbyBackViewDuration;
	[self.flipView.layer addAnimation:animation forKey:@"flip"];
	self.flipView.layer.transform = transform;
	
	animation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
	animation.fromValue = [NSNumber numberWithInt:1];
	animation.toValue = [NSNumber numberWithInt:-1];
	animation.duration = CLobbyBackViewDuration;
	[self.bigArtwork.layer addAnimation:animation forKey:@"z"];
	self.bigArtwork.layer.zPosition = -1;
	
	animation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
	animation.fromValue = [NSNumber numberWithInt:-1];
	animation.toValue = [NSNumber numberWithInt:1];
	animation.duration = CLobbyBackViewDuration;
	[self.backside.layer addAnimation:animation forKey:@"z"];
	self.backside.layer.zPosition = 1;
	
	animation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
	animation.fromValue = [NSNumber numberWithFloat:3.0];
	animation.toValue = [NSNumber numberWithFloat:10.0];
	[self.flipView.layer addAnimation:animation forKey:@"darken"];
	self.flipView.layer.shadowRadius = 10.0;
	[CATransaction commit];
}

#pragma mark - IBActions

- (IBAction)viewTapped:(id)sender
{
	CGRect start = [self convertRect:self.fromView.frame fromView:self.fromView.superview];
	CGPoint center = [self convertPoint:self.fromView.center fromView:self.fromView.superview];
	CATransform3D transform = CATransform3DMakeTranslation(center.x - self.flipView.center.x, center.y - self.flipView.center.y, 0.0);
	transform = CATransform3DScale(transform, start.size.width / self.flipView.bounds.size.width, start.size.height / self.flipView.bounds.size.height, 1.0);
	
	[CATransaction begin];
	[CATransaction setCompletionBlock:^(void) {
		self.fromView.hidden = NO;
		[self removeFromSuperview];
		self.flipView.transform = CGAffineTransformIdentity;
	}];
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
	animation.fromValue = [NSValue valueWithCATransform3D:self.flipView.layer.transform];
	animation.toValue = [NSValue valueWithCATransform3D:transform];
	animation.duration = CLobbyBackViewDuration;
	[self.flipView.layer addAnimation:animation forKey:@"flip"];
	self.flipView.layer.transform = transform;
	
	animation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
	animation.fromValue = [NSNumber numberWithInt:-1];
	animation.toValue = [NSNumber numberWithInt:1];
	animation.duration = CLobbyBackViewDuration;
	[self.bigArtwork.layer addAnimation:animation forKey:@"z"];
	self.bigArtwork.layer.zPosition = 1;
	
	animation = [CABasicAnimation animationWithKeyPath:@"zPosition"];
	animation.fromValue = [NSNumber numberWithInt:1];
	animation.toValue = [NSNumber numberWithInt:-1];
	animation.duration = CLobbyBackViewDuration;
	[self.backside.layer addAnimation:animation forKey:@"z"];
	self.backside.layer.zPosition = -1;
	
	animation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
	animation.fromValue = [NSNumber numberWithFloat:10.0];
	animation.toValue = [NSNumber numberWithFloat:3.0];
	[self.flipView.layer addAnimation:animation forKey:@"darken"];
	self.flipView.layer.shadowRadius = 3.0;
	[CATransaction commit];
}

@end
