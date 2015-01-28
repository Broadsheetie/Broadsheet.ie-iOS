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
@property (nonatomic, assign) BOOL didUpdateConstraints;
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
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraints) {
        NSDictionary *views = @{@"postCommentLabel": self.postCommentLabel,
                                @"postDateLabel": self.postDateLabel,
                                @"postImageView": self.postImageView,
                                @"postTitleLabel": self.postTitleLabel};
        
        NSDictionary *metrics = @{@"imageHeight": @(CBPTodayImageHeight),
                                  @"padding": @(CBPTodayTableViewCellPadding)};

        NSMutableArray *verticalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[postTitleLabel][postDateLabel]"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views].mutableCopy;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[postImageView(imageHeight)]-(padding)-[postTitleLabel]-(padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[postImageView]-(padding)-[postDateLabel]-[postCommentLabel]-(>=padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.postTitleLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.postImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.postCommentLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.postDateLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.postImageView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0]];
        [verticalContraints addObject:[NSLayoutConstraint constraintWithItem:self.postImageView
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0f
                                                                      constant:CBPTodayImageHeight]];
        
        for (NSLayoutConstraint *constraint in verticalContraints) {
            constraint.priority = UILayoutPriorityDefaultHigh;
        }
        [self.contentView addConstraints:verticalContraints];
        
        self.didUpdateConstraints = YES;
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

- (UILabel *)postCommentLabel
{
    if (!_postCommentLabel) {
        _postCommentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _postCommentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _postCommentLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_postCommentLabel];
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
        
        [self.contentView addSubview:_postDateLabel];
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
        
        [self.contentView addSubview:_postImageView];
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
        
        [self.contentView addSubview:_postTitleLabel];
    }
    
    return _postTitleLabel;
}

@end
