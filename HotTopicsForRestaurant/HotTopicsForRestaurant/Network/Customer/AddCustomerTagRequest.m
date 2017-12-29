//
//  AddCustomerTagRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddCustomerTagRequest.h"

@implementation AddCustomerTagRequest

- (instancetype)initWithCustomerID:(NSString *)customerID tagName:(NSString *)tagName
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Label/addLabel?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString(customerID)) {
            [self setValue:customerID forParamKey:@"customer_id"];
        }
        [self setValue:tagName forParamKey:@"label_name"];
        [self setValue:[GlobalData shared].userModel.invite_id forParamKey:@"invite_id"];
        [self setValue:[GlobalData shared].userModel.telNumber forParamKey:@"mobile"];
    }
    return self;
}

@end
