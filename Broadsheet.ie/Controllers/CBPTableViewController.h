//
//  CBPTableViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 18/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

@import UIKit;

#import "CBPViewController.h"

@interface CBPTableViewController : CBPViewController <UITableViewDelegate>
@property (nonatomic) NSString *dfpAdUnit;
@property (nonatomic, assign) BOOL canInfiniteLoad;
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) BOOL canPullToRefresh;
@property (nonatomic) UITableView *tableView;

- (void)errorLoading:(NSError *)error;
- (void)load:(BOOL)more;
- (void)startLoading;
- (void)stopLoading:(BOOL)more;
@end
