//
//  ResHomeListModel.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ResHomeListType_Dishes, //推荐菜
    ResHomeListType_Trailer,//宣传片
    ResHomeListType_Words,  //欢迎词
    ResHomeListType_Photo,  //幻灯片
    ResHomeListType_Video,  //视频
    ResHomeListType_Restaurant
} ResHomeListType;

@interface ResHomeListModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageName;
@property (nonatomic, assign) ResHomeListType type;

- (instancetype)initWithType:(ResHomeListType)type;

@end
