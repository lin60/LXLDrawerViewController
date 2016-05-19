//
//  LXLDrawContainerViewController.m
//  LXLDrawViewController
//
//  Created by Delan on 16/5/18.
//  Copyright © 2016年 xllin. All rights reserved.
//

#import "LXLDrawContainerViewController.h"
#import "LXLDrawViewController.h"

@interface LXLDrawContainerViewController ()

@property (strong, readwrite, nonatomic) UIView *containerView;
@property (assign, readwrite, nonatomic) CGPoint containerOrigin;
@property (strong, readwrite, nonatomic) NSMutableArray *backgroundViews;

@end

@interface LXLDrawViewController ()

@property (assign, readwrite, nonatomic) BOOL visible;
@property (assign, readwrite, nonatomic) CGSize calculatedMenuViewSize;

@end

@implementation LXLDrawContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _backgroundViews = [NSMutableArray array];

    for (int i = 0; i < 4; i ++) {
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectNull];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.0;
        [self.view addSubview:backgroundView];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
        [backgroundView addGestureRecognizer:tapRecognizer];
        
        [_backgroundViews addObject:backgroundView];
    }
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.containerView.clipsToBounds = YES;
    [self.view addSubview:self.containerView];
    
    self.containerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.lxlDrawViewController.backgroundFadeAmount];
    
    
    //将menu.view加到container上 controller加到self上
    if (self.lxlDrawViewController.menuViewController) {
        
        [self addChildViewController:self.lxlDrawViewController.menuViewController];
        self.lxlDrawViewController.menuViewController.view.frame = self.containerView.frame;
        [self.containerView addSubview:self.lxlDrawViewController.menuViewController.view];
        [self.lxlDrawViewController.menuViewController didMoveToParentViewController:self];
    }
    
    [self.view addGestureRecognizer:self.lxlDrawViewController.panGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.lxlDrawViewController.menuViewController.view.frame = self.containerView.bounds;
    
    [self setContainerFrame:CGRectMake(- self.lxlDrawViewController.calculatedMenuViewSize.width, 0, self.lxlDrawViewController.calculatedMenuViewSize.width, self.lxlDrawViewController.calculatedMenuViewSize.height)];

}

- (void)setContainerFrame:(CGRect)frame
{
    //左滑  只有右边的background显示在外
    
    UIView *leftBackgroundView = self.backgroundViews[0];
    UIView *topBackgroundView = self.backgroundViews[1];
    UIView *bottomBackgroundView = self.backgroundViews[2];
    UIView *rightBackgroundView = self.backgroundViews[3];
    
    leftBackgroundView.frame = CGRectMake(0, 0, frame.origin.x, self.view.frame.size.height);
    rightBackgroundView.frame = CGRectMake(frame.size.width + frame.origin.x, 0, self.view.frame.size.width - frame.size.width - frame.origin.x, self.view.frame.size.height);
    
    topBackgroundView.frame = CGRectMake(frame.origin.x, 0, frame.size.width, frame.origin.y);
    bottomBackgroundView.frame = CGRectMake(frame.origin.x, frame.size.height + frame.origin.y, frame.size.width, self.view.frame.size.height);
    
    self.containerView.frame = frame;
}

- (void)setBackgroundViewsAlpha:(CGFloat)alpha
{
    for (UIView *view in self.backgroundViews) {
        
        view.alpha = alpha;
    }
}

- (void)resizeToSize:(CGSize)size
{
    [UIView animateWithDuration:self.lxlDrawViewController.animationDuration animations:^{
        [self setContainerFrame:CGRectMake(0, 0, size.width, size.height)];
        [self setBackgroundViewsAlpha:self.lxlDrawViewController.backgroundFadeAmount];
    } completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)show
{
    void (^completionHandler)(BOOL finished) = ^(BOOL finished) {};
    
    [UIView animateWithDuration:self.lxlDrawViewController.animationDuration animations:^{
        [self setContainerFrame:CGRectMake(0, 0, self.lxlDrawViewController.calculatedMenuViewSize.width, self.lxlDrawViewController.calculatedMenuViewSize.height)];
        [self setBackgroundViewsAlpha:self.lxlDrawViewController.backgroundFadeAmount];
    } completion:completionHandler];

}

- (void)hide
{
    [self hideWithCompletionHandler:nil];
}

- (void)hideWithCompletionHandler:(void(^)(void))completionHandler
{
    void (^completionHandlerBlock)(void) = ^{
    };
    
        [UIView animateWithDuration:self.lxlDrawViewController.animationDuration animations:^{
            [self setContainerFrame:CGRectMake(- self.lxlDrawViewController.calculatedMenuViewSize.width, 0, self.lxlDrawViewController.calculatedMenuViewSize.width, self.lxlDrawViewController.calculatedMenuViewSize.height)];
            [self setBackgroundViewsAlpha:0];
        } completion:^(BOOL finished) {
            self.lxlDrawViewController.visible = NO;
            [self willMoveToParentViewController:nil];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            
            completionHandlerBlock();
        }];
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)recognizer
{
    [self hide];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if (!self.lxlDrawViewController.panGestureEnabled)
        return;
    
    CGPoint point = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.containerOrigin = self.containerView.frame.origin;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.containerView.frame;
            frame.origin.x = self.containerOrigin.x + point.x;
            if (frame.origin.x > 0) {
                frame.origin.x = 0;
                
//                if (!self.lxlDrawViewController.limitMenuViewSize) {
//                    frame.size.width = self.lxlDrawViewController.calculatedMenuViewSize.width + self.containerOrigin.x + point.x;
//                    if (frame.size.width > self.view.frame.size.width)
//                        frame.size.width = self.view.frame.size.width;
//                }
            }
        
        [self setContainerFrame:frame];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
            if ([recognizer velocityInView:self.view].x < 0) {
                [self hide];
            } else {
                [self show];
            }
    }
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
