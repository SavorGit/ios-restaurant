//
//  ResUploadVideoView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResUploadVideoView.h"
#import "RestaurantPhotoTool.h"
#import "RDAlertView.h"
#import "SAVORXAPI.h"

static NSInteger PART_DATA_SIZE = 500 * 1024; //视频分片大小(单位：kb)

@interface ResUploadVideoView ()

@property (nonatomic, strong) NSArray * assetIDS;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, copy)   NSString * groupName;

@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) NSArray * videoArray;
@property (nonatomic, strong) NSArray * videoInfoArray;

@property (nonatomic, copy) NSString * currentFileName;
@property (nonatomic, assign) NSInteger currentFileSize;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger handleStartPoint;
@property (nonatomic, strong) NSFileHandle * fileHandle;

@property (nonatomic, assign) NSInteger failedCount;

@property (nonatomic, copy) void (^block)(NSError * error);
@end

@implementation ResUploadVideoView

- (instancetype)initWithAssetIDS:(NSArray *)assetIDS totalTime:(NSInteger)totalTime quality:(NSInteger)quality groupName:(NSString *)groupName handler:(void (^)(NSError *))handler
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.block = handler;
        self.assetIDS = assetIDS;
        self.totalTime = totalTime;
        self.groupName = groupName;
        self.quality = quality;
        self.handleStartPoint = 0;
        [self creatSubViews];
    }
    return self;
}

- (void)startUpload
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.frame = CGRectMake(0, -kMainBoundsHeight, self.bounds.size.width, self.bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.2f animations:^{
        self.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        [self uploadVideosInfo];
    }];
}

- (void)endUpload
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [UIView animateWithDuration:.2f animations:^{
        CGRectMake(0, -kMainBoundsHeight, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [[NSFileManager defaultManager] removeItemAtPath:RestaurantTempVideoPath error:nil];
}

- (void)uploadVideosInfo
{
    NSMutableArray *videoInfoArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.assetIDS.count; i++) {
        NSString * str = [self.assetIDS objectAtIndex:i];
        PHAsset * currentAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
        if (currentAsset) {
            //配置导出参数
            PHVideoRequestOptions *options = [PHVideoRequestOptions new];
            options.networkAccessAllowed = YES;
            
            [[PHImageManager defaultManager] requestAVAssetForVideo:currentAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                AVURLAsset * urlAsset = (AVURLAsset *)asset;
                if ([urlAsset respondsToSelector:@selector(URL)]) {
                    NSError *error = nil;
                    
                    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[urlAsset.URL path] error:&error];
                    long long fileSize = 0;
                    if (!error && fileDict) {
                        fileSize = [fileDict fileSize];
                    }
                    
                    if (self.quality == 0) {
                        fileSize = fileSize / 2;
                    }else{
                        fileSize = (fileSize * 9) / 10;
                    }
                    
                    NSString *picName = currentAsset.localIdentifier;
                    NSString *nameStr=[picName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                    nameStr = [NSString stringWithFormat:@"%@type%ld", nameStr, self.quality];
                    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,@"name", [NSNumber numberWithLongLong:fileSize],@"length",@"0",@"exist",nil];
                    [videoInfoArr addObject:tmpDic];
                    
                    if (i == self.assetIDS.count - 1) {
                        self.videoInfoArray = [NSArray arrayWithArray:videoInfoArr];
                        [self requestNetUpVideosInfoWithForce:0 complete:NO];
                    }
                }
            }];
        }
    }
}

// 上传视频组信息
- (void)requestNetUpVideosInfoWithForce:(NSInteger )force complete:(BOOL)complete
{
    [SAVORXAPI postVideoInfoWithURL:STBURL name:self.groupName duration:[NSString stringWithFormat:@"%ld", self.totalTime] videos:self.videoInfoArray force:force success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        
        if ([[result objectForKey:@"result"] integerValue] == 0) {
            NSArray * resultArray = result[@"videos"];
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:resultArray];
            
            for (int i = 0; i < resultArray.count; i ++) {
                NSDictionary *videoDic = [resultArray objectAtIndex:i];
                NSInteger exist = [videoDic[@"exist"] integerValue];
                if (exist == 1) {
                    [tmpArray removeObject:videoDic];
                }
            }
            if (tmpArray.count > 0) {
                self.videoArray = [NSArray arrayWithArray:tmpArray];
                [self uploadVideos];
            }else{
                if (complete) {
                    self.block(nil);
                }else{
                    [self performSelector:@selector(setProgressLabelTextWithProgress:) withObject:@{@"progress":[NSString stringWithFormat:@"%u%%", arc4random()%25+1]} afterDelay:.3f];
                    [self performSelector:@selector(setProgressLabelTextWithProgress:) withObject:@{@"progress":[NSString stringWithFormat:@"%u%%", arc4random()%25+26]} afterDelay:.5f];
                    [self performSelector:@selector(setProgressLabelTextWithProgress:) withObject:@{@"progress":[NSString stringWithFormat:@"%u%%", arc4random()%30+51]} afterDelay:.5f];
                    [self performSelector:@selector(setProgressLabelTextWithProgress:) withObject:@{@"progress":@"100%"} afterDelay:.9f];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.block(nil);
                    });
                }
            }
        }else if ([[result objectForKey:@"result"] integerValue] == 4){
            
            NSString *infoStr = [result objectForKey:@"info"];
            RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"抢投提示" message:[NSString stringWithFormat:@"当前%@正在投屏，是否继续投屏?",infoStr]];
            RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
                self.block([NSError errorWithDomain:@"com.uploadVideo" code:201 userInfo:nil]);
            } bold:NO];
            RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"继续投屏" handler:^{
                [self requestNetUpVideosInfoWithForce:1 complete:NO];
                
            } bold:NO];
            [alertView addActions:@[action,actionOne]];
            [alertView show];
            
        }
        else{
            self.block([NSError errorWithDomain:@"com.uploadVideo" code:202 userInfo:result]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.block([NSError errorWithDomain:@"com.uploadVideo" code:203 userInfo:nil]);
    }];
}

- (void)setProgressLabelTextWithProgress:(NSDictionary *)object
{
    self.progressLabel.text = [object objectForKey:@"progress"];
}

- (void)uploadVideos
{
    if (self.currentIndex > self.videoArray.count - 1) {
        if (![[UIApplication sharedApplication].keyWindow viewWithTag:677]) {
            self.block(nil);
        }
        return;
    }
    
    NSDictionary *tmpDic = [self.videoArray objectAtIndex:self.currentIndex];
    NSString * str = tmpDic[@"name"];
    self.currentFileName = str;
    str = [str componentsSeparatedByString:@"type"].firstObject;
    str = [str stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    PHAsset * asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
    
    NSString * type;
    if (self.quality == 1) {
        type = AVAssetExportPresetHighestQuality;
    }else{
        type = AVAssetExportPresetMediumQuality;
    }
    [RestaurantPhotoTool exportVideoToMP4WithAsset:asset startHandler:^(AVAssetExportSession *session) {
        
    } endHandler:^(NSString *path, AVAssetExportSession *session) {
        
        self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        [self.fileHandle seekToFileOffset:0];
        self.handleStartPoint = 0;
        self.failedCount = 0;
        
        NSError *error = nil;
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            self.currentFileSize = [fileDict fileSize];
        }
        
        if (self.currentFileSize > PART_DATA_SIZE) {
            [self uploadCurrentVideoWithEnd:NO];
        }else{
            [self uploadCurrentVideoWithEnd:YES];
        }
        
    } exportPresetType:type];
}

- (void)uploadCurrentVideoWithEnd:(BOOL)end;
{
    if (self.failedCount >= 3) {
        self.block([NSError errorWithDomain:@"com.uploadVideo" code:204 userInfo:nil]);
        return;
    }
    NSData * data;
    NSString * range;
    if (end) {
        data = [self.fileHandle readDataToEndOfFile];
        range = [NSString stringWithFormat:@"%ld-", self.handleStartPoint];
    }else{
        data = [self.fileHandle readDataOfLength:PART_DATA_SIZE];
        range = [NSString stringWithFormat:@"%ld-%ld", self.handleStartPoint, self.handleStartPoint + PART_DATA_SIZE];
    }
    
    [SAVORXAPI postVideoWithURL:STBURL data:data name:self.currentFileName sliderName:self.groupName range:range progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        if ([[result objectForKey:@"result"] integerValue] == 4){
            
            self.failedCount = 0;
            self.currentIndex++;
            
            CGFloat pro = (CGFloat)self.currentIndex / self.videoArray.count * 100.f;
            self.progressLabel.text = [NSString stringWithFormat:@"%ld%%", (long)pro];
            
            UIView * tempAlert = [[UIApplication sharedApplication].keyWindow viewWithTag:677];
            if (tempAlert) {
                [tempAlert removeFromSuperview];
            }
            
            NSString *infoStr = [result objectForKey:@"info"];
            RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"抢投提示" message:[NSString stringWithFormat:@"当前%@正在投屏，是否继续投屏?",infoStr]];
            RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
                self.block([NSError errorWithDomain:@"com.uploadImage" code:201 userInfo:nil]);
            } bold:NO];
            RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"继续投屏" handler:^{
                [self requestNetUpVideosInfoWithForce:1 complete:YES];
                
            } bold:NO];
            [alertView addActions:@[action,actionOne]];
            alertView.tag = 677;
            [alertView show];
            
        }else if([[result objectForKey:@"result"] integerValue] == 0){
            self.failedCount = 0;
            
            CGFloat pro = (CGFloat)self.currentIndex / self.videoArray.count * 100.f;
            self.progressLabel.text = [NSString stringWithFormat:@"%ld%%", (long)pro];
            
            if (!end) {
                self.handleStartPoint += PART_DATA_SIZE;
                if (self.handleStartPoint >= self.currentFileSize) {
                    [self uploadCurrentVideoWithEnd:YES];
                }else{
                    [self uploadCurrentVideoWithEnd:NO];
                }
            }else{
                self.currentIndex++;
                [self uploadVideos];
            }
        }else{
            self.failedCount++;
            if (self.failedCount >= 3) {
                self.block([NSError errorWithDomain:@"com.uploadVideo" code:202 userInfo:result]);
                return;
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        self.failedCount++;
        [self uploadCurrentVideoWithEnd:end];
        
    }];
}

- (void)creatSubViews
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.92f];
    
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.font = [UIFont systemFontOfSize:24];
    self.progressLabel.textColor = UIColorFromRGB(0xff6a2f);
    self.progressLabel.backgroundColor = [UIColor clearColor];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.text = @"0%";
    [self addSubview:self.progressLabel];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerY.equalTo(self).offset(-40);
        make.centerX.equalTo(self);
    }];
    
    UILabel *conLabel = [[UILabel alloc] init];
    conLabel.font = [UIFont systemFontOfSize:16];
    conLabel.textColor = UIColorFromRGB(0xffffff);
    conLabel.backgroundColor = [UIColor clearColor];
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.text = @"正在载入视频组";
    [self addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.progressLabel.mas_bottom).offset(8);
    }];
}

@end
