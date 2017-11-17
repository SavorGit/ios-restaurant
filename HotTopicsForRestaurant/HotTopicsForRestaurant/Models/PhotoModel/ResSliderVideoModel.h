//
//  ResSliderVideoModel.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/17.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResSliderVideoModel : NSObject

@property (nonatomic, copy) NSString * title; //相册名称
@property (nonatomic, strong) NSMutableArray * assetIds; //相册集合
@property (nonatomic, copy) NSString * createTime; //相册创建时间

@end
