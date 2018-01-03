//
//  ModifyCustomerRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "ModifyCustomerRequest.h"

@implementation ModifyCustomerRequest

- (instancetype)initWithCustomerInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/editCustomer?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        for (NSString * key in info.allKeys) {
            [self setValue:[info objectForKey:key] forParamKey:key];
        }
        [self setValue:[GlobalData shared].userModel.invite_id forParamKey:@"invite_id"];
        [self setValue:[GlobalData shared].userModel.telNumber forParamKey:@"mobile"];
    }
    return self;
}

@end
