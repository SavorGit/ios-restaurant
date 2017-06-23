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
#import "DefalutLaunchViewController.h"
#import "ResConnectViewController.h"
#import "SAVORXAPI.h"

@interface AppDelegate ()

@property (nonatomic, copy) NSString * ssid;

@end

@implementation AppDelegate


// test git
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createLaunch];
    //配置APP相关信息
    [SAVORXAPI configApplication];
    // Override point for customization after application launch.
    return YES;
}

// 启动程序
- (void)createLaunch{
    
    DefalutLaunchViewController * defalut = [[DefalutLaunchViewController alloc] init];
    defalut.playEnd = ^(){
        RestaurantHomePageViewController *rhVC = [[RestaurantHomePageViewController alloc] init];
        ReBaseNavigationController *navi = [[ReBaseNavigationController alloc]initWithRootViewController:rhVC];
        self.window.rootViewController = navi;
        
        [self monitorInternet]; //监控网络状态
    };
    self.window.rootViewController = defalut;
    [self.window makeKeyAndVisible];
}


#pragma mark -- 监控网络状态
- (void)monitorInternet
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            [GlobalData shared].networkStatus = RDNetworkStatusUnknown;
            [[GCCDLNA defaultManager] stopSearchDeviceWithNetWorkChange];
        }else if (status == AFNetworkReachabilityStatusNotReachable) {
            [GlobalData shared].networkStatus = RDNetworkStatusNotReachable;
            [[GCCDLNA defaultManager] stopSearchDeviceWithNetWorkChange];
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [GlobalData shared].networkStatus = RDNetworkStatusReachableViaWiFi;
            [[GCCDLNA defaultManager] startSearchPlatform];
            [[NSNotificationCenter defaultCenter] postNotificationName:RDNetWorkStatusDidBecomeReachableViaWiFi object:nil];
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            [GlobalData shared].networkStatus = RDNetworkStatusReachableViaWWAN;
            [[GCCDLNA defaultManager] stopSearchDeviceWithNetWorkChange];
        }else{
            [GlobalData shared].networkStatus = RDNetworkStatusUnknown;
            [[GCCDLNA defaultManager] stopSearchDeviceWithNetWorkChange];
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
        self.ssid = [Helper getWifiName];
        [[GCCDLNA defaultManager] applicationWillTerminate];
    }else{
        self.ssid = @"";
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (!isEmptyString(self.ssid)) {
        if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
            if ([GlobalData shared].scene == RDSceneHaveRDBox) {
                if (![self.ssid isEqualToString:[Helper getWifiName]]) {
                    [[GCCDLNA defaultManager] startSearchPlatform];
                }
            }else{
                [[GCCDLNA defaultManager] startSearchPlatform];
            }
        }
    }else if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
        [[GCCDLNA defaultManager] startSearchPlatform];
    }
    
    if ([GlobalData shared].cacheModel) {
        NSString * ssid = [GlobalData shared].cacheModel.sid;
        if ([ssid isEqualToString:[Helper getWifiName]]) {
            [[GlobalData shared] bindToRDBoxDevice:[GlobalData shared].cacheModel];
            [GlobalData shared].cacheModel = nil;
            if ([self.window.rootViewController isKindOfClass:[ReBaseNavigationController class]]) {
                ReBaseNavigationController * na = (ReBaseNavigationController *)self.window.rootViewController;
                if ([na.topViewController isKindOfClass:[ResConnectViewController class]]) {
                    [na popViewControllerAnimated:YES];
                }
            }
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[GCCDLNA defaultManager] applicationWillTerminate];
}


@end
