//
//  RestaurantServiceModel.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceModel.h"

@implementation RestaurantServiceModel

- (void)modelDidUpdate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RDDidFoundBoxSenceNotification object:nil userInfo:@{@"indexPath" : self.indexPath}];
}

@end
