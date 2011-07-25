//
//  CQueueViewController.m
//  TurntableFM
//
//  Created by August Joki on 7/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CQueueViewController.h"

#import "CTurntableFMModel.h"
#import "CSong.h"

@interface CQueueViewController ()

@property(nonatomic, retain) NSMutableArray *songs;

- (void)moveToTop:(UIButton *)sender;

@end

@implementation CQueueViewController

@synthesize tableView;
@synthesize room;
@synthesize songs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = @"Queue";
		self.songs = [[[[CTurntableFMModel sharedInstance] songQueue] mutableCopy] autorelease];
		[[CTurntableFMModel sharedInstance] addObserver:self forKeyPath:@"songQueue" options:0 context:NULL];
    }
    return self;
}

- (void)dealloc
{
	[[CTurntableFMModel sharedInstance] removeObserver:self forKeyPath:@"songQueue"];
	
	self.tableView = nil;
	self.room = nil;
	self.songs = nil;
	
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
	CGFloat height = MIN(44.0 * self.songs.count, 800.0);
	return CGSizeMake(320.0, height);
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *Identifier = @"Cell";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:Identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier] autorelease];
		cell.indentationLevel = 3;
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = 1;
		[button setImage:[UIImage imageNamed:@"images_playlist_go-top-green.png"] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(moveToTop:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:button];
		button.frame = CGRectMake(5.0, 7.0, 30.0, 30.0);
	}
	
	CSong *song = [self.songs objectAtIndex:indexPath.row];
	cell.textLabel.text = song.name;
	cell.detailTextLabel.text = song.artist;
	UIButton *button = (UIButton *)[cell viewWithTag:1];
	if (indexPath.row == 0) {
		button.hidden = YES;
	}
	else {
		button.hidden = NO;
	}
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return @"Remove";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[CTurntableFMModel sharedInstance] removeSongFromPlaylist:indexPath.row handler:^(void) {
			[self.songs removeObjectAtIndex:indexPath.row];
			[self.tableView reloadData];
		}];
	}
}

- (void)moveToTop:(UIButton *)sender
{
	UITableViewCell *cell = (UITableViewCell *)[sender superview];
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	CSong *song = [self.songs objectAtIndex:indexPath.row];
    // TODO: Handle actual move-to-top event
	NSIndexPath *top = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.songs removeObjectAtIndex:indexPath.row];
	[self.songs insertObject:song atIndex:top.row];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (object == [CTurntableFMModel sharedInstance]) {
		if ([keyPath isEqualToString:@"songQueue"]) {
			self.songs = [[[[CTurntableFMModel sharedInstance] songQueue] mutableCopy] autorelease];
			[self.tableView reloadData];
		}
	}
}

@end
