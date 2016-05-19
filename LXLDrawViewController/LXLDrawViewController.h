//
//  LXLDrawViewController.h
//  LXLDrawViewController
//
//  Created by Delan on 16/5/18.
//  Copyright © 2016年 xllin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXLDrawViewControllerDelegate;


@interface LXLDrawViewController : UIViewController

@property (strong, readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, readwrite, nonatomic) BOOL panGestureEnabled;
@property (assign, readwrite, nonatomic) CGFloat backgroundFadeAmount;

@property (assign, readwrite, nonatomic) NSTimeInterval animationDuration;

@property (strong, readwrite, nonatomic) UIViewController *centerViewController;
@property (strong, readwrite, nonatomic) UIViewController *menuViewController;

@property (nonatomic ,assign) CGFloat containerWidth;
@property (weak, readwrite, nonatomic) id<LXLDrawViewControllerDelegate> delegate;

- (instancetype)initWithMenuViewController:(UIViewController *)menu centerViewController:(UIViewController *)center;
- (void)presentMenuViewControllerWithAnimationAppearance:(BOOL)animation;
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;

- (void)hideMenuViewControllerWithCompletionHandler:(void(^)(void))completionHandler;


@end

@protocol LXLDrawViewControllerDelegate <NSObject>

- (void)lxlViewController:(LXLDrawViewController *)lxlViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer;

@end

