//
//  PhotoTool.h
//  SavorX
//
//  Created by 郭春城 on 16/8/8.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Photos/Photos.h>
#import "PhotoLibraryModel.h"

@protocol PhotoToolDelegate <NSObject>
@optional
- (void)PhotoToolDidGetAssetPhotoGroups:(NSArray *)results;
- (void)PhotoToolDidGetAssetVideo:(NSArray *)results;

@end

@interface PhotoTool : NSObject

@property (nonatomic, strong) NSMutableArray * sliderArray; //存储当前幻灯片数据
@property (nonatomic, assign) id<PhotoToolDelegate> delegate;

/**
 *  单例模式
 *
 *  @return PhotoTool对象
 */
+ (PhotoTool *)sharedInstance;

/**
 *  开始加载相册列表
 */
- (void)startLoadPhotoAssetCollection;

/**
 *  开始加载视频列表
 */
- (void)startLoadVideoAssetCollection;

/**
 *  从PHAsset中导出对应视频对象
 *
 *  @param asset PHAsset资源对象
 *  @param startHandler 开始导出视频的回调，session是导出类的相关信息
 *  @param endHandler 导出视频的回调，path表示导出的路径，session是导出类的相关信息
 */
- (void)exportVideoToMP4WithAsset:(PHAsset *)asset startHandler:(void (^)(AVAssetExportSession * session))startHandler endHandler:(void (^)(NSString * url, AVAssetExportSession * session))endHandler;

/**
 *  存储图片到系统相册
 *
 *  @param image 需要保存的图片
 */
- (void)saveImageInSystemPhoto:(UIImage *)image withAlert:(BOOL)alert;

//幻灯片操作
//增加
- (NSDictionary *)addSliderItemWithIDArray:(NSArray *)array andTitle:(NSString *)title;

//改变某一幻灯片的播放速度
- (NSDictionary *)setSlideTime:(NSInteger)time forTitile:(NSString *)title;

//删除幻灯片条目
- (NSDictionary *)removeSliderItemWithIndexPaths:(NSArray *)array withTitle:(NSString *)title;

//获取model列表
- (NSArray *)getSliderList;

//删除对应下表数据
- (void)removeSliderItemWithIndex:(NSInteger)index;

//删除对应标题数据
- (void)removeSliderItemWithTitle:(NSString *)title;

//返回处理后的图片
- (void)compressImageWithImage:(UIImage *)image finished:(void (^)(NSData *))finished;

- (void)getImageFromPHAssetSourceWithAsset:(PHAsset *)asset success:(void (^)(UIImage * result))success;

// 获取视频第一帧或是第几帧的图片
- (UIImage *)imageWithVideoUrl:(NSURL *)urlAsSet atTime:(NSTimeInterval)tmpTime;

// 获取视频第一帧或是第几帧的图片
- (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)tmpTime completion:(void(^)(UIImage *image))completion;

@end
