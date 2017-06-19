//
//  SAVORXAPI.h
//  SavorX
//
//  Created by 郭春城 on 16/8/4.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BGUploadRequest.h"

typedef NS_ENUM(NSInteger, handleType) {
    collectHandle = 1, //收藏
    readHandle, //阅读
    shareHandle, //分享
    cancleCollectHandle, //取消收藏
    demandHandle, //点播
    clickHandel = 7, //点击
    allOpenHandle //完全打开量
};

typedef NS_ENUM(NSInteger, interactType) {
    interactDemand = 1, //点播
    interactScreen, //投屏
    interactDiscover //发现
};

@interface SAVORXAPI : NSObject

+ (void)configApplication;

/**
 *  POST网络请求
 *
 *  @param urlStr     请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *  @return NSURLSessionDataTask对象
 */
+ (NSURLSessionDataTask *)postWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask * task, NSDictionary * result))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

/**
 *  GET网络请求
 *
 *  @param urlStr     请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 * @return NSURLSessionDataTask对象
 */
+ (NSURLSessionDataTask *)getWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask * task, NSDictionary * result))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure;

/**
 *  投屏上传图片图片请求
 *
 *  @param urlStr       请求地址
 *  @param data         投屏的图片数据
 *  @param name         投屏的图片名称
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 * @return NSURLSessionDataTask对象
 */
+ (NSURLSessionDataTask *)postImageWithURL:(NSString *)urlStr data:(NSData *)data name:(NSString *)name sliderName:(NSString *)sliderName progress:(void (^)(NSProgress *uploadProgress))progressBlock success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  投屏幻灯片上传信息
 *
 *  @param urlStr       请求地址
 *  @param images         投屏的图片数据
 *  @param name         投屏的图片名称
 *  @param success      请求成功的回调
 *  @param failure      请求失败的回调
 * @return NSURLSessionDataTask对象
 */
+ (NSURLSessionDataTask *)postImageInfoWithURL:(NSString *)urlStr name:(NSString *)name duration:(NSString *)duration  interval:(NSString *)interval  images:(NSArray *)images force:(NSInteger )force success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

/**
 *  展示一个只带确认按钮的信息提示框
 *
 *  @param str 提示信息
 *  @param VC  需要提示的控制器
 */
+ (void)showAlertWithString:(NSString *)str withController:(UIViewController *)VC;

/**
 *  获取最上层试图控制器
 *
 *  @return UIViewController控制器对象
 */
+ (UINavigationController *)getCurrentViewController;


/**
 *  电视机退出投屏点播
 */
+ (void)ScreenDemandShouldBackToTVWithSuccess:(void(^)())successBlock failure:(void(^)())failureBlock;

+ (void)callCodeWithSuccess:(void(^)())successBlock failure:(void(^)())failureBlock;


+ (void)showAlertWithMessage:(NSString *)message;

//投屏成功的铃声
+ (void)successRing;

+ (void)saveFileOnPath:(NSString *)path withDictionary:(NSDictionary *)dict;

+ (void)checkVersionUpgrade;

+ (void)cancelAllURLTask;

@end
