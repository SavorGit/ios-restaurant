//
//  GetCustomerTagRequest.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetCustomerTagRequest : BGNetworkRequest

- (instancetype)initWithCustomerID:(NSString *)customerID;

@end
