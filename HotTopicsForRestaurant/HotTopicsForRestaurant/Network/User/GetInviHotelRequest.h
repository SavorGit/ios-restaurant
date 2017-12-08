//
//  GetInviHotelRequest.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetInviHotelRequest : BGNetworkRequest

- (instancetype)initWithInviCode:(NSString *)inviCode mobile:(NSString *)mobile veriCode:(NSString *)veriCode;

@end
