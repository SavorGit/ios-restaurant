//
//  ReserveOrderListRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveOrderListRequest.h"

@implementation ReserveOrderListRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Order/getOrderList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString([dataDic objectForKey:@"invite_id"])) {
            [self setValue:[dataDic objectForKey:@"invite_id"] forParamKey:@"invite_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"mobile"])) {
            [self setValue:[dataDic objectForKey:@"mobile"] forParamKey:@"mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"order_date"])) {
            [self setValue:[dataDic objectForKey:@"order_date"] forParamKey:@"order_date"];
        }

        // 选填
        if (!isEmptyString([dataDic objectForKey:@"page_num"])) {
            [self setValue:[dataDic objectForKey:@"page_num"] forParamKey:@"page_num"];
        }
        
    }
    return self;
}

@end
