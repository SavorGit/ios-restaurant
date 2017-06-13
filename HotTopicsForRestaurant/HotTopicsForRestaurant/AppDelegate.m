//
//  AppDelegate.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/9.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AppDelegate.h"
#import "RestaurantHomePageViewController.h"
#import "ReBaseNavigationController.h"
#import "SAVORXAPI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


// test git
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    [self createLaunch];
    //配置APP相关信息
    [SAVORXAPI configApplication];
    // Override point for customization after application launch.
    return YES;
}

// 启动程序
- (void)createLaunch{
    
    RestaurantHomePageViewController *rhVC = [[RestaurantHomePageViewController alloc] init];
    ReBaseNavigationController *navi = [[ReBaseNavigationController alloc]initWithRootViewController:rhVC];
    self.window.rootViewController = navi;
    
    [self monitorInternet]; //监控网络状态
    
    [self.window makeKeyAndVisible];
}


#pragma mark -- 监控网络状态
- (void)monitorInternet
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            [GlobalData shared].networkStatus = RDNetworkStatusUnknown;
        }else if (status == AFNetworkReachabilityStatusNotReachable) {

            [[GCCDLNA defaultManager] stopSearchDevice];
            [GlobalData shared].networkStatus = RDNetworkStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [GlobalData shared].networkStatus = RDNetworkStatusReachableViaWiFi;
            [[GCCDLNA defaultManager] startSearchPlatform];
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            [GlobalData shared].networkStatus = RDNetworkStatusReachableViaWWAN;
            [[GCCDLNA defaultManager] stopSearchDevice];
        }else{
            [GlobalData shared].networkStatus = RDNetworkStatusUnknown;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
