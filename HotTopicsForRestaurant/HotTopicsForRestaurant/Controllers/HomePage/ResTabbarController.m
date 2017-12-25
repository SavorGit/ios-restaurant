//
//  ResTabbarController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResTabbarController.h"
#import "CustomerViewController.h"
#import "RestaurantHomePageViewController.h"
#import "ReBaseNavigationController.h"
#import "ReserveHomeViewController.h"

@interface ResTabbarController ()

@end

@implementation ResTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray * vcClass = @[[ReserveHomeViewController class], [CustomerViewController class], [RestaurantHomePageViewController class], [UIViewController class]];
    NSArray * titles = @[@"预定", @"客户", @"服务", @"我的"];
    NSMutableArray * vcs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < vcClass.count; i++) {
        UIViewController * vc = [[vcClass[i] alloc] init];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:[UIImage new] selectedImage:[UIImage new]];
        vc.title = [titles objectAtIndex:i];
        ReBaseNavigationController * na = [[ReBaseNavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:na];
    }
    [self setViewControllers:vcs];
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
