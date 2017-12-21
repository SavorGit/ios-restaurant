//
//  ReserveModel.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface ReserveModel : Jastor

@property(nonatomic, copy) NSString *dayTitle;
@property(nonatomic, copy) NSString *time;
@property(nonatomic, copy) NSString *peopleNum;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *phone;
@property(nonatomic, copy) NSString *welcom;
@property(nonatomic, copy) NSString *imgUrl;

@property(nonatomic, copy) NSArray *welcomArray;

// 选择包间
@property(nonatomic, copy) NSString *roomName;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, assign) BOOL selectType;

// 头部日期
@property(nonatomic, copy) NSString *totalDay;
@property(nonatomic, copy) NSString *displayDay;
@property(nonatomic, copy) NSString *dishNum;
@property(nonatomic, copy) NSString *personDay;

@end
