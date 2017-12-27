//
//  upLoadConsumeTickRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "upLoadConsumeTickRequest.h"

@implementation upLoadConsumeTickRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic{
    
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Customer/addConsumeRecord?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString([dataDic objectForKey:@"customer_id"])) {
            [self setValue:[dataDic objectForKey:@"customer_id"] forParamKey:@"customer_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"invite_id"])) {
            [self setValue:[dataDic objectForKey:@"invite_id"] forParamKey:@"invite_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"mobile"])) {
            [self setValue:[dataDic objectForKey:@"mobile"] forParamKey:@"mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"order_id"])) {
            [self setValue:[dataDic objectForKey:@"order_id"] forParamKey:@"order_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"recipt"])) {
            [self setValue:[dataDic objectForKey:@"recipt"] forParamKey:@"recipt"];
        }
        
    }
    return self;
    
}

@end
