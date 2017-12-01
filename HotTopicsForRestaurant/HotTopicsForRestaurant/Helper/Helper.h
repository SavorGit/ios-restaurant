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

//获取当前时间
+ (NSInteger)getCurrentTime;

//获取不同机型的开屏图
+ (UIImage *)getLaunchImage;

//获取当前时间戳
+(NSString *)getTimeStamp;

//获取当前13位时间戳
+(NSString *)getTimeStampMS;

/**获取当前wifi的名字**/
+ (NSString *)getWifiName;

+ (BOOL)isWifiStatus;

+ (CGFloat)autoWidthWith:(CGFloat)width;

+ (CGFloat)autoHeightWith:(CGFloat)height;

+ (NSString *)getMd5_32Bit:(NSString *)mdStr;

+ (NSString *)getURLPublic;

+ (NSString *)getHTTPHeaderValue;

+ (NSString *)getCurrentTimeWithFormat:(NSString *)format;

+ (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

+ (NSString *)transformDate:(NSDate *)date;

+ (void)showTextHUDwithTitle:(NSString *)title delay:(CGFloat)delay;

// 字典转JSON
+ (NSString *)convertToJsonData:(NSDictionary *)dict;

+ (UILabel *)labelWithFrame:(CGRect)frame TextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)Alignment;

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title;

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title cornerRadius:(CGFloat)cornerRadius;

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder titleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor leftView:(UIView *)leftView rightView:(UIView *)rightView clearButtonMode:(UITextFieldViewMode)clearButtonMode;

+ (void)saveFileOnPath:(NSString *)path withArray:(NSArray *)array;

+ (void)saveFileOnPath:(NSString *)path withDictionary:(NSDictionary *)dict;

+ (void)removeFileOnPath:(NSString *)path;

@end
