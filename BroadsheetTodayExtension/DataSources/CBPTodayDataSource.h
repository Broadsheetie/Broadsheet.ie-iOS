//
//  CBPTodayDataSource.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 06/09/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBPWordPressTodayPost;

typedef NS_ENUM(NSInteger, CBPTodayDataSourceItemStatus) {
    CBPTodayDataSourceItemUnknown,
    CBPTodayDataSourceItemSame,
    CBPTodayDataSourceItemDifferent
};

@interface CBPTodayDataSource : NSObject <UITableViewDataSource>
- (void)loadPosts:(NSInteger)count completion:(void (^)(NSError* error)) handler;
- (CBPWordPressTodayPost *)postAtIndex:(NSInteger)index;

@property (nonatomic, assign) NSInteger firstItemStatus;
@property (nonatomic, assign) NSInteger secondItemStatus;
@end
