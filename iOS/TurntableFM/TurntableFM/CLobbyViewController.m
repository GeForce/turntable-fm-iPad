//
//  CRootViewController.m
//  TurntableFM
//
//  Created by August Joki on 7/16/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CLobbyViewController.h"

#import "CTurntableFMModel.h"

@interface CLobbyViewController ()

- (void)setUp;
- (void)refresh:(id)sender;

@end

@implementation CLobbyViewController

@synthesize searchBar;
@synthesize tableView;

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
	static NSString *Identifier = @"Cell";
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:Identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	CTurntableFMModel *model = [CTurntableFMModel sharedInstance];
	NSArray *room = [model.rooms objectAtIndex:indexPath.row];
	NSDictionary *description = [room objectAtIndex:0];
	cell.textLabel.text = [description objectForKey:@"name"];
	NSDictionary *metadata = [description objectForKey:@"metadata"];
	NSDictionary *song = [metadata objectForKey:@"current_song"];
	metadata = [song objectForKey:@"metadata"];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [metadata objectForKey:@"song"], [metadata objectForKey:@"artist"]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
    {
	CTurntableFMModel *model = [CTurntableFMModel sharedInstance];
	NSArray *room = [model.rooms objectAtIndex:indexPath.row];
	NSDictionary *theRoomDescription = [room objectAtIndex:0];

    [[CTurntableFMModel sharedInstance] registerWithRoom:theRoomDescription handler:NULL];
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
