//
//  GetVerifyCodeRequest.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetVerifyCodeRequest.h"

@implementation GetVerifyCodeRequest

- (instancetype)initWithMobile:(NSString *)mobile
{
    if (self = [super init]) {
        self.methodName = [@"Dinnerapp/sms/getverifyCode?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:mobile forParamKey:@"mobile"];
    }
    return self;
}

@end
