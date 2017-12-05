//
//  GetAdvertisingVideoRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetAdvertisingVideoRequest.h"

@implementation GetAdvertisingVideoRequest

- (instancetype)initWithHotelId:(NSString *)hotelId{
    
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp/Adv/getAdvList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:hotelId forParamKey:@"hotel_id"];
    }
    return self;
    
};

@end
