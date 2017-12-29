//
//  AddPayHistoryRequest.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>
#import "RDAddressModel.h"

@interface AddPayHistoryRequest : BGNetworkRequest

- (instancetype)initWithCustomerID:(NSString *)customerID name:(NSString *)name telNumber:(NSString *)telNumber imagePaths:(NSString *)imagePaths tagIDs:(NSString *)tagIDs model:(RDAddressModel *)model;

@end
