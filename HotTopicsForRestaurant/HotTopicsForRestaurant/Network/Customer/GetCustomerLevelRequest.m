//
//  GetCustomerLevelRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetCustomerLevelRequest.h"

@implementation GetCustomerLevelRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/getConAbility?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
