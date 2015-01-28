//
//  CBPTableViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 18/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "DFPBannerView.h"
#import <SVPullToRefresh/SVPullToRefresh.h>

#import "BSConstants.h"
#import "CBPConstants.h"

#import "CBPTableViewController.h"

@interface CBPTableViewController () <GADBannerViewDelegate>
@property (nonatomic) UIView *containerView;
@property (nonatomic) DFPBannerView *dfpBannerView;
@property (nonatomic) NSLayoutConstraint *dfpBannerViewHeightConstraint;
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) UIView *errorView;
@property (nonatomic) UIView *loadingView;
@property (nonatomic) UIButton *reloadButton;
@end

@implementation CBPTableViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.dfpAdUnit = BSHomeAdUnit;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.containerView];
    
    [self.view addSubview:self.dfpBannerView];
    
    NSDictionary *views = @{@"topLayoutGuide": self.topLayoutGuide,
                            @"dfpBannerView": self.dfpBannerView,
                            @"containerView": self.containerView};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dfpBannerView][containerView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[dfpBannerView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[containerView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    self.dfpBannerViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.dfpBannerView
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.topLayoutGuide
                                                                      attribute:NSLayoutAttributeTop
                                                                     multiplier:1.0f
                                                                       constant:-50.0f];
    [self.view addConstraint:self.dfpBannerViewHeightConstraint];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.canPullToRefresh) {
        // setup pull-to-refresh
        [self.tableView addPullToRefreshWithActionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf load:NO];
        }];
    }
    
    if (self.canInfiniteLoad) {
        // setup infinite scrolling
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf load:YES];
        }];
        
        self.tableView.infiniteScrollingView.enabled = NO;
    }
    
    [self stopLoading:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.errorLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - (CBPPadding * 2);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.dfpBannerView.adSize = kGADAdSizeSmartBannerLandscape;
    } else {
        self.dfpBannerView.adSize = kGADAdSizeSmartBannerPortrait;
    }
}

#pragma mark -
- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark -
- (void)errorLoading:(NSError *)error
{
    self.errorLabel.text = error.localizedDescription;
    [self.errorLabel sizeToFit];
    self.errorLabel.center = self.errorView.center;
    
    [self.containerView bringSubviewToFront:self.errorView];
    
    [self stopLoading:NO];
}

- (void)load:(BOOL)more
{
    if (!more) {
        [self startLoading];
        self.canLoadMore = NO;
        self.tableView.infiniteScrollingView.enabled = self.canLoadMore;
    }
}

- (void)reload
{
    [self load:NO];
}

- (void)startLoading
{
    [self.containerView bringSubviewToFront:self.loadingView];
    [self.containerView sendSubviewToBack:self.errorView];
    
    self.errorLabel.text = nil;
}

- (void)stopLoading:(BOOL)more
{
    [self.containerView sendSubviewToBack:self.loadingView];
    
    if (more) {
        [self.tableView.infiniteScrollingView stopAnimating];
    } else {
        [self.tableView.pullToRefreshView stopAnimating];
    }
    
    self.tableView.infiniteScrollingView.enabled = self.canLoadMore;
}

#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view;
{
    self.dfpBannerViewHeightConstraint.constant = 0;
    
    [UIView animateWithDuration:0.3f
                     animations:^() {
                         [self.view layoutIfNeeded];
                     }];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    self.dfpBannerViewHeightConstraint.constant = -50.0f;
    
    [UIView animateWithDuration:0.3f
                     animations:^() {
                         [self.view layoutIfNeeded];
                     }];
}

#pragma mark -
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_containerView addSubview:self.errorView];
        
        [_containerView addSubview:self.loadingView];
        
        [_containerView addSubview:self.tableView];
        
        NSDictionary *views = @{@"errorView": self.errorView,
                                @"loadingView": self.loadingView,
                                @"tableView": self.tableView,};
        
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_containerView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0f
                                                                    constant:0]];
        [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
        [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[tableView]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:views]];
    }
    
    return _containerView;
}

- (DFPBannerView *)dfpBannerView
{
    if (!_dfpBannerView) {
        _dfpBannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        _dfpBannerView.translatesAutoresizingMaskIntoConstraints = NO;
        _dfpBannerView.delegate = self;
        _dfpBannerView.adUnitID = self.dfpAdUnit;
        _dfpBannerView.rootViewController = self;
        GADRequest *request =[GADRequest request];
#if TARGET_IPHONE_SIMULATOR
        request.testDevices = @[ GAD_SIMULATOR_ID ];
#endif
        [_dfpBannerView loadRequest:request];
    }
    
    return _dfpBannerView;
}

- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [UILabel new];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _errorLabel.numberOfLines = 0;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - (CBPPadding * 2);
        _errorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    
    return _errorLabel;
}

- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [UIView new];
        _errorView.translatesAutoresizingMaskIntoConstraints = NO;
        _errorView.backgroundColor = [UIColor whiteColor];
        
        [_errorView addSubview:self.errorLabel];
        [_errorView addSubview:self.reloadButton];
        
        NSDictionary *views = @{@"errorLabel": self.errorLabel,
                                @"reloadButton": self.reloadButton};
        [_errorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[errorLabel]-(40)-[reloadButton]"
                                                                           options:NSLayoutFormatAlignAllCenterX
                                                                           metrics:nil
                                                                             views:views]];
        [_errorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[errorLabel]-(padding)-|"
                                                                           options:0
                                                                           metrics:@{@"padding": @(CBPPadding)}
                                                                             views:views]];
        [_errorView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_errorView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0f
                                                                constant:0]];
    }
    
    return _errorView;
}

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [UIView new];
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        _loadingView.backgroundColor = [UIColor whiteColor];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.translatesAutoresizingMaskIntoConstraints = NO;
        [spinner startAnimating];
        
        [_loadingView addSubview:spinner];
        
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:spinner
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_loadingView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0]];
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:spinner
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_loadingView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0]];
    }
    
    return _loadingView;
}

- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setTitle:NSLocalizedString(@"Reload", nil) forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_reloadButton sizeToFit];
    }
    
    return _reloadButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    return _tableView;
}

@end
