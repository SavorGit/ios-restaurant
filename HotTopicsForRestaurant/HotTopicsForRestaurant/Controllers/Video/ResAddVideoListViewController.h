//
//  ResAddVideoListViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "ResSliderVideoModel.h"

@interface ResAddVideoListViewController : ResBaseViewController

- (instancetype)initWithModel:(ResSliderVideoModel *)sliderModel block:(void(^)(NSDictionary * item))block;

@end
