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

#import <UMMobClick/MobClick.h>
#import "BGNetworkManager.h"
#import "NetworkConfiguration.h"
#import "HSWebServerManager.h"
#import "HSversionUpgradeRequest.h"
#import "RDAlertView.h"
#import "RDAlertView.h"
#import "RDAlertAction.h"
#import "HsUploadLogRequest.h"
#import "HsNewUploadLogRequest.h"
#import "IQKeyboardManager.h"
#import <AliyunOSSiOS/OSSService.h>

#define version_code @"version_code"

@implementation SAVORXAPI

+ (void)configApplication
{
    [[UINavigationBar appearance] setTintColor:UIColorFromRGB(0x333333)];//item颜色
    
    //item字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff), NSFontAttributeName : [UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    
    //设置标题颜色和字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xffffff), NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
    
    //友盟统计注册
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [UMConfigInstance setAppKey:UmengAppkey];
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    if (![GCCKeyChain load:keychainID]) {
        [GCCKeyChain save:keychainID data:identifierNumber];
    }
    [GlobalData shared].deviceID = [GCCKeyChain load:keychainID];
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[NetworkConfiguration configuration]];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
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

+ (void)upLoadLogs:(NSString *)state{
    
    NSDictionary *dic;
    dic = [NSDictionary dictionaryWithObjectsAndKeys:[GCCKeyChain load:keychainID],@"device_id",[NSNumber numberWithInteger:[GlobalData shared].RDBoxDevice.hotelID],@"hotel_id",[NSNumber numberWithInteger:[GlobalData shared].RDBoxDevice.roomID],@"room_id",@"1",@"screen_type",[Helper getWifiName],@"wifi",@"ios",@"device_type",state,@"state", nil];
    HsUploadLogRequest * request = [[HsUploadLogRequest alloc] initWithPubData:dic];
    
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

// 上传日志接口方法
+ (void)upLoadLogRequest:(NSDictionary *)parmDic{
    
    HsNewUploadLogRequest * request = [[HsNewUploadLogRequest alloc] initWithPubData:parmDic];
    
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

+ (void)showAlertWithWifiName:(NSString *)name
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight)];
    view.tag = 422;
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    
    UIView * showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 238)];
    showView.backgroundColor = [UIColor whiteColor];
    showView.center = view.center;
    [view addSubview:showView];
    showView.layer.cornerRadius = 8.f;
    showView.layer.masksToBounds = YES;
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 59)];
    label1.backgroundColor = UIColorFromRGB(0xeeeeee);
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"连接失败";
    label1.font = [UIFont systemFontOfSize:18];
    [showView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 300, 20)];
    label2.textColor = UIColorFromRGB(0x222222);
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"请将wifi连接至";
    label2.font = [UIFont systemFontOfSize:17];
    [showView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 112, 300, 20)];
    label3.textColor = UIColorFromRGB(0x222222);
    label3.textAlignment = NSTextAlignmentCenter;
    if (name.length > 0) {
        label3.text = name;
    }else{
        label3.text = @"电视所在Wi-Fi";
    }
    label3.font = [UIFont boldSystemFontOfSize:20];
    [showView addSubview:label3];
    
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 300, 20)];
    label4.textColor = UIColorFromRGB(0x8888888);
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"手机与电视连接wifi不一致，请切换后重试";
    label4.font = [UIFont systemFontOfSize:14];
    [showView addSubview:label4];
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 189, 300, 49)];
    [button setTitleColor:UIColorFromRGB(0xc9b067) forState:UIControlStateNormal];
    [button setTitle:@"我知道了" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button addTarget:view action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    button.layer.borderWidth = .5f;
    button.layer.borderColor = UIColorFromRGB(0xe8e8e8).CGColor;
    [showView addSubview:button];
}

+ (void)uploadImage:(UIImage *)image withImageName:(NSString *)name progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    NSString * path =[NSString stringWithFormat:@"log/resource/restaurant/mobile/userlogo/%ld/%@.jpg", [GlobalData shared].userModel.hotelID, name];
    [self uploadImage:image withPath:path progress:progress success:^(NSString *path) {
        
        if (successBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(path);
            });
        }
        
    } failure:^(NSError *error) {
        
        if (failureBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(error);
            });
        }
        
    }];
}

+ (void)uploadComsumeImage:(UIImage *)image withImageName:(NSString *)name progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *))successBlock failure:(void (^)(NSError *))failureBlock
{
    NSString * path =[NSString stringWithFormat:@"log/resource/restaurant/mobile/ticket/%ld/%@.jpg", [GlobalData shared].userModel.hotelID, name];
    [self uploadImage:image withPath:path progress:progress success:^(NSString *path) {
        
        if (successBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(path);
            });
        }
        
    } failure:^(NSError *error) {
        
        if (failureBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(error);
            });
        }
        
    }];
}

+ (void)uploadImageArray:(NSArray<UIImage *> *)images progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *, NSInteger))successBlock failure:(void (^)(NSError *, NSInteger))failureBlock
{
    for (NSInteger i = 0; i < images.count; i++) {
        UIImage * image = [images objectAtIndex:i];
        NSString * path = [NSString stringWithFormat:@"%@_%@%ld", [GlobalData shared].userModel.telNumber, [Helper getCurrentTimeWithFormat:@"yyyyMMddHHmmss"], (long)i];
        [self uploadImage:image withImageName:path progress:progress success:^(NSString *path) {
            
            if (successBlock) {
                successBlock(path, i);
            }
            
        } failure:^(NSError *error) {
            
            if (failureBlock) {
                failureBlock(error, i);
            }
            
        }];
    }
}

+ (void)uploadImage:(UIImage *)image withPath:(NSString *)path progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *path))successBlock failure:(void (^)(NSError *error))failureBlock
{
    NSString *endpoint = AliynEndPoint;
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的访问控制章节。
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:AliyunAccessKeyID secretKey:AliyunAccessKeySecret];
    OSSClient * client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = AliyunBucketName;
    put.objectKey = path;
    put.uploadingData = UIImageJPEGRepresentation(image, 1);
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progress) {
            progress(bytesSent, totalBytesSent, totalBytesExpectedToSend);
        }
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id _Nullable(OSSTask * _Nonnull task) {
        if (task.error) {
            if (failureBlock) {
                failureBlock(task.error);
            }
        }else{
            if (successBlock) {
                successBlock([AliynEndPoint stringByAppendingString:put.objectKey]);
            }
        }
        return nil;
    }];
}

+ (void)cancelOSSTask
{
    [OSSTask cancelledTask];
}

@end
