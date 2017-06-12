//
//  GCCKeyChain.h
//  SavorX
//
//  Created by 郭春城 on 16/1/25.
//  Copyright © 2016年 com.savor.savorx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCCKeyChain : NSObject

/**
 *  存储信息
 *
 *  @param service 信息的标识，key
 *  @param data    信息的内容，value，需要转成data
 */
+ (void)save:(NSString *)service data:(id)data;

/**
 *  加载信息
 *
 *  @param service 信息的标识，key
 *
 *  @return 信息的内容，value，需要转成data
 */
+ (id)load:(NSString *)service;

/**
 *  删除信息
 *
 *  @param service 信息的标识，key
 */
+ (void)deleteDataForKey:(NSString *)service;

@end
