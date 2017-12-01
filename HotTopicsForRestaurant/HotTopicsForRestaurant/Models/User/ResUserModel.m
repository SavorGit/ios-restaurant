//
//  ResUserModel.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResUserModel.h"

@implementation ResUserModel

- (instancetype)initWithHotelID:(NSString *)hotelID hotelName:(NSString *)hotelName
{
    if (self = [super init]) {
        self.hotelID = hotelID;
        self.hotelName = hotelName;
    }
    return self;
}


@end
