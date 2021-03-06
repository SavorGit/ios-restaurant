//
//  RestaurantPhotoTool.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void(^ResSuccess)(NSDictionary * item);
typedef void(^ResFailed)(NSError * error);
@interface RestaurantPhotoTool : NSObject

+ (void)loadPHAssetWithHander:(void(^)(NSArray *result))success;

+ (UIImage *)makeThumbnailOfSize:(CGSize)size image:(UIImage *)img;

//添加幻灯片
+ (void)addSliderItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed;

//更新幻灯片的图片组
+ (void)updateSliderItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed;

//删除幻灯片条目
+ (void)removeSliderItemWithTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed;

//检查用户是否开启相机权限
+ (void)checkUserLibraryAuthorizationStatusWithSuccess:(void(^)())success failure:(ResFailed)failure;

+ (NSDictionary *)createSliderItemWithArray:(NSArray *)array title:(NSString *)title;

//获取幻灯片列表
+ (NSArray *)getSliderList;

//返回处理后的图片
+ (void)compressImageWithImage:(UIImage *)image compression:(CGFloat)compression finished:(void (^)(NSData *))finished;

//获取视频集合列表
+ (NSArray *)getVideoList;

+ (void)addSliderVideoItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed;

+ (void)updateSliderVideoItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed;

+ (void)removeSliderVideoItemWithTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed;

+ (NSDictionary *)createSliderVideoItemWithArray:(NSArray *)array title:(NSString *)title;

/**
 *  从PHAsset中导出对应视频对象
 *
 *  @param asset          PHAsset资源对象
 *  @param startHandler   开始导出视频的回调，session是导出类的相关信息
 *  @param endHandler     结束导出视频的回调，path表示导出的路径，session是导出类的相关信息
 *  @param type           视频导出的质量
 */
+ (void)exportVideoToMP4WithAsset:(PHAsset *)videoAsset startHandler:(void (^)(AVAssetExportSession * session))startHandler endHandler:(void (^)(NSString * path, AVAssetExportSession * session))endHandler exportPresetType:(NSString *)type;

@end
