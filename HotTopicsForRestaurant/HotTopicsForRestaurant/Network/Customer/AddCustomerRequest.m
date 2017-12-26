//
//  AddCustomerRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/25.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddCustomerRequest.h"

@implementation AddCustomerRequest

- (instancetype)initWithCustomerInfo:(NSDictionary *)info
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/addCustomer?" stringByAppendingString:[Helper getURLPublic]];
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
