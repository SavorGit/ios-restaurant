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
        self.DefaultWord = @"欢迎您，祝您用餐愉快";
    }
    return self;
}

- (void)startPlayWord
{
    if (self.isPlayWord) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWord) object:nil];
    }
    
    self.isPlayWord = YES;
    [self performSelector:@selector(stopPlayWord) withObject:nil afterDelay:5 * 60];
    [self modelDidUpdate];
}

- (void)userStopPlayWord
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWord) object:nil];
    [self stopPlayWord];
}

- (void)stopPlayWord
{
    self.isPlayWord = NO;
    [self modelDidUpdate];
}

- (void)startPlayDishWithCount:(NSInteger)count
{
    if (self.isPlayDish) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayDish) object:nil];
    }
    
    self.isPlayDish = YES;
    NSInteger time = 20;
    if (count > 1) {
        time = 10 * count;
    }
    [self performSelector:@selector(stopPlayDish) withObject:nil afterDelay:time];
    [self modelDidUpdate];
}

- (void)userStopPlayDish
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayDish) object:nil];
    [self stopPlayWord];
}

- (void)stopPlayDish
{
    self.isPlayDish = NO;
    [self modelDidUpdate];
}

- (void)modelDidUpdate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RDRestaurantServiceModelDidUpdate object:nil userInfo:@{@"indexPath" : self.indexPath}];
}

@end
