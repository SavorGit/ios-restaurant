//
//  GetInviHotelRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetInviHotelRequest.h"

@implementation GetInviHotelRequest

- (instancetype)initWithInviCode:(NSString *)inviCode mobile:(NSString *)mobile veriCode:(NSString *)veriCode
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp/login/getHotelInfo?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:inviCode forParamKey:@"invite_code"];
        [self setValue:mobile forParamKey:@"mobile"];
        [self setValue:veriCode forParamKey:@"verify_code"];
    }
    return self;
}

@end
