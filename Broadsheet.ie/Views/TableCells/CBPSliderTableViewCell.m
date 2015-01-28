//
//  CBPSliderTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 30/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPConstants.h"

#import "CBPSliderTableViewCell.h"

@interface CBPSliderTableViewCell()
@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic) UILabel *exampleLabel;
@property (nonatomic) UISlider *slider;
@end

@implementation CBPSliderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.exampleLabel];
        [self.contentView addSubview:self.slider];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraints) {
        NSDictionary *views = @{@"exampleLabel": self.exampleLabel,
                                @"slider": self.slider};
        
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[exampleLabel]-[slider]-|"
                                                                               options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight
                                                                               metrics:nil
                                                                                 views:views];
        
        
        for (NSLayoutConstraint *constraint in verticalConstraints) {
            constraint.priority = UILayoutPriorityDefaultHigh;
        }
        
        [self.contentView addConstraints:verticalConstraints];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(20)-[exampleLabel]-(20)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        self.didUpdateConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark -
- (void)sliderChangedAction
{
    self.exampleLabel.font = [UIFont systemFontOfSize:self.slider.value];
}

#pragma mark -
- (void)setFontSize:(CGFloat)fontSize {
    self.slider.value = fontSize;
    
    [self sliderChangedAction];
}

#pragma mark -
- (UILabel *)exampleLabel {
    if (!_exampleLabel) {
        _exampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CBPPadding, 0, CGRectGetWidth(self.contentView.frame) - (CBPPadding * 2), 132.0f)];
        _exampleLabel.text = NSLocalizedString(@"Move the slider to change the text size used in a post", nil);
        _exampleLabel.numberOfLines = 3;
        _exampleLabel.textAlignment = NSTextAlignmentCenter;
        _exampleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _exampleLabel;
}

- (CGFloat)fontSize {
    return self.slider.value;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [UISlider new];
        _slider.translatesAutoresizingMaskIntoConstraints = NO;
        
        _slider.minimumValue = CBPMinimumFontSize;
        _slider.maximumValue = CBPMaximiumFontSize;
        
        UILabel *smallLabel = [UILabel new];
        smallLabel.font = [UIFont systemFontOfSize:CBPMinimumFontSize];
        smallLabel.text = @"A";
        [smallLabel sizeToFit];
        
        UIGraphicsBeginImageContextWithOptions(smallLabel.frame.size, NO, 0.0);
        [smallLabel.layer renderInContext: UIGraphicsGetCurrentContext()];
        _slider.minimumValueImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UILabel *largeLabel = [UILabel new];
        largeLabel.font = [UIFont systemFontOfSize:CBPMaximiumFontSize];
        largeLabel.text = @"A";
        [largeLabel sizeToFit];
        
        UIGraphicsBeginImageContextWithOptions(largeLabel.frame.size, NO, 0.0);
        [largeLabel.layer renderInContext: UIGraphicsGetCurrentContext()];
        _slider.maximumValueImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [_slider addTarget:self action:@selector(sliderChangedAction) forControlEvents:UIControlEventValueChanged];
    }
    
    return _slider;
}
@end
