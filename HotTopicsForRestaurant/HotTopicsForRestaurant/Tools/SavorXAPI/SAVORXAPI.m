//
//  SAVORXAPI.m
//  SavorX
//
//  Created by 郭春城 on 16/8/4.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "SAVORXAPI.h"
#import "GCCGetInfo.h"
#import "GCCKeyChain.h"

#import <AudioToolbox/AudioToolbox.h>

#import "BGNetworkManager.h"
#import "NetworkConfiguration.h"
#import "HSWebServerManager.h"
#import "HSversionUpgradeRequest.h"
#import "RDAlertView.h"
#import "RDAlertView.h"
#import "RDAlertAction.h"


#define version_code @"version_code"

@implementation SAVORXAPI

+ (void)configApplication
{
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x333333)];//item颜色
    
    //item字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x333333), NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    //设置标题颜色和字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x333333), NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (![GCCKeyChain load:keychainID]) {
        [GCCKeyChain save:keychainID data:identifierNumber];
    }
    [GlobalData shared].deviceID = [GCCKeyChain load:keychainID];
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[NetworkConfiguration configuration]];
}

+ (AFHTTPSessionManager *)sharedManager {
    static dispatch_once_t once;
    static AFHTTPSessionManager *manager;
    dispatch_once(&once, ^ {
        manager = [[AFHTTPSessionManager alloc] init];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"1.0" forHTTPHeaderField:@"version"];
        manager.requestSerializer.timeoutInterval = 15.f;
    });
    return manager;
}

+ (NSURLSessionDataTask *)postWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self sharedManager].requestSerializer.timeoutInterval = 15.f;
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask * task = [[self sharedManager] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        if ([json objectForKey:@"projectId"]) {
            [GlobalData shared].projectId = [json objectForKey:@"projectId"];
        }
        success(task, json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    return task;
}

+ (NSURLSessionDataTask *)getWithURL:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    [self sharedManager].requestSerializer.timeoutInterval = 15.f;
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask * task = [[self sharedManager] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        if ([json objectForKey:@"projectId"]) {
            [GlobalData shared].projectId = [json objectForKey:@"projectId"];
        }
        success(task, json);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    return task;
}

+ (void)showAlertWithString:(NSString *)str withController:(UIViewController *)VC
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:action];
    [VC presentViewController:alert animated:YES completion:nil];
}

//通过最上层的window以及对应其底层响应者获取当前视图控制器
+ (UIViewController *)getCurrentViewController
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            
            UIViewController * viewController = nil;
            UIView *frontView = [[window subviews] objectAtIndex:0];
            id nextResponder = [frontView nextResponder];
            
            if ([nextResponder isKindOfClass:[UIViewController class]]){
                viewController = nextResponder;
            }
            else{
                viewController = window.rootViewController;
            }
            return viewController;
            
            break;
        }else{
            return [UIApplication sharedApplication].keyWindow.rootViewController;
        }
    }
    return nil;
}

+ (void)showAlertWithMessage:(NSString *)message
{
    RDAlertView * alert = [[RDAlertView alloc] initWithTitle:@"提示" message:message];
    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"我知道了" handler:^{
        
    } bold:YES];
    [alert addActions:@[action]];
    alert.tag = 677;
    [alert show];
}


+ (void)successRing
{
    SystemSoundID soundID = 1504;
    AudioServicesPlaySystemSound(soundID);
}

+ (void)checkVersionUpgrade
{
    HSversionUpgradeRequest * request = [[HSversionUpgradeRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * info = [response objectForKey:@"result"];
        
        if ([[info objectForKey:@"device_type"] integerValue] == 6) {
            
            NSArray * detailArray =  info[@"remark"];
            
            NSString * detail = @"本次更新内容:\n";
            for (int i = 0; i < detailArray.count; i++) {
                NSString * tempsTr = [detailArray objectAtIndex:i];
                detail = [detail stringByAppendingString:tempsTr];
            }
            
            NSInteger update_type = [[info objectForKey:@"update_type"] integerValue];
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
            view.tag = 4444;
            [[UIApplication sharedApplication].keyWindow addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Helper autoWidthWith:320], [Helper autoHeightWith:344])];
            [imageView setImage:[UIImage imageNamed:@"banbengengxin_bg"]];
            imageView.center = CGPointMake(kMainBoundsWidth / 2, kMainBoundsHeight / 2);
            imageView.userInteractionEnabled = YES;
            [view addSubview:imageView];
            
            UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, [Helper autoHeightWith:75], imageView.frame.size.width - 40, imageView.frame.size.height - [Helper autoHeightWith:155])];
            [imageView addSubview:scrollView];
            
            CGRect rect = [detail boundingRectWithSize:CGSizeMake(scrollView.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height + 20)];
            label.textColor = [UIColor blackColor];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:15];
            label.text = detail;
            [scrollView addSubview:label];
            scrollView.contentSize = label.frame.size;
            
            if (update_type == 1) {
                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1253304503"]];
              
                } bold:YES];
                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width + 20, [Helper autoHeightWith:35]);
                [imageView addSubview:leftButton];
            }else if (update_type == 0) {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.size.width / 2, imageView.frame.size.height - [Helper autoHeightWith:50], .5f, [Helper autoHeightWith:35])];
                lineView.backgroundColor = UIColorFromRGB(0xb6a482);
                [imageView addSubview:lineView];
                
                RDAlertAction * leftButton = [[RDAlertAction alloc] initVersionWithTitle:@"取消" handler:^{
                    [view removeFromSuperview];
  
                } bold:NO];
                leftButton.frame = CGRectMake(scrollView.frame.origin.x - 10, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
                [imageView addSubview:leftButton];
                
                RDAlertAction * righButton = [[RDAlertAction alloc] initVersionWithTitle:@"立即更新" handler:^{
                    [view removeFromSuperview];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1253304503"]];
                } bold:YES];
                righButton.frame =  CGRectMake(leftButton.frame.size.width + leftButton.frame.origin.x, imageView.frame.size.height - [Helper autoHeightWith:50], scrollView.frame.size.width / 2 + 10, [Helper autoHeightWith:35]);
                [imageView addSubview:righButton];
            }
        }
        
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

+ (void)cancelAllURLTask
{
    [[self sharedManager].operationQueue cancelAllOperations];
    [[self sharedManager].uploadTasks makeObjectsPerformSelector:@selector(cancel)];
    [[self sharedManager].tasks makeObjectsPerformSelector:@selector(cancel)];
    [[self sharedManager].downloadTasks makeObjectsPerformSelector:@selector(cancel)];
    [[self sharedManager].dataTasks makeObjectsPerformSelector:@selector(cancel)];
}

//投幻灯片上传图片
+ (NSURLSessionDataTask *)postImageWithURL:(NSString *)urlStr data:(NSData *)data name:(NSString *)name sliderName:(NSString *)sliderName progress:(void (^)(NSProgress *))progressBlock success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSString * hostURL = [NSString stringWithFormat:@"%@/restaurant/picUpload?deviceId=%@&deviceName=%@", urlStr,[GlobalData shared].deviceID, [GCCGetInfo getIphoneName]];
    
    hostURL = [hostURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"fileName": name,
                                 @"pptName": sliderName
                                 };
    NSURLSessionDataTask * task = [[self sharedManager] POST:hostURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"fileUpload" fileName:name mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError* error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:&error];
        
        if ([[response objectForKey:@"result"] integerValue] == 0) {
            if (success) {
                success(task,response);
            }
        }else{
            if (success) {
                success(task,response);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)postVideoInfoWithURL:(NSString *)urlStr name:(NSString *)name duration:(NSString *)duration videos:(NSArray *)videos force:(NSInteger)force success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    urlStr = [NSString stringWithFormat:@"%@/restaurant/v-ppt?deviceId=%@&deviceName=%@&force=%ld", urlStr,[GlobalData shared].deviceID, [GCCGetInfo getIphoneName],force];
    
    NSDictionary *parameters = @{@"name": name,
                                 @"duration": duration,
                                 @"videos": videos
                                 };
    
    NSURLSessionDataTask * task = [self postWithURL:urlStr parameters:parameters success:success failure:failure];
    return task;
}

//投视频上传视频
+ (NSURLSessionDataTask *)postVideoWithURL:(NSString *)urlStr data:(NSData *)data name:(NSString *)name sliderName:(NSString *)sliderName range:(NSString *)range progress:(void (^)(NSProgress *))progressBlock success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSString * hostURL = [NSString stringWithFormat:@"%@/restaurant/vidUpload?deviceId=%@&deviceName=%@", urlStr,[GlobalData shared].deviceID, [GCCGetInfo getIphoneName]];
    
    hostURL = [hostURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{@"fileName": name,
                                 @"pptName": sliderName,
                                 @"range": range};
    NSURLSessionDataTask * task = [[self sharedManager] POST:hostURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"fileUpload" fileName:name mimeType:@"video/mpeg4"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgress) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError* error;
        NSDictionary* response = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:&error];
        
        if ([[response objectForKey:@"result"] integerValue] == 0) {
            if (success) {
                success(task,response);
            }
        }else{
            if (success) {
                success(task,response);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task,error);
        }
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)postImageInfoWithURL:(NSString *)urlStr name:(NSString *)name duration:(NSString *)duration interval:(NSString *)interval images:(NSArray *)images force:(NSInteger)force success:(void (^)(NSURLSessionDataTask *, NSDictionary *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    urlStr = [NSString stringWithFormat:@"%@/restaurant/ppt?deviceId=%@&deviceName=%@&force=%ld", urlStr,[GlobalData shared].deviceID, [GCCGetInfo getIphoneName],force];
    
    NSDictionary *parameters = @{@"name": name,
                                 @"duration": duration,
                                 @"interval": interval,
                                 @"images": images
                                 };
    
    NSURLSessionDataTask * task = [self postWithURL:urlStr parameters:parameters success:success failure:failure];
    return task;
}

+ (void)ScreenDemandShouldBackToTVWithSuccess:(void (^)())successBlock failure:(void (^)())failureBlock
{
    MBProgressHUD * hud = [MBProgressHUD showBackDemandInView:[UIApplication sharedApplication].keyWindow];
    if ([GlobalData shared].isBindRD) {
        NSString * urlStr = [NSString stringWithFormat:@"%@/restaurant/stop?deviceId=%@", STBURL, [GlobalData shared].deviceID];
        
        [self postWithURL:urlStr parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
            [hud hideAnimated:NO];
            if ([[result objectForKey:@"result"] integerValue] == 0){
                if (successBlock) {
                    successBlock();
                }
                [Helper showTextHUDwithTitle:@"投屏已经退出" delay:1.f];
            }else{
                [Helper showTextHUDwithTitle:[NSString stringWithFormat:@"\"%@\"包间没有投屏", [Helper getWifiName]] delay:1.f];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [hud hideAnimated:NO];
            [Helper showTextHUDwithTitle:@"退出投屏失败" delay:1.f];
            if (failureBlock) {
                failureBlock();
            }
        }];
    }else{
        [hud hideAnimated:NO];
    }
}

+ (void)callCodeWithSuccess:(void (^)())successBlock failure:(void (^)())failureBlock
{
    __block BOOL hasSuccess = NO; //记录是否呼码成功过
    __block NSInteger hasFailure = 0; //记录失败次数
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDInView:[UIApplication sharedApplication].keyWindow];
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/execute/call-tdc", [GlobalData shared].callQRCodeURL];
    [SAVORXAPI getWithURL:platformUrl parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hideAnimated:NO];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            successBlock();
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        [hud hideAnimated:NO];
        failureBlock();
    }];
    
    NSString *hosturl = [NSString stringWithFormat:@"%@/command/execute/call-tdc", [GlobalData shared].secondCallCodeURL];
    [SAVORXAPI getWithURL:hosturl parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hideAnimated:NO];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            successBlock();
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        [hud hideAnimated:NO];
        failureBlock();
    }];
    
    NSString *boxPlatformURL = [NSString stringWithFormat:@"%@/command/execute/call-tdc", [GlobalData shared].thirdCallCodeURL];
    [SAVORXAPI getWithURL:boxPlatformURL parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hideAnimated:NO];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            successBlock();
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        [hud hideAnimated:NO];
        failureBlock();
    }];
    
    NSString *boxURL = [NSString stringWithFormat:@"%@/showCode?deviceId=%@", [GlobalData shared].boxCodeURL, [GlobalData shared].deviceID];
    [SAVORXAPI getWithURL:boxURL parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        [hud hideAnimated:NO];
        NSInteger code = [result[@"code"] integerValue];
        if(code == 10000){
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            successBlock();
        }
        //
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //
        
        hasFailure += 1;
        
        if (hasFailure < 4) {
            return;
        }
        [hud hideAnimated:NO];
        failureBlock();
    }];
}

+ (UILabel *)labelWithFrame:(CGRect)frame TextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)Alignment
{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = Alignment;
    
    return label;
}

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setBackgroundColor:backgroundColor];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title cornerRadius:(CGFloat)cornerRadius
{
    UIButton * button = [self buttonWithTitleColor:titleColor font:font backgroundColor:backgroundColor title:title];
    button.layer.cornerRadius = cornerRadius;
    button.layer.masksToBounds = YES;
    return button;
}

@end
