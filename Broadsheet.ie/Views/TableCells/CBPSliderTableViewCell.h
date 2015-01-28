//
//  CBPSliderTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 30/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

@import UIKit;

static const CGFloat CBPSliderTableViewCellHeight = 176.0;
static NSString * const CBPSliderTableViewCellIdentifier = @"CBPSliderTableViewCellIdentifier";

@interface CBPSliderTableViewCell : UITableViewCell
@property (nonatomic) UISlider *slider;

@end
