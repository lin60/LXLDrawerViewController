//
//  LXLDrawViewController.m
//  LXLDrawViewController
//
//  Created by Delan on 16/5/18.
//  Copyright © 2016年 xllin. All rights reserved.
//

#import "LXLDrawViewController.h"
#import "LXLDrawContainerViewController.h"

@interface LXLDrawViewController ()

@property (assign, readwrite, nonatomic) CGSize calculatedMenuViewSize;
@property (strong, readwrite, nonatomic) LXLDrawContainerViewController *containerViewController;
@property (assign ,readwrite, nonatomic) BOOL visible;

@end

@implementation LXLDrawViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _panGestureEnabled = YES;
    _animationDuration = 0.3;
    _containerViewController = [[LXLDrawContainerViewController alloc]init];
    _containerViewController.lxlDrawViewController = self;
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:_containerViewController action:@selector(panGestureRecognized:)];
    _containerWidth = 230;
}

- (instancetype)initWithMenuViewController:(UIViewController *)menu centerViewController:(UIViewController *)center
{
    self = [self init];
    
    if (self) {
        
        _centerViewController = center;
        _menuViewController = menu;
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addChildViewController:self.centerViewController];
    self.centerViewController.view.frame = self.view.bounds;
    [self.view addSubview:self.centerViewController.view];
    [self.centerViewController didMoveToParentViewController:self];
}

/**
 *  保证初始化时候有单独设置center or menu 页面
 *
 *  @param centerViewController
 */
- (void)setCenterViewController:(UIViewController *)centerViewController
{
    if (!_centerViewController) {
        
        _centerViewController = centerViewController;
        return;
    }
    
    [_centerViewController removeFromParentViewController];
    [_centerViewController.view removeFromSuperview];
    
    if (centerViewController) {
        
        [self addChildViewController:centerViewController];
        centerViewController.view.frame = self.containerViewController.view.frame;
        [self.view insertSubview:centerViewController.view atIndex:0];
        [centerViewController didMoveToParentViewController:self];
    }
    
    _centerViewController = centerViewController;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    if (_menuViewController) {
        
        [_menuViewController removeFromParentViewController];
        [_menuViewController.view removeFromSuperview];
    }
    
    _menuViewController = menuViewController;
    
    CGRect frame = _menuViewController.view.frame;
    [_menuViewController willMoveToParentViewController:nil];
    [_menuViewController removeFromParentViewController];
    [_menuViewController.view removeFromSuperview];
    if (!_menuViewController) {
        return;
    }
    [self.containerViewController addChildViewController:menuViewController];
    menuViewController.view.frame = frame;
    [self.containerViewController.containerView addSubview:menuViewController.view];
    [menuViewController didMoveToParentViewController:self];
}

- (void)presentMenuViewControllerWithAnimationAppearance:(BOOL)animation
{
    self.containerViewController.animateApperance = animation;
    self.calculatedMenuViewSize = CGSizeMake(_containerWidth, self.centerViewController.view.frame.size.height);
    
    [self addChildViewController:self.containerViewController];
    self.containerViewController.view.frame = self.centerViewController.view.frame;
    [self.view addSubview:self.containerViewController.view];
    [self.containerViewController didMoveToParentViewController:self];
    
    self.visible = YES;
}

- (void)hideMenuViewController
{
    [self hideMenuViewControllerWithCompletionHandler:nil];
}

- (void)hideMenuViewControllerWithCompletionHandler:(void (^)(void))completionHandler
{
    if (!self.visible) {
        return;
    }
    
    [self.containerViewController hideWithCompletionHandler:completionHandler];
}

- (void)resizeMenuViewControllerToSize:(CGSize)size
{
    [self.containerViewController resizeToSize:size];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if (!self.panGestureEnabled)
        return;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self presentMenuViewControllerWithAnimationAppearance:NO];
    }
    
    [self.containerViewController panGestureRecognized:recognizer];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
