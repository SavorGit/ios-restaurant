//
//  AddReserveRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddReserveRequest.h"

@implementation AddReserveRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic withType:(NSInteger )type;
{
    if (self = [super init]) {

        if (type == 0) {
            self.methodName = [@"Dinnerapp2/Order/addOrder?" stringByAppendingString:[Helper getURLPublic]];
        }else{
            self.methodName = [@"Dinnerapp2/Order/updateOrder?" stringByAppendingString:[Helper getURLPublic]];
        }
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        if (!isEmptyString([dataDic objectForKey:@"invite_id"])) {
            [self setValue:[dataDic objectForKey:@"invite_id"] forParamKey:@"invite_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"mobile"])) {
            [self setValue:[dataDic objectForKey:@"mobile"] forParamKey:@"mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"order_mobile"])) {
            [self setValue:[dataDic objectForKey:@"order_mobile"] forParamKey:@"order_mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"order_name"])) {
            [self setValue:[dataDic objectForKey:@"order_name"] forParamKey:@"order_name"];
        }
        if (!isEmptyString([dataDic objectForKey:@"order_time"])) {
            [self setValue:[dataDic objectForKey:@"order_time"] forParamKey:@"order_time"];
        }
        if (!isEmptyString([dataDic objectForKey:@"person_nums"])) {
            [self setValue:[dataDic objectForKey:@"person_nums"] forParamKey:@"person_nums"];
        }
        if (!isEmptyString([dataDic objectForKey:@"room_id"])) {
            [self setValue:[dataDic objectForKey:@"room_id"] forParamKey:@"room_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"room_type"])) {
            [self setValue:[dataDic objectForKey:@"room_type"] forParamKey:@"room_type"];
        }
        
        //选填
        if (!isEmptyString([dataDic objectForKey:@"order_id"])) {
            [self setValue:[dataDic objectForKey:@"order_id"] forParamKey:@"order_id"];
        }
        
    }
    return self;
}

@end
