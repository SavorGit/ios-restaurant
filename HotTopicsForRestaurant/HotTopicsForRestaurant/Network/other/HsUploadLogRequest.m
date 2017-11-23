//
//  HsUploadLogRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HsUploadLogRequest.h"
#import "Helper.h"

@implementation HsUploadLogRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp/Touping/reportLog?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString([dataDic objectForKey:@"device_id"])) {
            [self setValue:[dataDic objectForKey:@"device_id"] forParamKey:@"device_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"hotel_id"])) {
            [self setValue:[dataDic objectForKey:@"hotel_id"] forParamKey:@"hotel_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"room_id"])) {
            [self setValue:[dataDic objectForKey:@"room_id"] forParamKey:@"room_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"screen_type"])) {
            [self setValue:[dataDic objectForKey:@"screen_type"] forParamKey:@"screen_type"];
        }
        
        // 选填
        if (!isEmptyString([dataDic objectForKey:@"ads_type"])) {
            [self setValue:[dataDic objectForKey:@"ads_type"] forParamKey:@"ads_type"];
        }
        if (!isEmptyString([dataDic objectForKey:@"device_type"])) {
            [self setValue:[dataDic objectForKey:@"device_type"] forParamKey:@"device_type"];
        }
        if (!isEmptyString([dataDic objectForKey:@"info"])) {
            [self setValue:[dataDic objectForKey:@"info"] forParamKey:@"info"];
        }
        if (!isEmptyString([dataDic objectForKey:@"screen_num"])) {
            [self setValue:[dataDic objectForKey:@"screen_num"] forParamKey:@"screen_num"];
        }
        if (!isEmptyString([dataDic objectForKey:@"screen_time"])) {
            [self setValue:[dataDic objectForKey:@"screen_time"] forParamKey:@"screen_time"];
        }
        if (!isEmptyString([dataDic objectForKey:@"state"])) {
            [self setValue:[dataDic objectForKey:@"state"] forParamKey:@"state"];
        }
        if (!isEmptyString([dataDic objectForKey:@"wifi"])) {
            [self setValue:[dataDic objectForKey:@"wifi"] forParamKey:@"wifi"];
        }
        
    }
    return self;
}

@end
