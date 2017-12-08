//
//  GCCDLNA.h
//  DLNATest
//
//  Created by 郭春城 on 16/10/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCCDLNA : NSObject

@property (nonatomic, assign) BOOL isSearch;

//停止搜索设备
- (void)stopSearchDeviceWithNetWorkChange;

//开始搜索小平台
- (void)startSearchPlatform;

- (void)applicationWillTerminate;

//获取包间列表
- (void)getBoxInfoList;

//单例
+ (GCCDLNA *)defaultManager;

@end
