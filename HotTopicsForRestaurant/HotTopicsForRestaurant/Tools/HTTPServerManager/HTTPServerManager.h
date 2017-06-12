//
//  HTTPServerManager.h
//  SavorX
//
//  Created by 郭春城 on 16/8/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPServerManager : NSObject

/**
 *  获取当前httpserver对象的IP
 *
 *  @return HTTPServer对象的IP
 */
+ (NSString *)getCurrentHTTPServerIP;

/**
 *  检测当前httpserver是不是在wifi环境下
 *
 *  @return YES or NO
 */
+ (BOOL)checkHttpServerIsWifi;

/**
 *  检测当前是否在同一个网段
 *
 *  @param boxIP 机顶盒的IP地址
 *
 *  @return 返回YES or NO
 */
+ (BOOL)checkHttpServerWithBoxIP:(NSString *)boxIP;

/**
*  检测当前是否在同一个网段
*
*  @param DLNAIP DLNA的IP地址
*
*  @return 返回YES or NO
 */
+ (BOOL)checkHttpServerWithDLNAIP:(NSString *)DLNAIP;

/**
 *  检测当前网络环境是ipv4还是ipv6
 *
 *  @return YES or NO
 */
+ (BOOL)isIpv4;

/**
 *  获取手机IP
 *
 *  @return 获取手机IP
 */
+ (NSString *)deviceIPAdress;

@end
