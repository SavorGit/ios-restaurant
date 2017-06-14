//
//  PhotoTool.m
//  SavorX
//
//  Created by 郭春城 on 16/8/8.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "PhotoTool.h"
#import "UIImage+Additional.h"

@implementation PhotoTool

/**
 *  单例模式
 *
 *  @return PhotoTool对象
 */
+ (PhotoTool *)sharedInstance
{
    static PhotoTool * photo = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        photo = [[self alloc] init];
    });
    return photo;
}

- (instancetype)init
{
    if (self = [super init]) {
        NSFileManager * manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:UserLibraryPath]) {
            self.sliderArray = [NSMutableArray arrayWithContentsOfFile:UserLibraryPath];
        }else{
            self.sliderArray = [NSMutableArray new];
            [self.sliderArray writeToFile:UserLibraryPath atomically:NO];
        }
    }
    return self;
}

/**
 *  开始加载相册列表
 */
- (void)startLoadPhotoAssetCollection
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //初始化相册数组
        NSMutableArray * collections = [[NSMutableArray alloc] init];
        
        //初始化相册遍历参数
        PHFetchOptions *userAlbumsOptions = [PHFetchOptions new];
        //相册中的相片数量大于0
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
                    PhotoLibraryModel * model = [[PhotoLibraryModel alloc] init];
                    model.isSystemLibrary = YES;
                    model.result = assetsFetchResult;
                    model.createTime = [self transformDate:collection.startDate];
                    model.title = [self transformAblumTitle:collection.localizedTitle];
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
                            PhotoLibraryModel * model = [[PhotoLibraryModel alloc] init];
                            model.isSystemLibrary = YES;
                            model.result = assetsFetchResult;
                            model.createTime = [self transformDate:collection.startDate];
                            model.title = [self transformAblumTitle:collection.localizedTitle];
                            if (![model.title isEqualToString:@"最近删除"]) {
                                [collections addObject:model];
                            }
                        }
                    }
                }];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(PhotoToolDidGetAssetPhotoGroups:)]) {
                [_delegate PhotoToolDidGetAssetPhotoGroups:collections];
            }
        });
    });
}

- (void)startLoadVideoAssetCollection
{
    //所有相册视频
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (collection) {
            [result addObject:collection];
        }
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(PhotoToolDidGetAssetVideo:)]) {
        [_delegate PhotoToolDidGetAssetVideo:result];
    }
}

- (void)saveImageInSystemPhoto:(UIImage *)image withAlert:(BOOL)alert
{
    //判断用户是否拥有相机权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
            }else{
                return;
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        
    } else{
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 相册的标题
        NSString *title = @"小热点";
        
        PHAssetCollection * myCollection;
        
        // 获得所有的自定义相册
        PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (PHAssetCollection *collection in collections) {
            if ([collection.localizedTitle isEqualToString:title]) {
                myCollection = collection;
            }
        }
        
        if (!myCollection) {
            // 代码执行到这里，说明还没有自定义相册
            __block NSString *createdCollectionId = nil;
            
            // 创建一个新的相册
            [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
            } error:nil];
            myCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
        }
        
        __block NSString *createdAssetId = nil;
        // 添加图片到【相机胶卷】
        // 同步方法,直接创建图片,代码执行完,图片没创建完,所以使用占位ID (createdAssetId)
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        } error:nil];
        
        // 在保存完毕后取出图片
        PHFetchResult<PHAsset *> *createdAssets = [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
        
        if (!createdAssets || !myCollection) {
            return;
        }
        
        // 将刚才添加到【相机胶卷】的图片，引用（添加）到【自定义相册】
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:myCollection];
            // 自定义相册封面默认保存第一张图,所以使用以下方法把最新保存照片设为封面
            [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:myCollection.estimatedAssetCount]];
        } error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (alert) {
                if (error) {
                    [MBProgressHUD showTextHUDwithTitle:@"保存失败"];
                }else{
                    [MBProgressHUD showSuccessHUDInView:[UIApplication sharedApplication].keyWindow title:@"图片已保存"];
                }
            }
        });
    });
}

/**
 *  从PHAsset中导出对应视频对象
 *
 *  @param asset   PHAsset资源对象
 *  @param handler 导出视频的回调，path表示导出的路径，session是导出类的相关信息
 */
- (void)exportVideoToMP4WithAsset:(PHAsset *)asset startHandler:(void (^)(AVAssetExportSession * session))startHandler endHandler:(void (^)(NSString * url, AVAssetExportSession * session))endHandler
{
    //配置导出参数
    PHVideoRequestOptions *options = [PHVideoRequestOptions new];
    options.networkAccessAllowed = YES;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    //通过PHAsset获取AVAsset对象
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        NSURL * filePath;
        
        //配置导出相关的信息，包括类型，翻转角度等
        AVURLAsset * urlAsset = (AVURLAsset *)asset;
        if ([urlAsset respondsToSelector:@selector(URL)]) {
            filePath = urlAsset.URL;
        }else{
            NSString * value = [info objectForKey:@"PHImageFileSandboxExtensionTokenKey"];
            NSString * path = [value substringFromIndex:[value rangeOfString:@"/var"].location];
            filePath = [NSURL fileURLWithPath:path];
        }
        NSInteger degrees = [self degressFromVideoFileWithURL:filePath];
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform translateToCenter;
        CGAffineTransform mixedTransform;
        AVMutableVideoComposition *waterMarkVideoComposition = [AVMutableVideoComposition videoComposition];
        
        //视频转换导出地址
        NSString *documentsDirectory = HTTPServerDocument;
        NSString* str = [documentsDirectory stringByAppendingPathComponent:@"media-Redianer-TempCache.mp4"];
        
        NSURL * outputURL = [NSURL fileURLWithPath:str];
        
        //如果在目录下已经有视频文件了，就移除该文件后再执行导出操作，避免文件名冲突错误
        if ([[NSFileManager defaultManager] fileExistsAtPath:str]) {
            [[NSFileManager defaultManager] removeItemAtPath:str error:nil];
        }
        
        if (degrees == 0) {
            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
            session.outputURL = outputURL;
            session.outputFileType = AVFileTypeMPEG4;
            startHandler(session);
            //导出视频
            [session exportAsynchronouslyWithCompletionHandler:^(void)
             {
                 endHandler(str, session);
             }];
        }else{
            if(degrees == 90){
                //顺时针旋转90°
                translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.height, 0.0);
                mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2);
                waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            }else if(degrees == 180){
                //顺时针旋转180°
                translateToCenter = CGAffineTransformMakeTranslation(videoTrack.naturalSize.width, videoTrack.naturalSize.height);
                mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI);
                waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.width,videoTrack.naturalSize.height);
            }else if(degrees == 270){
                //顺时针旋转270°
                translateToCenter = CGAffineTransformMakeTranslation(0.0, videoTrack.naturalSize.width);
                mixedTransform = CGAffineTransformRotate(translateToCenter,M_PI_2*3.0);
                waterMarkVideoComposition.renderSize = CGSizeMake(videoTrack.naturalSize.height,videoTrack.naturalSize.width);
            }
            
            
            AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, [asset duration]);
            AVMutableVideoCompositionLayerInstruction *roateLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            [roateLayerInstruction setTransform:mixedTransform atTime:kCMTimeZero];
            
            roateInstruction.layerInstructions = @[roateLayerInstruction];
            //将视频方向旋转加入到视频处理中
            waterMarkVideoComposition.instructions = @[roateInstruction];
            waterMarkVideoComposition.frameDuration = CMTimeMake(1, 30);
            
            AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
            session.outputURL = outputURL;
            session.videoComposition = waterMarkVideoComposition;
            session.outputFileType = AVFileTypeMPEG4;
            startHandler(session);
            //导出视频
            [session exportAsynchronouslyWithCompletionHandler:^(void)
             {
                 endHandler(str, session);
             }];
        }
        
    }];
}

//获取当前视频的偏移角度
- (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url
{
    NSUInteger degress = 0;
    AVAsset *asset = [AVAsset assetWithURL:url];
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
    return degress;
}

//添加幻灯片条目
- (NSDictionary *)addSliderItemWithIDArray:(NSArray *)array andTitle:(NSString *)title
{
    for (NSDictionary * dict in self.sliderArray) {
        //判断是否已经是添加到已有幻灯片
        if ([[dict objectForKey:@"title"] isEqualToString:title]) {
            
            //更新当前幻灯片的包含的照片ID
            NSMutableArray * tempArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"ids"]];
            [tempArray addObjectsFromArray:array];
            
            NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [tempDict setObject:tempArray forKey:@"ids"];
            [tempDict setObject:[self transformDate:[NSDate date]] forKey:@"createTime"];
            if ([dict objectForKey:@"sliderTime"]) {
                [tempDict setObject:[dict objectForKey:@"sliderTime"] forKey:@"sliderTime"];
            }else{
                [tempDict setObject:[NSNumber numberWithInteger:5] forKey:@"sliderTime"];
            }
            
            [self.sliderArray removeObject:dict];
            [self.sliderArray insertObject:tempDict atIndex:0];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self synchronizeLocalSliderFile];
            });
            return tempDict;
        }
    }
    NSDictionary * dict = @{@"title":title, @"ids":array, @"createTime":[self transformDate:[NSDate date]], @"sliderTime":[NSNumber numberWithInteger:5]};
    [self.sliderArray insertObject:dict atIndex:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self synchronizeLocalSliderFile];
    });
    return dict;
}

- (NSDictionary *)setSlideTime:(NSInteger)time forTitile:(NSString *)title
{
    for (NSDictionary * dict in self.sliderArray) {
        if ([[dict objectForKey:@"title"] isEqualToString:title]) {
            NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [tempDict setObject:[NSNumber numberWithInteger:time] forKey:@"sliderTime"];
            [tempDict setObject:[self transformDate:[NSDate date]] forKey:@"createTime"];
            [self.sliderArray removeObject:dict];
            [self.sliderArray insertObject:tempDict atIndex:0];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self synchronizeLocalSliderFile];
            });
            return tempDict;
        }
    }
    return nil;
}

- (NSDictionary *)removeSliderItemWithIndexPaths:(NSArray *)array withTitle:(NSString *)title
{
    for (NSDictionary * dict in self.sliderArray) {
        if ([[dict objectForKey:@"title"] isEqualToString:title]) {
            
            NSMutableArray * source = [NSMutableArray arrayWithArray:[dict objectForKey:@"ids"]];
            for (NSInteger i = 0; i < array.count; i++) {
                NSIndexPath * indexPath = [array objectAtIndex:i];
                if (indexPath.row < source.count) {
                    [source removeObjectAtIndex:indexPath.row];
                }
            }
            
            NSMutableDictionary * tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [tempDict setObject:source forKey:@"ids"];
            [tempDict setObject:[self transformDate:[NSDate date]] forKey:@"createTime"];
            
            [self.sliderArray removeObject:dict];
            [self.sliderArray insertObject:tempDict atIndex:0];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self synchronizeLocalSliderFile];
            });
            return tempDict;
        }
    }
    return nil;
}

- (void)removeAllSliderListWithTitle:(NSString *)title
{
    for (NSDictionary * dict in self.sliderArray) {
        if ([[dict objectForKey:@"title"] isEqualToString:title]) {
            [self.sliderArray removeObject:dict];
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self synchronizeLocalSliderFile];
    });
}

- (PhotoLibraryModel *)createSliderWithIDArray:(NSArray *)array andTitle:(NSString *)title
{
    NSDictionary * dict = @{@"title":title, @"ids":array, @"createTime":[self transformDate:[NSDate date]]};
    [self.sliderArray insertObject:dict atIndex:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self synchronizeLocalSliderFile];
    });
    return [self getSliderModelItemWithInfoDict:dict];
}

- (PhotoLibraryModel *)getSliderModelItemWithInfoDict:(NSDictionary *)dict
{
    PhotoLibraryModel * model = [[PhotoLibraryModel alloc] init];
    model.title = [dict objectForKey:@"title"];
    model.createTime = [dict objectForKey:@"createTime"];
    model.isSystemLibrary = NO;
    return model;
}

- (NSArray *)getSliderList
{
    NSMutableArray * array = [NSMutableArray new];
    for (NSDictionary * dict in self.sliderArray) {
        [array addObject:[self getSliderModelItemWithInfoDict:dict]];
    }
    return [NSArray arrayWithArray:array];
}

- (void)removeSliderItemWithIndex:(NSInteger)index
{
    [self.sliderArray removeObjectAtIndex:index];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self synchronizeLocalSliderFile];
    });
}

- (void)removeSliderItemWithTitle:(NSString *)title
{
    for (NSDictionary * dict in self.sliderArray) {
        if ([[dict objectForKey:@"title"] isEqualToString:title]) {
            [self.sliderArray removeObject:dict];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self synchronizeLocalSliderFile];
            });
            break;
        }
    }
}

- (BOOL)synchronizeLocalSliderFile
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:UserLibraryPath]) {
        [manager removeItemAtPath:UserLibraryPath error:nil];
        return [self.sliderArray writeToFile:UserLibraryPath atomically:NO];
    }
    return [self.sliderArray writeToFile:UserLibraryPath atomically:NO];
}

- (NSString *)transformDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

//苹果系统相册名转化中文
- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }
    return title;
}

- (void)compressImageWithImage:(UIImage *)image finished:(void (^)(NSData *))finished
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData*  data = [NSData data];
        data = UIImageJPEGRepresentation(image, 1);
        float tempX = 0.9;
        NSInteger length = data.length;
        while (data.length > ImageSize) {
            data = UIImageJPEGRepresentation(image, tempX);
            tempX -= 0.1;
            if (data.length == length) {
                break;
            }
            length = data.length;
        }
        
        finished(data);
    });
}

- (void)getImageFromPHAssetSourceWithAsset:(PHAsset *)asset success:(void (^)(UIImage *))success
{
    //导出图片的参数
    PHImageRequestOptions *option = [PHImageRequestOptions new];
    option.synchronous = YES; //开启线程同步
    option.resizeMode = PHImageRequestOptionsResizeModeExact; //标准的图片尺寸
    option.version = PHImageRequestOptionsVersionCurrent; //获取用户操作的图片
    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat; //高质量
    
    CGFloat width = asset.pixelWidth;
    CGFloat height = asset.pixelHeight;
    CGFloat scale = width / height;
    CGFloat tempScale = 1920 / 1080.f;
    CGSize size;
    if (scale > tempScale) {
        size = CGSizeMake(1920, 1920 / scale);
    }else{
        size = CGSizeMake(1080 * scale, 1080);
    }
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        success(result);
    }];
}

// 获取视频第一帧或是第几帧的图片
- (UIImage *)imageWithVideoUrl:(NSURL *)urlAsSet atTime:(NSTimeInterval)tmpTime

{
     AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlAsSet options:nil];
    AVAssetImageGenerator* gen = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    gen.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    // 定义获取tmpTime帧处的视频截图
    CMTime time = CMTimeMakeWithSeconds(tmpTime, asset.duration.timescale);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    // 获取time处的视频截图
    CGImageRef  image = [gen  copyCGImageAtTime: time actualTime: &actualTime error:&error];
    CMTimeShow(actualTime);
    
    // 将CGImageRef转换为UIImage
    UIImage *thumb = [[UIImage alloc] initWithCGImage: image];
    
    CGImageRelease(image);
    
    return  thumb;
    
}

- (void)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)tmpTime completion:(void(^)(UIImage *image))completion{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        gen.appliesPreferredTrackTransform = YES;
        
        CMTime time = CMTimeMakeWithSeconds(tmpTime, 600);
        
        NSError *error = nil;
        
        CMTime actualTime;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *thumbImg = [[UIImage alloc] initWithCGImage:image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(thumbImg);
            }
        });
    });
}

@end
