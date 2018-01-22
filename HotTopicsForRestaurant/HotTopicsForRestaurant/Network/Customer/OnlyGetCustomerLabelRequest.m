//
//  OnlyGetCustomerLabelRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "OnlyGetCustomerLabelRequest.h"

@implementation OnlyGetCustomerLabelRequest

- (instancetype)initWithCustomerID:(NSString *)customerID
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/getOnlyLabel?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString(customerID)) {
            [self setValue:customerID forParamKey:@"customer_id"];
        }
        
        [self setValue:[GlobalData shared].userModel.invite_id forParamKey:@"invite_id"];
        [self setValue:[GlobalData shared].userModel.telNumber forParamKey:@"mobile"];
    }
    return self;
}

@end
