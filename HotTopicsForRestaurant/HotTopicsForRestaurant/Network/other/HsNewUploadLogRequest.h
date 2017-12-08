//
//  HsNewUploadLogRequest.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface HsNewUploadLogRequest : BGNetworkRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;

@end
