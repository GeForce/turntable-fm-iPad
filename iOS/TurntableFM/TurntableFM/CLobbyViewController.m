//
//  CRootViewController.m
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLobbyViewController.h"

#import "CTurntableFMModel.h"
#import "CLobbyTableViewCell.h"
#import "CRoomViewController.h"
#import "CFriendsViewController.h"

@interface CLobbyViewController ()

@property(nonatomic, retain) NSDictionary *roomDescription;

- (void)setUp;
- (void)refresh:(id)sender;

@end

@implementation CLobbyViewController

@synthesize searchBar;
@synthesize tableView;
@synthesize lobbyCell;
@synthesize roomDescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setUp];
	}
	return self;
}

- (void)setUp
{
	[[CTurntableFMModel sharedInstance] addObserver:self forKeyPath:@"rooms" options:0 context:NULL];
}

- (void)dealloc
{
	[[CTurntableFMModel sharedInstance] removeObserver:self forKeyPath:@"rooms"];
	
	self.searchBar = nil;
	self.tableView = nil;
	
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[spinner startAnimating];
	UIBarButtonItem *spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	[spinner release];
	self.navigationItem.rightBarButtonItem = spinnerBarItem;
	[spinnerBarItem release];
}

- (void)viewDidUnload
{
	self.searchBar = nil;
	self.tableView = nil;
	
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSIndexPath *path = [self.tableView indexPathForSelectedRow];
	if (path != nil) {
		CTurntableFMModel *model = [CTurntableFMModel sharedInstance];
		[model unregisterWithRoom:self.roomDescription handler:^(void) {
			[self.tableView deselectRowAtIndexPath:path animated:YES];
			UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
			cell.accessoryView = nil;
			self.roomDescription = nil;
			[model stopSong];
		}];
	}
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [CTurntableFMModel sharedInstance].rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CLobbyTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:[CLobbyTableViewCell reuseIdentifier]];
	if (cell == nil) {
		static UINib *nib = nil;
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			nib = [[UINib nibWithNibName:@"CLobbyTableViewCell" bundle:nil] retain];
		});
		[nib instantiateWithOwner:self options:nil];
		cell = self.lobbyCell;
		self.lobbyCell = nil;
	}
	
	CTurntableFMModel *model = [CTurntableFMModel sharedInstance];
	NSArray *room = [model.rooms objectAtIndex:indexPath.row];
	cell.room = room;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [CLobbyTableViewCell cellHeight];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.roomDescription == nil) {
		return indexPath;
	}
	else {
		return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
    {
	CTurntableFMModel *model = [CTurntableFMModel sharedInstance];
	NSArray *room = [model.rooms objectAtIndex:indexPath.row];
	self.roomDescription = [room objectAtIndex:0];
		
		UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[spinner startAnimating];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		cell.accessoryView = spinner;
		[spinner release];
		[[CTurntableFMModel sharedInstance] registerWithRoom:self.roomDescription handler:^(void) {
			CRoomViewController *rvc = [[CRoomViewController alloc] initWithNibName:nil bundle:nil];
			[self.navigationController pushViewController:rvc animated:YES];
			[rvc release];
		}];
    }

#pragma mark - Private

- (void)refresh:(id)sender
{
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[spinner startAnimating];
	UIBarButtonItem *spinnerBarItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	[spinner release];
	self.navigationItem.rightBarButtonItem = spinnerBarItem;
	[spinnerBarItem release];
	
	// hack - actually refresh the list in the future
	double delayInSeconds = 2.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
		self.navigationItem.rightBarButtonItem = refresh;
		[refresh release];
	});
}

- (IBAction)friends:(UIButton *)sender
{
	/*
	UITableViewCell *cell = (UITableViewCell *)[[sender superview] superview];
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	CFriendsViewController *fvc = [[CFriendsViewController alloc] initWithNibName:nil bundle:nil];
	fvc.room = [[CTurntableFMModel sharedInstance].rooms objectAtIndex:indexPath.row];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:fvc];
	[popover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	*/
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == [CTurntableFMModel sharedInstance]) {
		if ([keyPath isEqualToString:@"rooms"]) {
			[self.tableView reloadData];
			UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
			self.navigationItem.rightBarButtonItem = refresh;
			[refresh release];
		}
	}
}

@end
