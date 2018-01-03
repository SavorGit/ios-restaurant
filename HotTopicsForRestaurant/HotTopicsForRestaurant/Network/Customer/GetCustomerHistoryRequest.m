//
//  GetCustomerHistoryRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "GetCustomerHistoryRequest.h"

@implementation GetCustomerHistoryRequest

- (instancetype)init;
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/getCustomerHistory?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        [self setValue:[GlobalData shared].userModel.invite_id forParamKey:@"invite_id"];
        [self setValue:[GlobalData shared].userModel.telNumber forParamKey:@"mobile"];
    }
    return self;
}

@end
