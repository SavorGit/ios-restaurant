//
//  ResUserModel.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResUserModel.h"

@implementation ResUserModel

- (instancetype)initWithHotelID:(NSString *)hotelID hotelName:(NSString *)hotelName telNumber:(NSString *)telNumber inviCode:(NSString *)inviCode inviteId:(NSString *)invite_id isImport:(NSString *)isImport isOpen:(NSString *)isOpen
{
    if (self = [super init]) {
        self.hotelID = [hotelID integerValue];
        self.hotelName = hotelName;
        self.telNumber = telNumber;
        self.inviCode = inviCode;
        self.invite_id = invite_id;
        self.is_import_customer = isImport;
        self.is_open_customer = isOpen;
    }
    return self;
}


@end
