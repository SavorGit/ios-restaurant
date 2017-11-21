//
//  ResUploadVideoView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResUploadVideoView.h"
#import "RestaurantPhotoTool.h"
#import "SAVORXAPI.h"

static NSInteger PART_DATA_SIZE = 500 * 1024; //视频分片大小(单位：kb)

@interface ResUploadVideoView ()

@property (nonatomic, strong) NSArray * assetIDS;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, assign) NSInteger quality;
@property (nonatomic, copy)   NSString * groupName;

@property (nonatomic, strong) UILabel * progressLabel;
@property (nonatomic, strong) NSArray * imageInfoArray;

@property (nonatomic, copy) NSString * currentFileName;
@property (nonatomic, assign) NSInteger currentFileSize;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger handleStartPoint;
@property (nonatomic, strong) NSFileHandle * fileHandle;

@property (nonatomic, assign) NSInteger failedCount;
@end

@implementation ResUploadVideoView

- (instancetype)initWithAssetIDS:(NSArray *)assetIDS totalTime:(NSInteger)totalTime quality:(NSInteger)quality groupName:(NSString *)groupName
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.assetIDS = assetIDS;
        self.totalTime = totalTime;
        self.groupName = groupName;
        self.quality = quality;
        self.handleStartPoint = 0;
    }
    return self;
}

- (void)startUpload
{
    self.frame = CGRectMake(0, -kMainBoundsHeight, self.bounds.size.width, self.bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.2f animations:^{
        self.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        [self uploadVideosInfo];
    }];
}

- (void)uploadVideosInfo
{
    NSMutableArray *videoInfoArr = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < self.assetIDS.count; i++) {
        NSString * str = [self.assetIDS objectAtIndex:i];
        PHAsset * currentAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
        if (currentAsset) {
            NSString *picName = currentAsset.localIdentifier;
            NSString *nameStr=[picName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            nameStr = [NSString stringWithFormat:@"%@type%ld", nameStr, self.quality];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,@"name",@"0",@"exist",nil];
            [videoInfoArr addObject:tmpDic];
        }
    }
    self.imageInfoArray = [NSArray arrayWithArray:videoInfoArr];
}

- (void)uploadVideos
{
    PHAsset * asset;
    NSString * type;
    if (self.quality == 1) {
        type = AVAssetExportPresetHighestQuality;
    }else{
        type = AVAssetExportPresetMediumQuality;
    }
    [RestaurantPhotoTool exportVideoToMP4WithAsset:asset startHandler:^(AVAssetExportSession *session) {
        
    } endHandler:^(NSString *path, AVAssetExportSession *session) {
        
        self.fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
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
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        self.failedCount++;
        
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
