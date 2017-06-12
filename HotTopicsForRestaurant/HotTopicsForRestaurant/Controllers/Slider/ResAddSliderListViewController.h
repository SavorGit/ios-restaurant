//
//  ResAddSliderListViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "ResPhotoLibraryModel.h"
#import "ResSliderLibraryModel.h"

@interface ResAddSliderListViewController : ResBaseViewController

- (instancetype)initWithModel:(ResPhotoLibraryModel *)model sliderModel:(ResSliderLibraryModel *)sliderModel block:(void(^)(NSDictionary * item))block;

@end
