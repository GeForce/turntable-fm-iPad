//
//  CMainViewController.m
//  TurntableFM
//
//  Created by Jonathan Wight on 07/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CMainViewController.h"

#import "CApplicationController.h"
#import "CTurntableFMModel.h"

@implementation CMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    }

#pragma mark - View lifecycle

- (void)viewDidLoad
    {
    [super viewDidLoad];
    }

- (void)viewDidUnload
    {
    [super viewDidUnload];
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
    {
	return YES;
    }

- (IBAction)rooms:(id)sender
    {
    NSLog(@"ROOMS");

    UIActionSheet *theActionSheet = [[[UIActionSheet alloc] initWithTitle:@"Rooms" delegate:self cancelButtonTitle:NULL destructiveButtonTitle:NULL otherButtonTitles:NULL] autorelease];
    
    
    for (id theRoom in [CTurntableFMModel sharedInstance].rooms)
        {
        NSString *theRoomName = [[theRoom objectAtIndex:0] objectForKey:@"description"];
        [theActionSheet addButtonWithTitle:theRoomName];
        }
    
    [theActionSheet showFromBarButtonItem:sender animated:YES];
    }

@end
