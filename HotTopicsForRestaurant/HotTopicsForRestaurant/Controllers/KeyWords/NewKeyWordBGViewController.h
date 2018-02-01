//
//  NewKeyWordBGViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "RestaurantServiceModel.h"

@interface NewKeyWordBGViewController : ResBaseViewController

- (instancetype)initWithkeyWord:(NSString *)keyWord model:(RestaurantServiceModel *)model isDefault:(BOOL)isDefault;

@end
