//
//  RestaurantPhotoTool.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RestaurantPhotoTool.h"
#import "ResPhotoLibraryModel.h"
#import "ResSliderLibraryModel.h"
#import "ResSliderVideoModel.h"

static NSString * resSliderTitle = @"resSliderTitle"; //幻灯片标题
static NSString * resSliderIds = @"resSliderIds"; //幻灯片图片标识数组
static NSString * resSliderUpdateTime = @"resSliderUpdateTime"; //幻灯片更新时间
static NSString * resSliderTime = @"resSliderTime"; //幻灯片轮播速度

static NSString * resSliderVideoTitle = @"resSliderVideoTitle"; //幻灯片标题
static NSString * resSliderVideoIds = @"resSliderVideoIds"; //幻灯片图片标识数组
static NSString * resSliderVideoUpdateTime = @"resSliderVideoUpdateTime"; //幻灯片更新时间

@implementation RestaurantPhotoTool

+ (void)loadPHAssetWithHander:(void (^)(NSArray *))success
{
    //初始化手机相册数组
    NSMutableArray * collections = [[NSMutableArray alloc] init];
    
    //初始化手机相册遍历参数
    PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
    //设定只获取手机相册中的相片数量大于0的相册
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    
    //列出手机自带相册
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                           subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:userAlbumsOptions];
    
    //列出所有用户创建
    PHFetchResult *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    NSArray * collectionsFetchResults = @[syncedAlbums, userCollections];
    
    //列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (collection) {
            PHFetchOptions * option = [[PHFetchOptions alloc] init];
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            if (assetsFetchResult.count > 0) {
                ResPhotoLibraryModel * model = [[ResPhotoLibraryModel alloc] init];
                model.result = assetsFetchResult;
                model.createTime = [self transformDate:collection.startDate];
                model.title = collection.localizedTitle;
                if (![model.title isEqualToString:@"最近删除"]) {
                    [collections addObject:model];
                }
            }
        }
    }];
    
    for (int i = 0; i < collectionsFetchResults.count; i ++) {
        PHFetchResult *fetchResult = collectionsFetchResults[i];
        if (fetchResult.count > 0) {
            [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
                if (collection) {
                    PHFetchOptions * option = [[PHFetchOptions alloc] init];
                    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                    if (assetsFetchResult.count > 0) {
                        ResPhotoLibraryModel * model = [[ResPhotoLibraryModel alloc] init];
                        
                        model.result = assetsFetchResult;
                        model.title = collection.localizedTitle;
                        model.createTime = [self transformDate:collection.startDate];
                        if (![model.title isEqualToString:@"最近删除"]) {
                            [collections addObject:model];
                        }
                    }
                }
            }];
        }
    }
    success([NSArray arrayWithArray:collections]);
}

+ (ResSliderLibraryModel *)getSliderModelItemWithInfoDict:(NSDictionary *)dict
{
    ResSliderLibraryModel * model = [[ResSliderLibraryModel alloc] init];
    model.title = [dict objectForKey:resSliderTitle];
    model.createTime = [dict objectForKey:resSliderUpdateTime];
    model.assetIds = [dict objectForKey:resSliderIds];
    return model;
}

+ (NSArray *)getSliderList
{
    NSMutableArray * array = [NSMutableArray new];
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderLibraryPath];
    if (sliderArray) {
        for (NSDictionary * dict in sliderArray) {
            if (dict) {
                [array addObject:[self getSliderModelItemWithInfoDict:dict]];
            }
        }
        return [NSArray arrayWithArray:array];
    }else{
        return nil;
    }
}

+ (void)addSliderItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed
{
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderLibraryPath];
    if (sliderArray) {
        for (NSDictionary * dict in sliderArray) {
            if ([[dict objectForKey:resSliderTitle] isEqualToString:title]) {
                NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:101 userInfo:@{@"msg":@"已经存在相同名称的幻灯片"}];
                failed(error);
                return;
            }
        }
        [sliderArray insertObject:[self createSliderItemWithArray:array title:title] atIndex:0];
        
    }else{
        sliderArray = [NSMutableArray new];
        [sliderArray addObject:[self createSliderItemWithArray:array title:title]];
    }
    BOOL isOK = [self synchronizeLocalSliderFileWith:sliderArray];
    if (isOK) {
        success([self createSliderItemWithArray:array title:title]);
    }else{
        NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:102 userInfo:@{@"msg":@"幻灯片创建失败"}];
        failed(error);
    }
}

+ (void)updateSliderItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed
{
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderLibraryPath];
    if (sliderArray) {
        for (NSInteger i = 0; i < sliderArray.count; i++) {
            NSDictionary * dict = [sliderArray objectAtIndex:i];
            if ([[dict objectForKey:resSliderTitle] isEqualToString:title]) {
                [sliderArray replaceObjectAtIndex:i withObject:[self createSliderItemWithArray:array title:title]];
                BOOL isOK = [self synchronizeLocalSliderFileWith:sliderArray];
                if (isOK) {
                    success([self createSliderItemWithArray:array title:title]);
                }else{
                    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:103 userInfo:@{@"msg":@"幻灯片添加失败"}];
                    failed(error);
                }
                return;
            }
        }
    }
    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:104 userInfo:@{@"msg":@"幻灯片不存在"}];
    failed(error);
}

+ (void)removeSliderItemWithTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed
{
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderLibraryPath];
    if (sliderArray) {
        for (NSDictionary * dict in sliderArray) {
            if ([[dict objectForKey:resSliderTitle] isEqualToString:title]) {
                [sliderArray removeObject:dict];
                BOOL isOK = [self synchronizeLocalSliderFileWith:sliderArray];
                if (isOK) {
                    success(nil);
                }else{
                    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:105 userInfo:@{@"msg":@"幻灯片删除失败"}];
                    failed(error);
                }
                return;
            }
        }
    }
    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:104 userInfo:@{@"msg":@"幻灯片不存在"}];
    failed(error);
}

//创建一个幻灯片条目条目
+ (NSDictionary *)createSliderItemWithArray:(NSArray *)array title:(NSString *)title
{
    return @{resSliderTitle : title,
                            resSliderIds : array,
                            resSliderUpdateTime : [Helper transformDate:[NSDate date]],
                            resSliderTime : [NSNumber numberWithInteger:5]};
}

+ (BOOL)synchronizeLocalSliderFileWith:(NSArray *)array
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:ResSliderLibraryPath]) {
        [manager removeItemAtPath:ResSliderLibraryPath error:nil];
        return [array writeToFile:ResSliderLibraryPath atomically:NO];
    }
    return [array writeToFile:ResSliderLibraryPath atomically:NO];
}

/**
 *  对相册的缩略图进行处理
 *
 *  @param size 需要得到的size大小
 *  @param img  需要转换的image
 *
 *  @return 返回一个UIImage对象，即为所需展示缩略图
 */
+ (UIImage *)makeThumbnailOfSize:(CGSize)size image:(UIImage *)img
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    // draw scaled image into thumbnail context
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    // pop the context
    UIGraphicsEndImageContext();
    return newThumbnail;
}

+ (void)checkUserLibraryAuthorizationStatusWithSuccess:(void (^)())success failure:(ResFailed)failure
{
    //判断用户是否拥有权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    success();
                }else{
                    NSError * error = [NSError errorWithDomain:@"com.userLibrary" code:101 userInfo:nil];
                    failure(error);
                }
            });
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success();
        });
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError * error = [NSError errorWithDomain:@"com.userLibrary" code:102 userInfo:nil];
            failure(error);
        });
    }
}

+ (void)compressImageWithImage:(UIImage *)image compression:(CGFloat)compression finished:(void (^)(NSData *))finished
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData*  data = [NSData data];
        
        data = UIImageJPEGRepresentation(image, compression);
//        data = UIImageJPEGRepresentation(image, 1);
//        float tempX = 0.9;
//        NSInteger length = data.length;
//        while (data.length > size) {
//            data = UIImageJPEGRepresentation(image, tempX);
//            tempX -= 0.1;
//            if (data.length == length) {
//                break;
//            }
//            length = data.length;
//        }
        
        finished(data);
    });
}

+ (NSString *)transformDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSArray *)getVideoList
{
    NSMutableArray * array = [NSMutableArray new];
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderVideoPath];
    if (sliderArray) {
        for (NSDictionary * dict in sliderArray) {
            if (dict) {
                [array addObject:[self getSliderVideoModelItemWithInfoDict:dict]];
            }
        }
        return [NSArray arrayWithArray:array];
    }else{
        return nil;
    }
}

+ (ResSliderVideoModel *)getSliderVideoModelItemWithInfoDict:(NSDictionary *)dict
{
    ResSliderVideoModel * model = [[ResSliderVideoModel alloc] init];
    model.title = [dict objectForKey:resSliderVideoTitle];
    model.createTime = [dict objectForKey:resSliderVideoUpdateTime];
    model.assetIds = [dict objectForKey:resSliderVideoIds];
    return model;
}

+ (void)addSliderVideoItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed
{
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderVideoPath];
    if (sliderArray) {
        for (NSDictionary * dict in sliderArray) {
            if ([[dict objectForKey:resSliderVideoTitle] isEqualToString:title]) {
                NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:101 userInfo:@{@"msg":@"已经存在相同名称的视频列表"}];
                failed(error);
                return;
            }
        }
        [sliderArray insertObject:[self createSliderVideoItemWithArray:array title:title] atIndex:0];
        
    }else{
        sliderArray = [NSMutableArray new];
        [sliderArray addObject:[self createSliderVideoItemWithArray:array title:title]];
    }
    BOOL isOK = [self synchronizeLocalSliderVideoFileWith:sliderArray];
    if (isOK) {
        success([self createSliderVideoItemWithArray:array title:title]);
    }else{
        NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:102 userInfo:@{@"msg":@"视频列表创建失败"}];
        failed(error);
    }
}

+ (void)updateSliderVideoItemWithIDArray:(NSArray *)array andTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed
{
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderVideoPath];
    if (sliderArray) {
        for (NSInteger i = 0; i < sliderArray.count; i++) {
            NSDictionary * dict = [sliderArray objectAtIndex:i];
            if ([[dict objectForKey:resSliderVideoTitle] isEqualToString:title]) {
                [sliderArray replaceObjectAtIndex:i withObject:[self createSliderVideoItemWithArray:array title:title]];
                BOOL isOK = [self synchronizeLocalSliderVideoFileWith:sliderArray];
                if (isOK) {
                    success([self createSliderVideoItemWithArray:array title:title]);
                }else{
                    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:103 userInfo:@{@"msg":@"视频添加失败"}];
                    failed(error);
                }
                return;
            }
        }
    }
    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:104 userInfo:@{@"msg":@"视频不存在"}];
    failed(error);
}

+ (void)removeSliderVideoItemWithTitle:(NSString *)title success:(ResSuccess)success failed:(ResFailed)failed
{
    NSMutableArray * sliderArray = [NSMutableArray arrayWithContentsOfFile:ResSliderVideoPath];
    if (sliderArray) {
        for (NSDictionary * dict in sliderArray) {
            if ([[dict objectForKey:resSliderVideoTitle] isEqualToString:title]) {
                [sliderArray removeObject:dict];
                BOOL isOK = [self synchronizeLocalSliderVideoFileWith:sliderArray];
                if (isOK) {
                    success(nil);
                }else{
                    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:105 userInfo:@{@"msg":@"视频删除失败"}];
                    failed(error);
                }
                return;
            }
        }
    }
    NSError * error = [NSError errorWithDomain:@"com.RestaurantPhotoTool" code:104 userInfo:@{@"msg":@"视频不存在"}];
    failed(error);
}

//创建一个幻灯片条目条目
+ (NSDictionary *)createSliderVideoItemWithArray:(NSArray *)array title:(NSString *)title
{
    return @{resSliderVideoTitle : title,
             resSliderVideoIds : array,
             resSliderVideoUpdateTime : [Helper transformDate:[NSDate date]]};
}

+ (BOOL)synchronizeLocalSliderVideoFileWith:(NSArray *)array
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:ResSliderVideoPath]) {
        [manager removeItemAtPath:ResSliderVideoPath error:nil];
    }
    return [array writeToFile:ResSliderVideoPath atomically:NO];
}

/**
 *  从PHAsset中导出对应视频对象
 *
 *  @param asset          PHAsset资源对象
 *  @param startHandler   导出视频的回调，session是导出类的相关信息
 *  @param endHandler     结束导出视频的回调，path表示导出的路径，session是导出类的相关信息
 *  @param type           视频导出的质量
 */
+ (void)exportVideoToMP4WithAsset:(PHAsset *)videoAsset startHandler:(void (^)(AVAssetExportSession * session))startHandler endHandler:(void (^)(NSString * path, AVAssetExportSession * session))endHandler exportPresetType:(NSString *)type
{
    //配置导出参数
    PHVideoRequestOptions *options = [PHVideoRequestOptions new];
    options.networkAccessAllowed = YES;
    
    //通过PHAsset获取AVAsset对象
    [[PHImageManager defaultManager] requestAVAssetForVideo:videoAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        NSUInteger degress = 0;
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        if([tracks count] > 0) {
            AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
            CGAffineTransform t = videoTrack.preferredTransform;
            if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
                degress = 90;
            }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
                degress =270;
            }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
                degress = 0;
            }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
                degress = 180;
            }
        }
        
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        AVMutableVideoComposition *waterMarkVideoComposition = [AVMutableVideoComposition videoComposition];
        
        //视频转换导出地址
        NSString* str = RestaurantTempVideoPath;
        NSURL * outputURL = [NSURL fileURLWithPath:str];
        
        //如果在目录下已经有视频文件了，就移除该文件后再执行导出操作，避免文件名冲突错误
        if ([[NSFileManager defaultManager] fileExistsAtPath:str]) {
            [[NSFileManager defaultManager] removeItemAtPath:str error:nil];
        }
        
        if(degress == 90){
            //顺时针旋转90°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
        }else if(degress == 180){
            //顺时针旋转180°
            translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
        }else if(degress == 270){
            //顺时针旋转270°
            translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
            mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
            waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
        }else{
            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:type];
            session.outputURL = outputURL;
            session.outputFileType = AVFileTypeMPEG4;
            startHandler(session);
            //导出视频
            [session exportAsynchronouslyWithCompletionHandler:^(void)
             {
                 endHandler(str, session);
             }];
            return;
        }
        
        AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
        AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
        
        roateInstruction.layerInstructions = @[roateLayerInstruction];
        //将视频方向旋转加入到视频处理中
        waterMarkVideoComposition.instructions = @[roateInstruction];
        waterMarkVideoComposition.frameDuration = CMTimeMake(1, 30);
        
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:type];
        session.outputURL = outputURL;
        session.videoComposition = waterMarkVideoComposition;
        session.outputFileType = AVFileTypeMPEG4;
        startHandler(session);
        //导出视频
        [session exportAsynchronouslyWithCompletionHandler:^(void)
         {
             endHandler(str, session);
         }];
    }];
}

@end
