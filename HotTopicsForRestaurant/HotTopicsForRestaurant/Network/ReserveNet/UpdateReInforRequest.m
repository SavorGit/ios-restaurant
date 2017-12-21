//
//  UpdateReInforRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UpdateReInforRequest.h"

@implementation UpdateReInforRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic{
    
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Order/upateOrderService?" stringByAppendingString:[Helper getURLPublic]];
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
        // 1欢迎词 2推荐菜 3消费小票
        if (!isEmptyString([dataDic objectForKey:@"type"])) {
            [self setValue:[dataDic objectForKey:@"type"] forParamKey:@"type"];
        }
        
        // 小票URL 选填
        if (!isEmptyString([dataDic objectForKey:@"ticket_url"])) {
            [self setValue:[dataDic objectForKey:@"ticket_url"] forParamKey:@"ticket_url"];
        }
        
    }
    return self;
    
}

@end
