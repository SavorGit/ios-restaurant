//
//  Helper.h
//  HotSpot
//
//  Created by lijiawei on 16/12/8.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject


/**
 @brief 是否是空字符串
 */
+ (BOOL) isBlankString:(NSString *)string;

+ (UINavigationController *)getRootNavigationController;

+ (UIViewController *)getCurrentControllerInWMPage;

//获取当前时间
+ (NSInteger)getCurrentTime;

//获取不同机型的开屏图
+ (UIImage *)getLaunchImage;

//获取当前时间戳
+(NSString *)getTimeStamp;

//获取当前13位时间戳
+(NSString *)getTimeStampMS;

/** 获取NSBundele中的资源图片 */
+ (UIImage *)imageAtApplicationDirectoryWithName:(NSString *)fileName;

/**获取当前wifi的名字**/
+ (NSString *)getWifiName;

+ (BOOL)isWifiStatus;

+ (CGFloat)autoWidthWith:(CGFloat)width;

+ (CGFloat)autoHeightWith:(CGFloat)height;

+ (CGFloat)autoHomePageCellImageHeight;

+ (CGFloat)autoHomePageCellTitleLabelHeight;

+ (NSString *)getImageNameWithPath:(NSString *)path;

+ (NSString *)getVideoNameWithPath:(NSString *)path;

+ (UIView *)createHomePageSecondHelp;

+ (NSString *)getMd5_32Bit:(NSString *)mdStr;

+ (NSString *)getURLPublic;

+ (NSString *)getHTTPHeaderValue;

+ (NSString *)getCurrentTimeWithFormat:(NSString *)format;

+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

@end
