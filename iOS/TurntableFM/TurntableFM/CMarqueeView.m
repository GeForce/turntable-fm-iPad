//
//  CMarqueeView.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 06/18/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMarqueeView.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface CMarqueeView ()
@property (readwrite, nonatomic, assign) CGSize textSize;
@property (readwrite, nonatomic, retain) CALayer *scrollingLayer; 

- (void)prepareLayer;
@end

@implementation CMarqueeView

@synthesize text;
@synthesize font;

@synthesize textSize;
@synthesize scrollingLayer;

- (id)initWithFrame:(CGRect)frame
    {
    if ((self = [super initWithFrame:frame]) != NULL)
        {
        font = [[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] retain];
        }
    return(self);
    }

- (id)initWithCoder:(NSCoder *)inDecoder
    {
    if ((self = [super initWithCoder:inDecoder]) != NULL)
        {
        font = [[UIFont boldSystemFontOfSize:[UIFont labelFontSize]] retain];

        self.layer.masksToBounds = YES;
        }
    return(self);
    }
    
- (void)setText:(NSString *)inText
    {
    if (text != inText)
        {
        [text release];
        text = [inText retain];
                
        [self prepareLayer];
        }
    }

- (void)willMoveToWindow:(UIWindow *)inWindow
    {
    [super willMoveToWindow:inWindow];
    }

- (void)didMoveToWindow
    {
    [super didMoveToWindow];
    
    if (self.window != NULL)
        {
        [self prepareLayer];
        }
    }

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
    {
    if (flag == YES)
        {
        [self.scrollingLayer removeFromSuperlayer];
        self.scrollingLayer = NULL;

        [self prepareLayer];
        }
    }

- (void)prepareLayer
    {
    NSLog(@"NEW TEXT: %@", self.text);

    [self.scrollingLayer removeFromSuperlayer];
    self.scrollingLayer = NULL;

    if (self.text.length == 0)
        {
        return;
        }

    NSLog(@"CHANGING LAYER");

    CTFontRef theFont = CTFontCreateWithName((CFStringRef)objc_unretainedPointer(self.font.fontName), self.font.pointSize, NULL);

    NSDictionary *theAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
        objc_unretainedObject(theFont), kCTFontAttributeName,
        NULL];
        
    NSAttributedString *theAttributedString = [[[NSAttributedString alloc] initWithString:self.text attributes:theAttributes] autorelease];    
    
    CTFramesetterRef theFrameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)theAttributedString);
    
    self.textSize = CTFramesetterSuggestFrameSizeWithConstraints(theFrameSetter, (CFRange){ .length = self.text.length }, NULL, (CGSize){ CGFLOAT_MAX, CGFLOAT_MAX }, NULL);
//    NSLog(@"CT: %@", NSStringFromCGSize(self.textSize));
    
    CFRelease(theFrameSetter);

    //

    CATextLayer *theTextLayer = [CATextLayer layer];
    theTextLayer.string = self.text;
    theTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    theTextLayer.font = theFont;
    theTextLayer.fontSize = self.font.pointSize;
    theTextLayer.bounds = (CGRect){ .size = self.textSize };
    theTextLayer.position = (CGPoint){ CGRectGetMaxX(self.bounds) + self.textSize.width * 0.5, CGRectGetMidY(self.bounds) };
    theTextLayer.anchorPoint = (CGPoint){ 0.5, 0.5 };
//    theTextLayer.borderColor = [UIColor redColor].CGColor;
//    theTextLayer.borderWidth = 1.0;
    
    CFRelease(theFont);
    
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    theAnimation.toValue = [NSNumber numberWithFloat:-self.textSize.width * 0.5];
    theAnimation.speed = 0.05;
    theAnimation.delegate = self;
    
    [theTextLayer addAnimation:theAnimation forKey:@"scroll"];
    
    [self.layer addSublayer:theTextLayer];
    
    self.scrollingLayer = theTextLayer;
    
    NSLog(@"DONEE WITH CHANGE LAYER");
    }

@end
