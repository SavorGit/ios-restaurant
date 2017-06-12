//
//  GCCUPnPManager.h
//  DLNATest
//
//  Created by 郭春城 on 16/10/11.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"

@interface GCCUPnPManager : NSObject

+ (GCCUPnPManager *)defaultManager;

- (instancetype)initWithDeviceModel:(DeviceModel *)device;

- (void)setDeviceModel:(DeviceModel *)device;

- (void)setAVTransportURL:(NSString *)url Success:(void(^)())successBlock failure:(void(^)())failureBlock;

- (void)playSuccess:(void(^)())successBlock failure:(void(^)())failureBlock;

- (void)pauseSuccess:(void(^)())successBlock failure:(void(^)())failureBlock;

- (void)stopSuccess:(void(^)())successBlock failure:(void(^)())failureBlock;

- (void)getVolumeSuccess:(void(^)(NSInteger volume))successBlock failure:(void(^)())failureBlock;

- (void)setVolume:(NSInteger)volume Success:(void(^)())successBlock failure:(void(^)())failureBlock;

- (void)getPlayProgressSuccess:(void(^)(NSString *totalDuration, NSString *currentDuration, float progress))successBlock failure:(void(^)())failureBlock;

- (void)seekProgressTo:(NSInteger)progress success:(void(^)())successBlock failure:(void(^)())failureBlock;

- (NSString *)timeStringFromInteger:(NSInteger)seconds;
- (NSInteger)timeIntegerFromString:(NSString *)string;

@end
