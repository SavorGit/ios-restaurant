//
//  HSWebServerManager.h
//  SavorX
//
//  Created by 郭春城 on 16/12/14.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "GCDWebServer.h"

@interface HSWebServerManager : NSObject

@property GCDWebServer *webServer;

//单例
+ (instancetype)manager;

//开始配置httpServer服务器

//停止服务
- (void)stop;

@end
