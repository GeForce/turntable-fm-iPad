//
//  TurntableFMAppDelegate.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/15/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CApplicationController.h"

#import "FBConnect.h"
#import "CTurntableFMModel.h"

@interface CApplicationController () <FBSessionDelegate, UIAlertViewDelegate>

@property (readwrite, nonatomic, retain) Facebook *facebook;
@end

#pragma mark -

@implementation CApplicationController

@synthesize window;
@synthesize controller;
@synthesize facebookAccessToken;

@synthesize facebook;

static CApplicationController *gSharedInstance = NULL;

+ (CApplicationController *)sharedInstance
    {
    return(gSharedInstance);
    }

- (id)init
	{
	if ((self = [super init]) != NULL)
		{
        gSharedInstance = self;
		}
	return(self);
	}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
    self.facebookAccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"FacebookAccessToken"];
    if (self.facebookAccessToken == NULL)
        {
        self.facebook = [[[Facebook alloc] initWithAppId:@"185032898222483"] autorelease];
        NSLog(@"ACCESS TOKEN: %@", self.facebook.accessToken);
        if (self.facebook.accessToken.length == 0)
            {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connect to Facebook"
																	message:@"You need to connect to Facebook to use Turntable.fm."
																   delegate:self
														  cancelButtonTitle:@"Cancel"
														  otherButtonTitles:@"Connect", nil];
				[alertView show];
				[alertView release];
            }
        }
    else
        {
        
        [[CTurntableFMModel sharedInstance] loginWithFacebookAccessToken:self.facebookAccessToken];
        }

    return(YES);
    }

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
    {
    [self.facebook handleOpenURL:url];
    
    return(YES);
    }

- (void)applicationWillResignActive:(UIApplication *)application
    {
    }

- (void)applicationDidEnterBackground:(UIApplication *)application
    {
    }

- (void)applicationWillEnterForeground:(UIApplication *)application
    {
    }

- (void)applicationDidBecomeActive:(UIApplication *)application
    {
    }

- (void)applicationWillTerminate:(UIApplication *)application
    {
    }

#pragma mark -

- (void)fbDidLogin
    {
    NSLog(@"DID LOGIN: %@", self.facebook.accessToken);
    if (self.facebook.accessToken != NULL)
        {
        self.facebookAccessToken = self.facebook.accessToken;
        
        [[NSUserDefaults standardUserDefaults] setObject:self.facebook.accessToken forKey:@"FacebookAccessToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
			
		[[CTurntableFMModel sharedInstance] loginWithFacebookAccessToken:self.facebookAccessToken];
        }
    }
    
- (void)fbDidNotLogin:(BOOL)cancelled
    {
    NSLog(@"DID NOT LOGIN");
    }
    
- (void)fbDidLogout
    {
    NSLog(@"DID LOGOUT");
    }

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex) {
		NSArray *thePermissions = [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access", NULL];
		
		[self.facebook authorize:thePermissions delegate:self];
	}
}

@end
