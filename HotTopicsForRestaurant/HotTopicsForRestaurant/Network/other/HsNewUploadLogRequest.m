//
//  HsNewUploadLogRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HsNewUploadLogRequest.h"

@implementation HsNewUploadLogRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp/Touping/reportLog?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        [self setValue:[NSString stringWithFormat:@"%ld",[GlobalData shared].hotelId] forParamKey:@"hotel_id"];
        
        if (!isEmptyString([GlobalData shared].userModel.inviCode)) {
            [self setValue:[GlobalData shared].userModel.inviCode forParamKey:@"invite_code"];
        }
        if (!isEmptyString([GlobalData shared].userModel.telNumber)) {
            [self setValue:[GlobalData shared].userModel.telNumber forParamKey:@"mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"room_id"])) {
            [self setValue:[dataDic objectForKey:@"room_id"] forParamKey:@"room_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"screen_num"])) {
            [self setValue:[dataDic objectForKey:@"screen_num"] forParamKey:@"screen_num"];
        }
        if (!isEmptyString([dataDic objectForKey:@"screen_result"])) {
            [self setValue:[dataDic objectForKey:@"screen_result"] forParamKey:@"screen_result"];
        }
        if (!isEmptyString([dataDic objectForKey:@"screen_time"])) {
            [self setValue:[dataDic objectForKey:@"screen_time"] forParamKey:@"screen_time"];
        }
        if (!isEmptyString([dataDic objectForKey:@"screen_type"])) {
            [self setValue:[dataDic objectForKey:@"screen_type"] forParamKey:@"screen_type"];
        }
        
        // 选填
        if (!isEmptyString([dataDic objectForKey:@"welcome_template"])) {
            [self setValue:[dataDic objectForKey:@"welcome_template"] forParamKey:@"welcome_template"];
        }
        if (!isEmptyString([dataDic objectForKey:@"welcome_word"])) {
            [self setValue:[dataDic objectForKey:@"welcome_word"] forParamKey:@"welcome_word"];
        }
        if (!isEmptyString([dataDic objectForKey:@"info"])) {
            [self setValue:[dataDic objectForKey:@"info"] forParamKey:@"info"];
        }
    }
    return self;
}

@end
