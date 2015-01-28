//
//  CBPNavigationController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 25/09/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPNavigationController.h"

@interface CBPNavigationController ()

@end

@implementation CBPNavigationController

- (BOOL)shouldAutorotate
{
    return self.visibleViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.visibleViewController.supportedInterfaceOrientations;
}
@end
