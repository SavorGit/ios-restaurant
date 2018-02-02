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

//开始播放欢迎词
- (void)startPlayWord;
//开始播放推荐菜
- (void)startPlayDishWithCount:(NSInteger)count;

//开始播放欢迎词不用更新显示状态(当紧接着会刷新整个tableView列表的时候，调用此方法，防止动画冲突)
- (void)startPlayWordWithNoUpdate;
//开始播放欢迎词并紧接着播放推荐菜
- (void)startPlayWordWithDishCount:(NSInteger)count;

//用户停止播放欢迎词，取消计时器
- (void)userStopPlayWord;
//用户停止播放推荐菜，取消计时器
- (void)userStopPlayDish;

//用户操作该model进行的更新默认欢迎词
- (void)userUpdateWord;
//更新默认欢迎词
- (void)updateWord;

@end
