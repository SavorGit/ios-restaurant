//
//  RestaurantServiceModel.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceModel.h"

@implementation RestaurantServiceModel

- (instancetype)initWithBoxModel:(RDBoxModel *)model
{
    if (self = [super init]) {
        self.boxName = model.sid;
        self.BoxIP = model.BoxIP;
        self.BoxID = model.BoxID;
        self.hotelID = model.hotelID;
        self.roomID = model.roomID;
    }
    return self;
}

- (void)modelDidUpdate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RDDidFoundBoxSenceNotification object:nil userInfo:@{@"indexPath" : self.indexPath}];
}

@end
