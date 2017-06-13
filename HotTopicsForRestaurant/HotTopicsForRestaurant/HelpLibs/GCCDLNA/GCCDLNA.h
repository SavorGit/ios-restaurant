//
//  GCCDLNA.h
//  DLNATest
//
//  Created by 郭春城 on 16/10/10.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCCDLNA;
@protocol GCCDLNADelegate <NSObject>

@optional
- (void)GCCDLNADidStartSearchDevice:(GCCDLNA *)DLNA;
- (void)GCCDLNADidEndSearchDevice:(GCCDLNA *)DLNA;

@end

@interface GCCDLNA : NSObject

@property (nonatomic, assign) id<GCCDLNADelegate> delegate;
@property (nonatomic, assign) BOOL isSearch;

//停止搜索设备
- (void)stopSearchDevice;

//开始搜索小平台
- (void)startSearchPlatform;

//单例
+ (GCCDLNA *)defaultManager;

@end
