//
//  RecoDishesModel.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface RecoDishesModel : Jastor

@property(nonatomic, copy) NSString *chinese_name;
@property(nonatomic, assign) NSInteger food_id;
@property(nonatomic, copy) NSString *food_name;
@property(nonatomic, assign) NSInteger cid ;
@property(nonatomic, copy) NSString *md5;
@property(nonatomic, copy) NSString *md5_type;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *oss_path;
@property(nonatomic, copy) NSString *suffix;
@property(nonatomic, assign) NSInteger selectType;

@property(nonatomic, assign) NSInteger duration;
@property(nonatomic, copy) NSString *img_url;

//单机演示版
@property(nonatomic, copy) NSString *ImgName;

@end
