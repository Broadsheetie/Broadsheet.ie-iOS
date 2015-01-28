//
//  CBPPostViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 22/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

@import UIKit;

#import "CBPViewController.h"

@class CBPWordPressPost;
@class CBPWordPressDataSource;

@interface CBPPostViewController : CBPViewController
- (instancetype)initWithPost:(CBPWordPressPost *)post;
- (instancetype)initWithPostId:(NSInteger)postId;
- (instancetype)initWithPost:(CBPWordPressPost *)post withDataSource:(CBPWordPressDataSource *)dataSource withIndex:(NSInteger)index;
- (instancetype)initWithURL:(NSURL *)url;
@end
