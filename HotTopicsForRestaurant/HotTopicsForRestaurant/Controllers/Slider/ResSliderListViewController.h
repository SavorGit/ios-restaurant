//
//  ResSliderListViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "ResSliderLibraryModel.h"

@interface ResSliderListViewController : ResBaseViewController

- (instancetype)initWithSliderModel:(ResSliderLibraryModel *)model block:(void(^)(NSDictionary * item))block;

@end
