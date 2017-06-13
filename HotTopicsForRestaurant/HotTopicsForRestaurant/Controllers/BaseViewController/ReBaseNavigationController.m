//
//  ReBaseNavigationController.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/6/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReBaseNavigationController.h"

@interface ReBaseNavigationController ()

@end

@implementation ReBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImage *image = [UIImage imageWithColor:kNavBackGround size:CGSizeMake(kMainBoundsWidth, kNaviBarHeight + kStatusBarHeight)];
//    [[UINavigationBar appearanceWhenContainedIn:[ReBaseNavigationController class], nil] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
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

@end
