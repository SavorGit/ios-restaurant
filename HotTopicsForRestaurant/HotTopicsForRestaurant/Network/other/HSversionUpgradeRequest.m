//
//  HSversionUpgradeRequest.m
//  SavorX
//
//  Created by 郭春城 on 17/2/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HSversionUpgradeRequest.h"

@implementation HSversionUpgradeRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"version/HotelUpgrade/index?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
