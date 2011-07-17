//
//  CUsersViewController.m
//  TurntableFM
//
//  Created by August Joki on 7/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CUsersViewController.h"

#import "CRoom.h"
#import "CUser.h"

@implementation CUsersViewController

@synthesize tableView;
@synthesize room;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	self.tableView = nil;
	self.room = nil;
	
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
}

- (void)viewDidUnload
{
	self.tableView = nil;
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGSize)contentSizeForViewInPopover
{
	CGFloat height = MIN(44.0 * self.room.users.count, 800.0);
	return CGSizeMake(256.0, height);
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.room.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CUser *user = [self.room.users objectAtIndex:indexPath.row];
	NSInteger avatarID = user.avatarID;
	NSString *imageName = [NSString stringWithFormat:@"avatars_%d_headfront.png", avatarID];
	UIImage *image = [UIImage imageNamed:imageName];
	return image.size.height/2;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *Identifier = @"Cell";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:Identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier] autorelease];
	}
	
	CUser *user = [self.room.users objectAtIndex:indexPath.row];
	cell.textLabel.text = user.name;
	cell.textLabel.textAlignment = UITextAlignmentRight;
	NSInteger avatarID = user.avatarID;
	NSString *imageName = [NSString stringWithFormat:@"avatars_%d_headfront.png", avatarID];
	cell.imageView.image = [UIImage imageNamed:imageName];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	// check whether we have the ability to boot
	return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return @"Boot";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// boot user
	}
}

@end
