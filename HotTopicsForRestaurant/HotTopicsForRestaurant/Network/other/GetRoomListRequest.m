//
//  GetRoomListRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetRoomListRequest.h"

@implementation GetRoomListRequest

- (instancetype)initWithHotelId:(NSString *)hotelId{
    
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp/Room/getRoomList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:hotelId forParamKey:@"hotel_id"];
    }
    return self;
    
};

@end
