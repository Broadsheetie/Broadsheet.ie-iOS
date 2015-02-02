//
//  CBPTodayTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 06/09/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSString+HTML.h"

#import "UIImageView+WebCache.h"

#import "CBPTodayTableViewCell.h"

static const CGFloat CBPTodayTableViewCellPadding = 10.0;
static const CGFloat CBPTodayImageHeight = 60.0;

@interface CBPTodayTableViewCell()
@property (nonatomic, assign) BOOL constraintsUpdated;
@property (nonatomic) UIView *detailsView;
@property (nonatomic) UILabel *postCommentLabel;
@property (nonatomic) UILabel *postDateLabel;
@property (nonatomic) UIImageView *postImageView;
@property (nonatomic) UILabel *postTitleLabel;
@end

@implementation CBPTodayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.postImageView];
        [self.contentView addSubview:self.detailsView];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.constraintsUpdated) {
        NSDictionary *views = @{@"postImageView": self.postImageView,
                                @"detailsView": self.detailsView};
        
        NSDictionary *metrics = @{@"imageHeight": @(CBPTodayImageHeight),
                                  @"padding": @(CBPTodayTableViewCellPadding)};
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[postImageView(imageHeight)]-(padding)-[detailsView]-(padding)-|"
                                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                                 metrics:metrics
                                                                                   views:views]];
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.postImageView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.postImageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:CBPTodayImageHeight]];
        self.constraintsUpdated = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.postTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.frame) - (CBPTodayTableViewCellPadding * 2) - CBPTodayImageHeight;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.postCommentLabel.text = nil;
    self.postDateLabel.text = nil;
    self.postImageView.image = nil;
    self.postTitleLabel.text = nil;
}

#pragma mark -
- (void)setCommentCount:(NSInteger)commentCount
{
    if (commentCount == 1) {
        self.postCommentLabel.text = NSLocalizedString(@"1 comment", @"A single comment on this post");
    } else if (commentCount > 1) {
        self.postCommentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d comments", @"X comments on this post"), commentCount];
    }
}

- (void)setImageURI:(NSString *)imageURI
{
    [self.postImageView sd_setImageWithURL:[NSURL URLWithString:imageURI]
                          placeholderImage:nil];
}

- (void)setPostDate:(NSString *)postDate
{
    self.postDateLabel.text = postDate;
    
    [self.postDateLabel sizeToFit];
}

- (void)setPostTitle:(NSString *)postTitle
{
    self.postTitleLabel.text = [postTitle kv_decodeHTMLCharacterEntities];
}

#pragma mark -
- (UIView *)detailsView {
    if (!_detailsView) {
        _detailsView = [UIView new];
        _detailsView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = @{@"postCommentLabel": self.postCommentLabel,
                                @"postDateLabel": self.postDateLabel,
                                @"postTitleLabel": self.postTitleLabel};
        
        NSDictionary *metrics = @{@"padding": @(CBPTodayTableViewCellPadding)};
        
        [_detailsView addSubview:self.postTitleLabel];
        [_detailsView addSubview:self.postDateLabel];
        [_detailsView addSubview:self.postCommentLabel];
        
        [_detailsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[postTitleLabel][postDateLabel]|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views]];
        [_detailsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[postTitleLabel]|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views]];
        [_detailsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[postDateLabel]-[postCommentLabel]|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:views]];
        [_detailsView addConstraint:[NSLayoutConstraint constraintWithItem:self.postCommentLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.postDateLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0]];
    }
    
    return _detailsView;
}

- (UILabel *)postCommentLabel
{
    if (!_postCommentLabel) {
        _postCommentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _postCommentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _postCommentLabel.textColor = [UIColor whiteColor];
    }
    
    return _postCommentLabel;
}

- (UILabel *)postDateLabel
{
    if (!_postDateLabel) {
        _postDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _postDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _postDateLabel.textColor = [UIColor whiteColor];
        
        [_postDateLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    
    return _postDateLabel;
}

- (UIImageView *)postImageView
{
    if (!_postImageView) {
        _postImageView = [UIImageView new];
        _postImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _postImageView.contentMode = UIViewContentModeScaleAspectFill;
        _postImageView.clipsToBounds = YES;
        _postImageView.backgroundColor = [UIColor grayColor];
    }
    
    return _postImageView;
}

- (UILabel *)postTitleLabel
{
    if (!_postTitleLabel) {
        _postTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _postTitleLabel.numberOfLines = 2;
        _postTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _postTitleLabel.textColor = [UIColor whiteColor];
    }
    
    return _postTitleLabel;
}

@end
