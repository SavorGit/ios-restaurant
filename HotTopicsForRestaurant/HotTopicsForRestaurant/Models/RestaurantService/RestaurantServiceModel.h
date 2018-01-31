//
//  RestaurantServiceModel.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantServiceModel : NSObject

@property (nonatomic, copy) NSString * boxName;
@property (nonatomic, copy) NSString * DefaultWord;

@property (nonatomic, assign) BOOL isPlayWord;
@property (nonatomic, assign) BOOL isPlayDish;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end
