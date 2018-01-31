//
//  RestaurantServiceCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantServiceModel.h"

typedef enum : NSUInteger {
    RestaurantServiceHandle_Word,
    RestaurantServiceHandle_Dish,
    RestaurantServiceHandle_WordPlay,
    RestaurantServiceHandle_DishPlay,
    RestaurantServiceHandle_WordStop,
    RestaurantServiceHandle_DishStop
} RestaurantServiceHandleType;

@protocol RestaurantServiceDelegate <NSObject>

- (void)RestaurantServiceDidHandle:(RestaurantServiceHandleType)type model:(RestaurantServiceModel *)model;

@end

@interface RestaurantServiceCell : UITableViewCell

@property (nonatomic, assign) id<RestaurantServiceDelegate> delegate;

- (void)configWithModel:(RestaurantServiceModel *)model;

@end
