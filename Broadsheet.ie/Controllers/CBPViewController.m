//
//  CBPViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 25/09/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPConstants.h"

#import "CBPViewController.h"

@interface CBPViewController ()

@end

@implementation CBPViewController

- (BOOL)shouldAutorotate {
    return ![[NSUserDefaults standardUserDefaults] boolForKey:CBPLockRotation];
}

- (NSUInteger)supportedInterfaceOrientations{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CBPLockRotation]) {
        return UIInterfaceOrientationPortrait;
    }
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
