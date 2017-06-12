//
//  HSGetIpRequest.m
//  SavorX
//
//  Created by 郭春城 on 17/2/14.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HSGetIpRequest.h"

@implementation HSGetIpRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"basedata/Ip/getIp?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPGet;
    }
    return self;
}

@end
