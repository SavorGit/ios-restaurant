//
//  ReserveModel.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface ReserveModel : Jastor

//预定主页
@property(nonatomic, copy)   NSString *time_str;
@property(nonatomic, copy)   NSString *moment_str;
@property(nonatomic, copy)   NSString *person_nums;
@property(nonatomic, copy)   NSString *order_name;
@property(nonatomic, copy)   NSString *order_mobile;
@property(nonatomic, copy)   NSString *order_id;
@property(nonatomic, copy)   NSString *room_name;
@property(nonatomic, copy)   NSString *remark;
@property(nonatomic, copy)   NSString *face_url;
@property(nonatomic, assign) NSInteger is_welcome;
@property(nonatomic, assign) NSInteger is_recfood;
@property(nonatomic, assign) NSInteger is_expense;



//@property(nonatomic, copy) NSString *dayTitle;
//@property(nonatomic, copy) NSString *time;
//@property(nonatomic, copy) NSString *peopleNum;
//@property(nonatomic, copy) NSString *name;
//@property(nonatomic, copy) NSString *phone;
//@property(nonatomic, copy) NSString *welcom;
//@property(nonatomic, copy) NSString *imgUrl;

@property(nonatomic, copy) NSArray *welcomArray;

// 选择包间
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *room_id;
@property(nonatomic, copy) NSString *room_type;
@property(nonatomic, assign) BOOL selectType;

// 头部日期
@property(nonatomic, copy) NSString *totalDay;
@property(nonatomic, copy) NSString *displayDay;
@property(nonatomic, copy) NSString *dishNum;
@property(nonatomic, copy) NSString *personDay;

@end
