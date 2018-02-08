//
//  RestaurantServiceModel.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceModel.h"
#import "SAVORXAPI.h"

@interface RestaurantServiceModel ()

@property (nonatomic, assign) BOOL wordNeedUpdate;

@end

@implementation RestaurantServiceModel

- (instancetype)initWithBoxModel:(RDBoxModel *)model
{
    if (self = [super init]) {
        self.boxName = model.sid;
        self.BoxIP = model.BoxIP;
        self.BoxID = model.BoxID;
        self.hotelID = model.hotelID;
        self.roomID = model.roomID;
        self.bgViewID = @"1";
        self.wordNeedUpdate = NO;
        self.DefaultWord = [SAVORXAPI getDefaultWord];
    }
    return self;
}

- (void)startPlayWord
{
    if (self.isPlayDish) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayDish) object:nil];
        self.isPlayDish = NO;
    }
    
    if (self.isPlayWord) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWord) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWordWithDishCount:) object:nil];
    }
    
    self.isPlayWord = YES;
    [self performSelector:@selector(stopPlayWord) withObject:nil afterDelay:5 * 60];
    [self modelDidUpdate];
}

- (void)startPlayWordWithNoUpdate
{
    if (self.isPlayDish) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayDish) object:nil];
        self.isPlayDish = NO;
    }
    
    if (self.isPlayWord) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWord) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWordWithDishCount:) object:nil];
    }
    
    self.isPlayWord = YES;
    [self performSelector:@selector(stopPlayWord) withObject:nil afterDelay:5 * 60];
}

- (void)startPlayWordWithDishCount:(NSInteger)count
{
    if (self.isPlayDish) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayDish) object:nil];
        self.isPlayDish = NO;
    }
    
    if (self.isPlayWord) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWord) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWordWithDishCount:) object:nil];
    }
    
    self.isPlayWord = YES;
    [self performSelector:@selector(stopPlayWordWithDishCount:) withObject:[NSNumber numberWithInteger:count] afterDelay:5 * 60];
    [self modelDidUpdate];
}

- (void)stopPlayWordWithDishCount:(NSNumber *)count
{
    [self stopPlayWord];
    [self startPlayDishWithCount:[count integerValue]];
}

- (void)userStopPlayWord
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWord) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWordWithDishCount:) object:nil];
    [self stopPlayWord];
}

- (void)stopPlayWord
{
    self.isPlayWord = NO;
    
    if (self.wordNeedUpdate) {
        self.DefaultWord = [SAVORXAPI getDefaultWord];
    }
    
    [self modelDidUpdate];
}

- (void)startPlayDishWithCount:(NSInteger)count
{
    if (self.isPlayWord) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWord) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopPlayWordWithDishCount:) object:nil];
        self.isPlayWord = NO;
        if (self.wordNeedUpdate) {
            self.DefaultWord = [SAVORXAPI getDefaultWord];
        }
    }
    
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
    [self stopPlayDish];
}

- (void)stopPlayDish
{
    self.isPlayDish = NO;
    [self modelDidUpdate];
}

- (void)userUpdateWord
{
    if (self.isPlayWord) {
        self.wordNeedUpdate = YES;
    }else{
        [self updateWord];
    }
}

- (void)updateWord
{
    self.DefaultWord = [SAVORXAPI getDefaultWord];
}

- (void)setDefaultWord:(NSString *)DefaultWord
{
    _DefaultWord = DefaultWord;
    self.wordNeedUpdate = NO;
}

- (void)modelDidUpdate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RDRestaurantServiceModelDidUpdate object:nil userInfo:@{@"indexPath" : self.indexPath}];
}

- (void)modelBGViewBecomeDefalut
{
    self.bgViewID = @"1";
}

@end
