//
//  PhotoLibraryModel.h
//  SavorX
//
//  Created by 郭春城 on 16/10/25.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PhotoLibraryModel : NSObject

@property (nonatomic, assign) BOOL isSystemLibrary; //是否是系统相册
@property (nonatomic, copy) NSString * title; //相册名称
@property (nonatomic, strong) PHFetchResult * result; //相册集合
@property (nonatomic, copy) NSString * createTime; //相册创建时间
@property (nonatomic, strong) NSMutableArray * assetSource;

@end
