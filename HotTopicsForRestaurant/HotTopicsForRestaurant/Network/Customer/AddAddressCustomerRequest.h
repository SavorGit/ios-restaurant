//
//  AddAddressCustomerRequest.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface AddAddressCustomerRequest : BGNetworkRequest

- (instancetype)initWithCustomers:(NSArray *)customers;

@end
