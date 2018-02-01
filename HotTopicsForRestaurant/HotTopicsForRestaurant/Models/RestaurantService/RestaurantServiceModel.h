//
//  RestaurantServiceModel.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RDBoxModel.h"

@interface RestaurantServiceModel : NSObject

- (instancetype)initWithBoxModel:(RDBoxModel *)model;

@property (nonatomic, copy) NSString * boxName;
@property (nonatomic, copy) NSString * DefaultWord;

@property (nonatomic, assign) BOOL isPlayWord;
@property (nonatomic, assign) BOOL isPlayDish;

@property (nonatomic, strong) NSIndexPath * indexPath;

//机顶盒地址
@property (nonatomic, copy) NSString *BoxIP;

//机顶盒ID(MAC)
@property (nonatomic, copy) NSString *BoxID;

//酒楼ID
@property (nonatomic, assign) NSInteger hotelID;

//包间ID
@property (nonatomic, assign) NSInteger roomID;

- (void)startPlayWord;
- (void)startPlayDishWithCount:(NSInteger)count;

- (void)startPlayWordWithNoUpdate;

- (void)userStopPlayWord;
- (void)userStopPlayDish;

- (void)userUpdateWord;
- (void)updateWord;

@end
