//
//  GetConsumRecordRequest.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetConsumRecordRequest : BGNetworkRequest

- (instancetype)initWithCustomerInfo:(NSDictionary *)info;

@end
