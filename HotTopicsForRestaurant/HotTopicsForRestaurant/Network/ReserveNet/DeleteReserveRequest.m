//
//  DeleteReserveRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "DeleteReserveRequest.h"

@implementation DeleteReserveRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic{
  
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Order/deleteOrder?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString([dataDic objectForKey:@"invite_id"])) {
            [self setValue:[dataDic objectForKey:@"invite_id"] forParamKey:@"invite_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"mobile"])) {
            [self setValue:[dataDic objectForKey:@"mobile"] forParamKey:@"mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"order_id"])) {
            [self setValue:[dataDic objectForKey:@"order_id"] forParamKey:@"order_id"];
        }
        
    }
    return self;
    
}

@end
