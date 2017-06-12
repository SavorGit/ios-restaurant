//
//  MBProgressHUD+Custom.h
//  SavorX
//
//  Created by 郭春城 on 16/8/8.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "MBProgressHUD.h"
#import <Photos/Photos.h>

@interface MBProgressHUD (Custom)

/**
 *  二维码扫描界面初始化等待框
 *
 *  @param view 需要显示等待框的界面
 *
 *  @return 一个MBProgressHUD对象
 */
+ (MBProgressHUD *)showLoadingHUDInView:(UIView *)view;

/**
 *  正在加载的等待框
 *
 *  @param view 需要显示等待框的界面
 *
 *  @return 一个MBProgressHUD对象
 */
+ (MBProgressHUD *)showCustomLoadingHUDInView:(UIView *)view;

/**
 *  等待加载的等待框
 *
 *  @param view  需要显示等待框的界面
 *  @param title 需要显示的标题
 *
 *  @return 一个MBProgressHUD对象
 */
+ (MBProgressHUD *)showCustomLoadingHUDInView:(UIView *)view withTitle:(NSString *)title;

/**
 *  等待进度的一个圆形进度条
 *
 *  @param view     需要显示进度条的界面
 *  @param pregress 显示的进度
 *
 *  @return 一个MBProgressHUD对象
 */
+ (MBProgressHUD *)showProgressLoadingHUDInView:(UIView *)view;

/**
 *  等待删除缓存的一个圆形进度条
 *
 *  @param view     需要显示进度条的界面
 *  @param pregress 显示的进度
 *
 *  @return 一个MBProgressHUD对象
 */
+ (MBProgressHUD *)showDeleteCacheHUDInView:(UIView *)view;

/**
 *  显示一个带对号的提示框
 *
 *  @param view  需要显示的界面
 *  @param title 显示的标题
 *
 *  @return 一个MBProgressHUD对象
 */
+ (MBProgressHUD *)showSuccessHUDInView:(UIView *)view title:(NSString *)title;

/**
 *  显示一个纯文本的提示框
 *
 *  @param title 显示的标题
 *
 */
+ (void)showTextHUDwithTitle:(NSString *)title;

/**
 *  显示一个纯文本的提示框
 *
 *  @param title 显示的标题
 *  @param delay 显示的时长
 *
 */
+ (void)showTextHUDwithTitle:(NSString *)title delay:(CGFloat)delay;

/**
 *  显示一个网络状态纯文本的提示框
 *
 *  @param title 显示的标题
 *  @param delay 显示的时长
 *
 */
+ (void)showNetworkStatusTextHUDWithTitle:(NSString *)title delay:(CGFloat)delay;

/**
 *  显示一个长时间的纯文本的提示框
 *
 *  @param view  需要显示的界面
 *  @param title 显示的标题
 *
 */
+ (void)showLongTimeTextHUDInView:(UIView *)view title:(NSString *)title;

/**
 *  显示一个H5加载等待效果图
 *
 */
+ (MBProgressHUD *)showWebLoadingHUDInView:(UIView *)view;

+ (MBProgressHUD *)showBackDemandInView:(UIView *)view;

+ (void)removeTextHUD;

@end
