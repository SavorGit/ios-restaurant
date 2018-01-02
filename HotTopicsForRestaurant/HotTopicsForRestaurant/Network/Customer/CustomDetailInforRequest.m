//
//  CustomDetailInforRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "CustomDetailInforRequest.h"

@implementation CustomDetailInforRequest

- (instancetype)initWithParamData:(NSDictionary *)dataDic;
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/getCustomerBaseInfo?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString([dataDic objectForKey:@"invite_id"])) {
            [self setValue:[dataDic objectForKey:@"invite_id"] forParamKey:@"invite_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"mobile"])) {
            [self setValue:[dataDic objectForKey:@"mobile"] forParamKey:@"mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"customer_id"])) {
            [self setValue:[dataDic objectForKey:@"customer_id"] forParamKey:@"customer_id"];
        }
    }
    return self;
}

@end
