//
//  ResPhotoLibraryModel.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ResPhotoLibraryModel : NSObject

@property (nonatomic, copy) NSString * title; //相册名称
@property (nonatomic, strong) PHFetchResult * result; //相册集合
@property (nonatomic, copy) NSString * createTime; //相册创建时间

@end
