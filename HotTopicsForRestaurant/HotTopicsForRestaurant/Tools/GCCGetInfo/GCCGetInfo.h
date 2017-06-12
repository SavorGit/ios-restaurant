//
//  GCCGetInfo.h
//  GCCToolCreate
//
//  Created by 郭春城 on 16/4/11.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  用于获取系统相关信息
 */
@interface GCCGetInfo : NSObject

//获取应用IDFV，即UUID
+ (NSString *)getIDFVUUID;

//获取设备名称 例：xxx的iPhone
+ (NSString *)getIphoneName;

//获取系统版本 例：9.3.3
+ (NSString *)getIphoneSystemVersion;

//获取系统名称 例：iPhone OS
+ (NSString *)getIphoneSystemName;

//获取系统 例：iPhone OS4.2.1
+ (NSString *)getIphoneSystem;

//获取设备模式 例：iPhone
+ (NSString *)getIphoneModel;

//获取本地设备模式 类似model
+ (NSString *)getIphoneLocalizedModel;

//获取APP应用名称
+ (NSString *)getLocalAPPName;

//获取APP本地版本
+ (NSString *)getLocalAppVersion;

//获取系统当前时间
+ (NSInteger)getCurrentTime;

//获取手机设备名称 例：iPhone6S
+ (NSString *)getDeviceName;

@end
