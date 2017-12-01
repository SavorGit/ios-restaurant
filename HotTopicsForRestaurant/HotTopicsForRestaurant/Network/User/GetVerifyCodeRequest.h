//
//  GetVerifyCodeRequest.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetVerifyCodeRequest : BGNetworkRequest

- (instancetype)initWithMobile:(NSString *)mobile;

@end
