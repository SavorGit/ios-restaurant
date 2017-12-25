//
//  AddCustomerRequest.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/25.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface AddCustomerRequest : BGNetworkRequest

- (instancetype)initWithCustomerInfo:(NSDictionary *)info;

@end
