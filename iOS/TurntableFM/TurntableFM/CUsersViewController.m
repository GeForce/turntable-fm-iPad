//
//  CUsersViewController.m
//  TurntableFM
//
//  Created by August Joki on 7/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CUsersViewController.h"

#import "CTurntableFMModel.h"
#import "CRoom.h"
#import "CUser.h"

@interface CUsersViewController () <UIActionSheetDelegate>

@end

@implementation CUsersViewController

@synthesize tableView;
@synthesize room;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Users";
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
	height = MAX(height, 175.0);
	return CGSizeMake(320.0, height);
}

- (void)setRoom:(CRoom *)rm
{
	if (rm != room) {
		[room removeObserver:self forKeyPath:@"users"];
		[room release];
		room = [rm retain];
		[room addObserver:self forKeyPath:@"users" options:0 context:NULL];
	}
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
		cell.textLabel.textAlignment = UITextAlignmentRight;
	}
	
	CUser *user = [self.room.users objectAtIndex:indexPath.row];
	cell.textLabel.text = user.name;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Fan", @"Profile", nil];
	BOOL isPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
	if (isPhone) {
		[actionSheet showInView:self.view];
	}
	else {
		CGRect rect = [self.tableView rectForRowAtIndexPath:indexPath];
		[actionSheet showFromRect:rect inView:self.tableView animated:YES];
	}
	[actionSheet release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		
	}
	else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
		CUser *user = [self.room.users objectAtIndex:indexPath.row];
		[[CTurntableFMModel sharedInstance] fanUser:user handler:NULL];
	}
	else {
		
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == self.room) {
		if ([keyPath isEqualToString:@"users"]) {
			[self.tableView reloadData];
		}
	}
}

@end
