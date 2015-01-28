//
//  UIView+CBP.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 08/09/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "UIView+CBP.h"

@implementation UIView (CBP)
-(void)layoutDebugIdentifier:(NSString *)identifier
{
#ifdef DEBUG
    SEL selectorName = NSSelectorFromString(@"_setLayoutDebuggingIdentifier:");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:selectorName]) {
        [self performSelector:selectorName withObject:identifier];
    }
#pragma clang diagnostic pop
#endif
}
@end
