//
//  ReUploadingImagesView.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/6/14.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReUploadingImagesView.h"
#import "PhotoTool.h"
#import "SAVORXAPI.h"

@implementation ReUploadingImagesView

- (instancetype)initWithImagesArray:(NSArray *)imageArr otherDic:(NSDictionary *)parmDic handler:(void (^)(BOOL))handler{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
         self.block = handler;
         [self creatSubViews];
        [self requestWithSlideInfo:imageArr];
    }
    return self;
}

- (void)creatSubViews{
    
    self.tag = 10001;
    self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.92f];
    
    UILabel *percentageLab = [[UILabel alloc] init];
    percentageLab.font = [UIFont systemFontOfSize:24];
    percentageLab.textColor = UIColorFromRGB(0xff6a2f);
    percentageLab.backgroundColor = [UIColor clearColor];
    percentageLab.textAlignment = NSTextAlignmentCenter;
    percentageLab.text = @"89%";
    [self addSubview:percentageLab];
    [percentageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(61, 30));
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
        make.top.mas_equalTo(percentageLab.mas_bottom).offset(8);
    }];
}

- (void)requestWithSlideInfo:(NSArray *)dataArray{
    
    NSMutableArray *imagesInfoArr = [[NSMutableArray alloc] initWithCapacity:100];
    for (int i = 0; i < dataArray.count; i++) {
        NSString * str = [dataArray objectAtIndex:i];
        PHAsset * currentAsset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
        NSString *picName = currentAsset.localIdentifier;
        NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:picName,@"name",@"0",@"exist",nil];
        [imagesInfoArr addObject:tmpDic];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080",[GlobalData shared].boxUrlStr];
    
    [SAVORXAPI postImageInfoWithURL:urlStr name:nil duration:nil interval:nil images:imagesInfoArr success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        if ([[result objectForKey:@"result"] integerValue] == 0) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:result[@"images"]];
            
            for (int i = 0; i < tmpArray.count; i ++) {
                NSDictionary *imgDic = [tmpArray objectAtIndex:i];
                NSInteger exist = [imgDic[@"exist"] integerValue];
                if (exist == 1) {
                    [tmpArray removeObject:imgDic];
                }
            }
            [self upLoadImages:tmpArray];
        }
        else{
            [SAVORXAPI showAlertWithMessage:[result objectForKey:@"info"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)upLoadImages:(NSArray *)dataArray
{
    PHImageRequestOptions * option = [PHImageRequestOptions new];
    option.resizeMode = PHImageRequestOptionsResizeModeExact; //标准的图片尺寸
    option.networkAccessAllowed = YES; //允许访问iCloud
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat; //高质量
    
    PHAsset * asset;
    if (dataArray.count > 0) {
        NSDictionary *tmpDic = [dataArray objectAtIndex:0];
        NSString * str = tmpDic[@"name"];
        asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[str] options:nil].firstObject;
    }else{
        return;
    }
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
    NSString * name = asset.localIdentifier;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        [[PhotoTool sharedInstance] compressImageWithImage:result finished:^( NSData *maxData) {
            
            NSString *urlStr = [NSString stringWithFormat:@"http://%@:8080",[GlobalData shared].boxUrlStr];
            [SAVORXAPI postImageWithURL:urlStr data:maxData name:name sliderName:@"测试" success:^{
                self.block(YES);
            } failure:^{
                self.block(NO);

            }];
            
        }];
    }];
}

@end
