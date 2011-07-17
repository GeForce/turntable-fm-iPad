//
//  CQueueViewController.m
//  TurntableFM
//
//  Created by August Joki on 7/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CQueueViewController.h"

@interface CQueueViewController ()

- (void)moveToTop:(UIButton *)sender;

@end

@implementation CQueueViewController

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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// queue comes from?
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *Identifier = @"Cell";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:Identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier] autorelease];
		cell.indentationLevel = 4;
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(moveToTop:) forControlEvents:UIControlEventTouchUpInside];
		button.tag = indexPath.row;
		[cell addSubview:button];
		button.frame = CGRectMake(5.0, 7.0, 30.0, 30.0);
	}
	
	cell.textLabel.text = @"Song title";
	cell.detailTextLabel.text = @"Artist name";
	
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
		// remove song
	}
}

- (void)moveToTop:(UIButton *)sender
{
	NSInteger row = sender.tag;
	NSLog(@"%d", row);
}

@end
