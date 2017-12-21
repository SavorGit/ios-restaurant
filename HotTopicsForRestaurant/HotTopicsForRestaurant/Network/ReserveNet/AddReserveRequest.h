//
//  AddReserveRequest.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface AddReserveRequest : BGNetworkRequest

// type 0 新增   tpey 1 修改
- (instancetype)initWithPubData:(NSDictionary *)dataDic withType:(NSInteger )type;

@end
