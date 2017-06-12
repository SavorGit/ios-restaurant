//
//  NetworkConfiguration.h
//  newProjcet
//
//  Created by lijiawei on 16/6/8.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface NetworkConfiguration : BGNetworkConfiguration

-(NSString *)baseURLString;

- (NSDictionary *)requestCommonHTTPHeaderFields;

@end
