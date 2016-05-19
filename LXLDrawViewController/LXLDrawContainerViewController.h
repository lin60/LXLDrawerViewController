//
//  LXLDrawContainerViewController.h
//  LXLDrawViewController
//
//  Created by Delan on 16/5/18.
//  Copyright © 2016年 xllin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LXLDrawViewController;

@interface LXLDrawContainerViewController : UIViewController

@property (nonatomic ,weak ,readwrite) LXLDrawViewController *lxlDrawViewController;
@property (assign, readwrite, nonatomic) BOOL animateApperance;
@property (strong, readonly, nonatomic) UIView *containerView;


- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;

- (void)hideWithCompletionHandler:(void(^)(void))completionHandler;
- (void)resizeToSize:(CGSize)size;

@end
