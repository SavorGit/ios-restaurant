//
//  ReUploadingImagesView.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/6/14.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReUploadingImagesView.h"
#import "RestaurantPhotoTool.h"
#import "SAVORXAPI.h"
#import "RDAlertView.h"

@interface ReUploadingImagesView()

@property(nonatomic ,strong)UILabel *percentageLab;

@property (nonatomic, strong) NSDictionary * uploadParams;
@property (nonatomic, strong) NSArray * imageInfoArray;
@property (nonatomic, strong) NSArray * imageArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger failedCount;
@property (nonatomic, assign) NSInteger quality;

@property (nonatomic, assign) BOOL stopUpload;

@end

@implementation ReUploadingImagesView

- (instancetype)initWithImagesArray:(NSArray *)imageArr otherDic:(NSDictionary *)parmDic handler:(void (^)(NSError *))handler{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
         self.block = handler;
        self.uploadParams = parmDic;
        self.currentIndex = 0;
        self.failedCount = 0;
        self.quality = [[parmDic objectForKey:@"quality"] integerValue];
         [self creatSubViews];
        
        // 延迟发送网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dealWithSlideInfo:imageArr];
        });
        
    }
    return self;
}

- (void)creatSubViews{
    
    self.tag = 10001;
    self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.92f];
    
    self.percentageLab = [[UILabel alloc] init];
    self.percentageLab.font = [UIFont systemFontOfSize:24];
    self.percentageLab.textColor = UIColorFromRGB(0xff6a2f);
    self.percentageLab.backgroundColor = [UIColor clearColor];
    self.percentageLab.textAlignment = NSTextAlignmentCenter;
    self.percentageLab.text = @"0%";
    [self addSubview:self.percentageLab];
    [self.percentageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerY.equalTo(self).offset(-40);
        make.centerX.equalTo(self);
    }];
    
    UILabel *conLabel = [[UILabel alloc] init];
    conLabel.font = [UIFont systemFontOfSize:16];
    conLabel.textColor = UIColorFromRGB(0xffffff);
    conLabel.backgroundColor = [UIColor clearColor];
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.text = @"正在载入幻灯片";
    [self addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.percentageLab.mas_bottom).offset(8);
    }];
    
    UIButton * cancleButton = [Helper buttonWithTitleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor clearColor] title:@"取消" cornerRadius:4.f];
    [self addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 25));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(conLabel.mas_bottom).offset(8);
    }];
    cancleButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cancleButton.layer.borderWidth = 1.f;
    [cancleButton addTarget:self action:@selector(cancleButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancleButtonDidClicked
{
    [[SAVORXAPI sharedManager].operationQueue cancelAllOperations];
    self.stopUpload = YES;
    self.block([NSError errorWithDomain:@"com.uploadImage" code:201 userInfo:nil]);
}

// 处理上传信息数据
- (void)dealWithSlideInfo:(NSArray *)dataArray{
    
    NSMutableArray *imgInfoArr = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < dataArray.count; i++) {
        NSString * str = [dataArray objectAtIndex:i];
        PHAsset * currentAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
        if (currentAsset) {
            NSString *picName = currentAsset.localIdentifier;
            NSString *nameStr=[picName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            nameStr = [NSString stringWithFormat:@"%@type%ld", nameStr, self.quality];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,@"name",@"0",@"exist",nil];
            [imgInfoArr addObject:tmpDic];
        }
    }
    self.imageInfoArray = [NSArray arrayWithArray:imgInfoArr];
    [self requestNetUpSlideInfoWithForce:0 complete:NO];
}

// 上传幻灯片信息
- (void)requestNetUpSlideInfoWithForce:(NSInteger )force complete:(BOOL)complete{
    
//    NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080",[GlobalData shared].boxUrlStr];
    
    if (self.stopUpload) {
        return;
    }
    
    [SAVORXAPI postImageInfoWithURL:STBURL name:[self.uploadParams objectForKey:@"sliderName"] duration:[self.uploadParams objectForKey:@"totalTime"] interval:[self.uploadParams objectForKey:@"time"] images:self.imageInfoArray  force:force  success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        if ([[result objectForKey:@"result"] integerValue] == 0) {
            NSArray * resultArray = result[@"images"];
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:resultArray];
            
            for (int i = 0; i < resultArray.count; i ++) {
                NSDictionary *imgDic = [resultArray objectAtIndex:i];
                NSInteger exist = [imgDic[@"exist"] integerValue];
                if (exist == 1) {
                    [tmpArray removeObject:imgDic];
                }
            }
            if (tmpArray.count > 0) {
                self.imageArray = [NSArray arrayWithArray:tmpArray];
                [self upLoadImages];
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
            
//            NSString *infoStr = [result objectForKey:@"info"];
            RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"提示" message:@"用户正在投屏，请稍后重试"];
            RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
                self.block([NSError errorWithDomain:@"com.uploadImage" code:201 userInfo:nil]);
            } bold:YES];
            [alertView addActions:@[action]];
            [alertView show];
//            RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"抢投提示" message:[NSString stringWithFormat:@"当前%@正在投屏，是否继续投屏?",infoStr]];
//            RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
//                self.block([NSError errorWithDomain:@"com.uploadImage" code:201 userInfo:nil]);
//            } bold:NO];
//            RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"继续投屏" handler:^{
//                [self requestNetUpSlideInfoWithForce:1 complete:NO];
//
//            } bold:NO];
//            [alertView addActions:@[action,actionOne]];
//            [alertView show];
            
        }
        else{
            self.block([NSError errorWithDomain:@"com.uploadImage" code:202 userInfo:result]);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.block([NSError errorWithDomain:@"com.uploadImage" code:203 userInfo:nil]);
    }];
}

- (void)setProgressLabelTextWithProgress:(NSDictionary *)object
{
    self.percentageLab.text = [object objectForKey:@"progress"];
}

// 上传幻灯片图片
- (void)upLoadImages
{
    if (self.stopUpload) {
        return;
    }
    if (self.currentIndex > self.imageArray.count - 1) {
        if (![[UIApplication sharedApplication].keyWindow viewWithTag:677]) {
            self.block(nil);
        }
        return;
    }
    if (self.failedCount >= 3) {
        self.block([NSError errorWithDomain:@"com.uploadImage" code:204 userInfo:nil]);
        return;
    }
    
    PHImageRequestOptions * option = [PHImageRequestOptions new];
    option.resizeMode = PHImageRequestOptionsResizeModeExact; //标准的图片尺寸
    option.networkAccessAllowed = YES; //允许访问iCloud
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat; //高质量
    
    PHAsset * asset;
    NSDictionary *tmpDic = [self.imageArray objectAtIndex:self.currentIndex];
    
    NSString * str = tmpDic[@"name"];
    str = [str componentsSeparatedByString:@"type"].firstObject;
    str = [str stringByReplacingOccurrencesOfString:@"_" withString:@"/"];
    asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
    
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
    NSString *nameStr=tmpDic[@"name"];
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        CGFloat compression;
        if (self.quality == 1) {
            compression = 1.f;
        }else{
            compression = .4f;
        }
        
        [RestaurantPhotoTool compressImageWithImage:result compression:compression finished:^(NSData *maxData) {
            
//            NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080",[GlobalData shared].boxUrlStr];
            [SAVORXAPI postImageWithURL:STBURL data:maxData name:nameStr sliderName:[self.uploadParams objectForKey:@"sliderName"] progress:^(NSProgress *uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSDictionary *result = (NSDictionary *)responseObject;
                if ([[result objectForKey:@"result"] integerValue] == 4){
                    
                    self.failedCount = 0;
                    self.currentIndex++;
                    
                    CGFloat pro = (CGFloat)self.currentIndex / self.imageArray.count * 100.f;
                    self.percentageLab.text = [NSString stringWithFormat:@"%ld%%", (long)pro];
                    NSLog(@"进度= %.2f", pro);
                    
                    UIView * tempAlert = [[UIApplication sharedApplication].keyWindow viewWithTag:677];
                    if (tempAlert) {
                        [tempAlert removeFromSuperview];
                    }
                    
//                    NSString *infoStr = [result objectForKey:@"info"];
                    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"提示" message:@"用户正在投屏，请稍后重试"];
                    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
                        self.block([NSError errorWithDomain:@"com.uploadImage" code:201 userInfo:nil]);
                    } bold:YES];
                    [alertView addActions:@[action]];
//                    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"抢投提示" message:[NSString stringWithFormat:@"当前%@正在投屏，是否继续投屏?",infoStr]];
//                    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
//                        self.block([NSError errorWithDomain:@"com.uploadImage" code:201 userInfo:nil]);
//                    } bold:NO];
//                    RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"继续投屏" handler:^{
//                        [self requestNetUpSlideInfoWithForce:1 complete:YES];
//
//                    } bold:NO];
//                    [alertView addActions:@[action,actionOne]];
                    alertView.tag = 677;
                    [alertView show];
                    
                }else if([[result objectForKey:@"result"] integerValue] == 0){
                    self.failedCount = 0;
                    self.currentIndex++;
                    
                    CGFloat pro = (CGFloat)self.currentIndex / self.imageArray.count * 100.f;
                    self.percentageLab.text = [NSString stringWithFormat:@"%ld%%", (long)pro];
                    NSLog(@"进度= %.2f", pro);
                }else{
                    self.failedCount++;
                    if (self.failedCount >= 3) {
                        self.block([NSError errorWithDomain:@"com.uploadImage" code:202 userInfo:result]);
                        return;
                    }
                }
                
                [self upLoadImages];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                self.failedCount++;
                [self upLoadImages];
                
            }];
            
        }];
    }];
}

@end
