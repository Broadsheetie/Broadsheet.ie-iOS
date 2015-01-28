//
//  CBPTodayTableViewCell.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 06/09/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CBPTodayTableViewCellHeight = 88.0;
static NSString * const CBPTodayTableViewCellIdentifier = @"CBPTodayTableViewCellIdentifier";

@interface CBPTodayTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic) NSString *imageURI;
@property (nonatomic) NSString *postDate;
@property (nonatomic) NSString *postTitle;
@end
