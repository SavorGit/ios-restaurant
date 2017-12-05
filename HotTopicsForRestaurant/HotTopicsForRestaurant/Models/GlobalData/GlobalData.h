//
//  GlobalData.h
//  SavorX
//
//  Created by 郭春城 on 16/7/19.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDBoxModel.h"
#import "ResUserModel.h"

typedef enum : NSUInteger {
    RDSceneHaveRDBox,
    RDSceneHaveDLNA,
    RDSceneNothing,
} RDScene;

typedef enum : NSUInteger {
    RDNetworkStatusUnknown = -1,
    RDNetworkStatusNotReachable = 0,
    RDNetworkStatusReachableViaWWAN = 1,
    RDNetworkStatusReachableViaWiFi = 2,
} RDNetworkStatus;

extern NSString * const RDDidBindDeviceNotification; //已经连接至设备
extern NSString * const RDDidDisconnectDeviceNotification; //已经断开连接
extern NSString * const RDDidFoundHotelIdNotification; //发现了新的酒楼ID
extern NSString * const RDDidNotFoundSenceNotification; //进入了没有设备的环境
extern NSString * const RDDidFoundBoxSenceNotification; //进入了机顶盒设备环境

extern NSString * const RDStopSearchDeviceNotification; //搜索设备结束
extern NSString * const RDQiutScreenNotification; //结束投屏
extern NSString * const RDBoxQuitScreenNotification; //机顶盒通知退出投屏
extern NSString * const RDNetWorkStatusDidBecomeReachableViaWiFi; //机顶盒通知退出投屏

extern NSString * const RDUserLoginStatusChangeNotification; //用户登录状态发生改变

@interface GlobalData : NSObject 

// 本地服务器信息
@property (nonatomic, strong)NSMutableDictionary *serverDic;

//当前是否绑定机顶盒
@property (nonatomic, assign) BOOL isBindRD;

//当前绑定的机顶盒
@property (nonatomic, strong) RDBoxModel * RDBoxDevice;

//机顶盒地址
@property (nonatomic, strong) NSString * boxUrlStr;

//当前网络状态
@property (nonatomic, assign) NSInteger networkStatus;

//存储小平台呼出二维码地址
@property (nonatomic, copy) NSString * callQRCodeURL;

//存储二级小平台呼出二维码地址
@property (nonatomic, copy) NSString * secondCallCodeURL;

//存储三级小平台呼出二维码地址
@property (nonatomic, copy) NSString * thirdCallCodeURL;

//存储机顶盒呼出二维码地址
@property (nonatomic, copy) NSString * boxCodeURL;

//热点当前场景
@property (nonatomic, assign) RDScene scene;

//当前酒楼ID
@property (nonatomic, assign) NSInteger hotelId;

//区域ID
@property (nonatomic, copy) NSString * areaId;

//当前缓存的机顶盒信息
@property (nonatomic, strong) RDBoxModel * cacheModel;

//当前机顶盒的操作唯一标识
@property (nonatomic, copy) NSString * projectId;

//设备唯一标识
@property (nonatomic, copy) NSString * deviceID;

//记录APNS注册的推送token
@property (nonatomic, strong) NSString * deviceToken;

@property (nonatomic, assign) double latitude;

@property (nonatomic, assign) double longitude;

@property (nonatomic, strong) ResUserModel * userModel;

@property (nonatomic, strong) NSArray * boxSource;

/**
 *  创建单例
 *
 *  @return GlobalData
 */
+ (GlobalData *)shared;

/**
 *  连接到小热点机顶盒设备
 *
 *  param 连接到机顶盒的Box模型信息
 */
- (void)bindToRDBoxDevice:(RDBoxModel *)model;

/**
 *  断开当前的设备连接
 */
- (void)disconnect;

- (void)loginWith:(ResUserModel *)model;

@end
