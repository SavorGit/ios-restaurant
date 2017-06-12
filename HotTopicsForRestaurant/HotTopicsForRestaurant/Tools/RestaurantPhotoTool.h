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

//获取幻灯片列表
+ (NSArray *)getSliderList;

@end
