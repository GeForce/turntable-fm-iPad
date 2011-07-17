//
//  TurntableFMAppDelegate.h
//  TurntableFM
//
//  Created by Jonathan Wight on 07/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CApplicationController : UIResponder <UIApplicationDelegate>

@property (readwrite, nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, nonatomic, retain) IBOutlet UINavigationController *controller;

@property (readwrite, nonatomic, retain) NSString *facebookAccessToken;

+ (CApplicationController *)sharedInstance;

@end
