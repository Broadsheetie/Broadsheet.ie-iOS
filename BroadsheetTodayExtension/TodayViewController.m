//
//  TodayViewController.m
//  Broadsheet Latest Posts
//
//  Created by Karl Monaghan on 06/09/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

#import "CBPTodayDataSource.h"

#import "CBPTodayTableViewCell.h"

#import "CBPWordPressTodayPost.h"

@interface TodayViewController () <NCWidgetProviding, UITableViewDelegate>
@property (nonatomic, assign) BOOL contentShown;
@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic) CBPTodayDataSource *dataSource;
@property (nonatomic) UITableView *tableView;
@end

@implementation TodayViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"tableView": self.tableView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"tableView": self.tableView}]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.dataSource loadPosts:2 completion:^(NSError *error) {
        if (!error) {
            [self updateTableView];
        } else {
#ifdef DEBUG
            NSLog(@"Download error: %@", error);
#endif
        }
    }];
}

#pragma mark - NCWidgetProviding
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    [self.dataSource loadPosts:2 completion:^(NSError *error) {
        NCUpdateResult result = NCUpdateResultNoData;
        if (!error) {
            result = NCUpdateResultNewData;
            
            [self updateTableView];
        } else {
#ifdef DEBUG
            NSLog(@"Download error: %@", error);
#endif
            result = NCUpdateResultFailed;
        }
        
        completionHandler(result);
    }];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsMake(defaultMarginInsets.top, 16.0f, defaultMarginInsets.bottom, 16.0f);
}

#pragma mark -
- (void)updateTableView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        
        if (((self.dataSource.firstItemStatus == CBPTodayDataSourceItemUnknown) && (self.dataSource.secondItemStatus == CBPTodayDataSourceItemUnknown))
            || !self.contentShown) {
            self.contentShown = YES;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            if (self.dataSource.firstItemStatus == CBPTodayDataSourceItemDifferent) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
            if (self.dataSource.secondItemStatus == CBPTodayDataSourceItemDifferent) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                
            }
        }
        [self.tableView endUpdates];
        
        CGFloat height = (self.tableView.contentSize.height) ? self.tableView.contentSize.height : [self.dataSource tableView:self.tableView numberOfRowsInSection:0] * CBPTodayTableViewCellHeight;
        
        [self setPreferredContentSize:CGSizeMake(self.tableView.contentSize.width, height)];
    });
    
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPWordPressTodayPost *post = [self.dataSource postAtIndex:indexPath.row];
    
    [self.extensionContext openURL:[NSURL URLWithString:[NSString stringWithFormat:@"BroadsheetIe://%@", @(post.postId)]]
                 completionHandler:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

#pragma mark -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self.dataSource;
        
        _tableView.rowHeight = CBPTodayTableViewCellHeight;
        _tableView.estimatedRowHeight = CBPTodayTableViewCellHeight;
        _tableView.backgroundView = nil;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[CBPTodayTableViewCell class] forCellReuseIdentifier:CBPTodayTableViewCellIdentifier];
    }
    
    return _tableView;
}

- (CBPTodayDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [CBPTodayDataSource new];
    }
    
    return _dataSource;
}

@end

