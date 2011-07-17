//
//  CUsersViewController.h
//  TurntableFM
//
//  Created by August Joki on 7/17/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CRoom;

@interface CUsersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) IBOutlet UITableView *tableView;

@property(nonatomic, retain) CRoom *room;

@end
