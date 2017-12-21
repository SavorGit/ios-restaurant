//
//  ReserveOrderListRequest.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface ReserveOrderListRequest : BGNetworkRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;

@end
