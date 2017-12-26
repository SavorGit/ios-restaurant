//
//  AddAddressCustomerRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddAddressCustomerRequest.h"
#import "NSArray+json.h"

@implementation AddAddressCustomerRequest

- (instancetype)initWithCustomers:(NSArray *)customers
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/importNewInfo?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        [self setValue:[customers toReadableJSONString] forParamKey:@"book_info"];
        [self setValue:[GlobalData shared].userModel.invite_id forParamKey:@"invite_id"];
        [self setValue:[GlobalData shared].userModel.telNumber forParamKey:@"mobile"];
    }
    return self;
}

@end
