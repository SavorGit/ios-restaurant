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
#import "FirstAddCustomerAlert.h"
#import "MultiSelectAddressController.h"
#import "RDAddressManager.h"

@interface ResTabbarController ()

@end

@implementation ResTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray * vcClass = @[[ReserveHomeViewController class], [CustomerViewController class], [RestaurantHomePageViewController class]];
   
    NSArray * titles = @[@"预定", @"客户", @"投屏"];
    NSArray * imageArray = @[@"yd", @"kh", @"tabbar_tp"];
    NSArray * selectArray = @[@"yd_dj", @"kh_dj", @"tabbar_tp_dj"];
    NSMutableArray * vcs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < vcClass.count; i++) {
        UIViewController * vc = [[vcClass[i] alloc] init];
        UIImage * image = [[UIImage imageNamed:imageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectImage = [[UIImage imageNamed:selectArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:image selectedImage:selectImage];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : kPingFangRegular(10), NSForegroundColorAttributeName : UIColorFromRGB(0x616161)} forState:UIControlStateNormal];
        [vc.tabBarItem setTitleTextAttributes:@{NSFontAttributeName : kPingFangRegular(10), NSForegroundColorAttributeName : UIColorFromRGB(0x922c3e)} forState:UIControlStateSelected];
        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        vc.title = [titles objectAtIndex:i];
        ReBaseNavigationController * na = [[ReBaseNavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:na];
    }
    [self setViewControllers:vcs];
    
    [self performSelector:@selector(checkFirstAlert) withObject:nil afterDelay:.5f];
    [[RDAddressManager manager] checkCustomerFailHandle];
}

- (void)checkFirstAlert
{
    BOOL hasUpload = [[NSUserDefaults standardUserDefaults] objectForKey:kHasAlertUploadCustomer];
    if (!hasUpload && ![[GlobalData shared].userModel.is_import_customer isEqualToString:@"1"]) {
        FirstAddCustomerAlert * alert = [[FirstAddCustomerAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        alert.block = ^{
            
            ReBaseNavigationController * na = [self.viewControllers objectAtIndex:self.selectedIndex];
            MultiSelectAddressController * address = [[MultiSelectAddressController alloc] init];
            [na pushViewController:address animated:YES];
            
        };
        
        [alert show];
    }
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
