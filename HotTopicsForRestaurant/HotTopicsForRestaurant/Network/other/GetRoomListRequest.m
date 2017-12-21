//
//  GetRoomListRequest.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetRoomListRequest.h"

@implementation GetRoomListRequest

- (instancetype)initWithInviteId:(NSString *)inviteId andMobile:(NSString *)mobile
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp2/Room/getList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:inviteId forParamKey:@"invite_id"];
        [self setValue:mobile forParamKey:@"mobile"];
    }
    return self;
    
};

@end
