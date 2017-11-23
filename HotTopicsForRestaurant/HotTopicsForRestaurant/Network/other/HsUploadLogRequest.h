//
//  HsUploadLogRequest.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface HsUploadLogRequest : BGNetworkRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;

@end
