//
//  LXLNavViewController.m
//  LXLDrawViewController
//
//  Created by Delan on 16/5/19.
//  Copyright © 2016年 xllin. All rights reserved.
//

#import "LXLNavViewController.h"

@interface LXLNavViewController ()

@end

@implementation LXLNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    [self.view addGestureRecognizer:pan];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu
{
    [self.view endEditing:YES];
    [self.lxlDrawViewController.view endEditing:YES];
    [self.lxlDrawViewController presentMenuViewControllerWithAnimationAppearance:YES];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.lxlDrawViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.lxlDrawViewController panGestureRecognized:sender];
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
