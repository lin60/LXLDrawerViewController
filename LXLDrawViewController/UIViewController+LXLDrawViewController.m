//
//  UIViewController+LXLDrawViewController.m
//  LXLDrawViewController
//
//  Created by Delan on 16/5/19.
//  Copyright © 2016年 xllin. All rights reserved.
//

#import "UIViewController+LXLDrawViewController.h"

@implementation UIViewController (LXLDrawViewController)

- (LXLDrawViewController *)lxlDrawViewController
{
    UIViewController *iret = self.parentViewController;
    while (iret) {
        
        if ([iret isKindOfClass:[LXLDrawViewController class]]) {
            
            return (LXLDrawViewController *)iret;
        } else if (iret.parentViewController && iret.parentViewController != iret)
        {
            iret = iret.parentViewController;
        }else
        {
            iret = nil;
        }
    }
    return nil;
}

@end
