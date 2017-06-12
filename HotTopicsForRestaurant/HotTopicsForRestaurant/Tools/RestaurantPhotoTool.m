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
#import "Helper.h"

static NSString * resSliderTitle = @"resSliderTitle"; //幻灯片标题
static NSString * resSliderIds = @"resSliderIds"; //幻灯片图片标识数组
static NSString * resSliderUpdateTime = @"resSliderUpdateTime"; //幻灯片更新时间
static NSString * resSliderTime = @"resSliderTime"; //幻灯片轮播速度

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
            [array addObject:[self getSliderModelItemWithInfoDict:dict]];
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

+ (void)removeSliderItemWithIndexPaths:(ResSuccess)success withTitle:(NSString *)title
{
    
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
            if (status == PHAuthorizationStatusAuthorized) {
                success();
            }else{
                NSError * error = [NSError errorWithDomain:@"com.userLibrary" code:101 userInfo:nil];
                failure(error);
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        success();
    } else{
        NSError * error = [NSError errorWithDomain:@"com.userLibrary" code:102 userInfo:nil];
        failure(error);
    }
}

+ (NSString *)transformDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

@end
