//
//  RestaurantHomePageViewController.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/6/9.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "RestaurantHomePageViewController.h"
#import "RestHomePageTableViewCell.h"
#import "ResSliderViewController.h"
#import "RestaurantPhotoTool.h"
#import "Helper.h"
#import "RDAlertView.h"
#import "RDAlertAction.h"
#import "UIView+Additional.h"
#import "SAVORXAPI.h"
#import "ResHomeBottomView.h"
#import "ResConnectViewController.h"
#import "ResVideoViewController.h"

@interface RestaurantHomePageViewController ()<UITableViewDelegate,UITableViewDataSource, ResHomeBottomViewDelegate>
@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) ResHomeBottomView * bottomView; //底部控制栏
@property (nonatomic, strong) NSArray * classNameArray;
//@property (nonatomic, strong) UIButton *confirmWifiBtn;
//@property (nonatomic, strong) UILabel *tipLabel;
//@property (nonatomic ,strong) ConnectMaskingView *maskingView;

@end

@implementation RestaurantHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:VCBackgroundColor];

    self.classNameArray = @[@"图片和幻灯片",@"视频",@"文件"];
    
    [self creatSubViews];
//    [self addNotifiCation];
//    [self notFoundSence];
    
    [SAVORXAPI checkVersionUpgrade];
   

}

//创建子视图
- (void)creatSubViews{
    
    // 设置自定义的title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.text = @"小热点-餐厅端";
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
   self.navigationItem.titleView = titleLabel;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView registerClass:[RestHomePageTableViewCell class] forCellReuseIdentifier:@"homeTableCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    _tableView.backgroundView = nil;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10)];
    _tableView.tableHeaderView = view;
    
    self.bottomView = [[ResHomeBottomView alloc] init];
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 50));
    }];
    
//    self.tipLabel = [[UILabel alloc] init];
//    self.tipLabel.font = [UIFont systemFontOfSize:16];
//    self.tipLabel.textColor = UIColorFromRGB(0x333333);
//    self.tipLabel.text = @"请连接包间WiFi后进行操作";
//    [self.bottomView addSubview:self.tipLabel];
//    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 95, 30));
//        make.top.mas_equalTo(self.bottomView.mas_top).offset(10);
//        make.left.mas_equalTo(10);
//        
//    }];
//    
//    self.confirmWifiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.confirmWifiBtn setBackgroundColor:RGBCOLOR(253,120,70)];
//    self.confirmWifiBtn.layer.cornerRadius = 5.0;
//    [self.confirmWifiBtn setTitle:@"退出投屏" forState:UIControlStateNormal];
//    [self.confirmWifiBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    [self.confirmWifiBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    [self.confirmWifiBtn addTarget:self action:@selector(quitScreen) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:self.confirmWifiBtn];
//    self.confirmWifiBtn.hidden = YES;
//    [self.confirmWifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(80, 34));
//        make.centerY.mas_equalTo(self.bottomView);
//        make.right.mas_equalTo(-15);
//    }];
//    
//    if ([GlobalData shared].scene != RDSceneHaveRDBox) {
//        self.tipLabel.text = [NSString stringWithFormat:@"当前连接WiFi:%@",[Helper getWifiName]];
//        self.confirmWifiBtn.hidden = NO;
//    }
}

- (void)ResHomeBottomViewStopScreenWithTap
{
    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定要断开与\"%@\"的连接?",[Helper getWifiName]]];
    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
    } bold:NO];
    RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
        [[GlobalData shared] disconnect];
    } bold:YES];
    [alertView addActions:@[action,actionOne]];
    [alertView show];
}

- (void)ResHomeBottomViewDidClickedWithStatus:(ResHomeStatus)status
{
    if (status == ResHomeStatus_WiFiHaveSence) {
        [SAVORXAPI callCodeWithSuccess:^{
            ResConnectViewController * connect = [[ResConnectViewController alloc] init];
            [self.navigationController pushViewController:connect animated:YES];
        } failure:^{
            if ([GlobalData shared].scene == RDSceneHaveRDBox) {
                [Helper showTextHUDwithTitle:@"验证码呼出失败" delay:1.5f];
            }else{
                [Helper showTextHUDwithTitle:@"连接失败，请连接包间wifi" delay:1.5f];
            }
        }];
    }else{
        RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定要退出\"%@\"的投屏?",[Helper getWifiName]]];
        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
        } bold:NO];
        RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
            [SAVORXAPI ScreenDemandShouldBackToTVWithSuccess:^{
                
            } failure:^{
                
            }];
        } bold:YES];
        [alertView addActions:@[action,actionOne]];
        [alertView show];
    }
}

//#pragma mark - show view
//-(void)showViewWithAnimationDuration:(float)duration{
//    
//    [UIView animateWithDuration:duration animations:^{
//        
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        _maskingView.bottom = keyWindow.bottom;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//-(void)dismissViewWithAnimationDuration:(float)duration{
//    
//    [UIView animateWithDuration:duration animations:^{
//        
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//        
//        _maskingView.bottom = keyWindow.top;
//        
//    } completion:^(BOOL finished) {
//        
//        [_maskingView removeFromSuperview];
//        _maskingView = nil;
//        
//    }];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestHomePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"homeTableCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell configDatas:self.classNameArray withIndex:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([UIScreen mainScreen].bounds.size.height - 124)/4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [RestaurantPhotoTool checkUserLibraryAuthorizationStatusWithSuccess:^{
            ResSliderViewController * slider = [[ResSliderViewController alloc] init];
            [self.navigationController pushViewController:slider animated:YES];
        } failure:^(NSError *error) {
            [self openSetting];
        }];
    }else if (indexPath.row == 1) {
        [RestaurantPhotoTool checkUserLibraryAuthorizationStatusWithSuccess:^{
            ResVideoViewController * slider = [[ResVideoViewController alloc] init];
            [self.navigationController pushViewController:slider animated:YES];
        } failure:^(NSError *error) {
            [self openSetting];
        }];
    }else{
        [Helper showTextHUDwithTitle:@"该功能暂未开通，敬请期待" delay:1.f];
    }
}

//打开用户应用设置
- (void)openSetting
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能需要开启相册权限，是否前往进行设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //关闭iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

//- (void)quitScreen{
//    
//    if ([GlobalData shared].isBindRD) {
//        
//        RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定要退出\"%@\"的投屏?",[Helper getWifiName]]];
//        RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
//        } bold:NO];
//        RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
//            [SAVORXAPI ScreenDemandShouldBackToTVWithSuccess:^{
//                [Helper showTextHUDwithTitle:@"投屏已经退出" delay:1.f];
//            } failure:^{
//                [Helper showTextHUDwithTitle:@"退出投屏失败" delay:1.f];
//            }];
//        } bold:YES];
//        [alertView addActions:@[action,actionOne]];
//        [alertView show];
//
//    }else{
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSearchDevice) name:RDStopSearchDeviceNotification object:nil];
//        
//        [[GCCDLNA defaultManager] startSearchPlatform];
//        [self creatMaskingView];
//    }
//    
//}

//- (void)creatMaskingView{
//    
//    if (_maskingView.superview) {
//        [_maskingView removeFromSuperview];
//    }
//    
//    _maskingView = [[ConnectMaskingView alloc] initWithFrame:self.view.frame];
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    _maskingView.bottom = keyWindow.top;
//    [keyWindow addSubview:_maskingView];
//    [self showViewWithAnimationDuration:0.3];
//    
//}

//// 发现了盒子环境
//- (void)foundBoxSence{
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDStopSearchDeviceNotification object:nil];
//    self.tipLabel.text = [NSString stringWithFormat:@"当前连接包间:%@",[Helper getWifiName]];
//    self.confirmWifiBtn.hidden = NO;
//    if (_maskingView) {
//        [self dismissViewWithAnimationDuration:0.5f ];
//    }
//}
//
//// 没有发现环境
//- (void)notFoundSence{
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDStopSearchDeviceNotification object:nil];
//    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
//        self.tipLabel.text = [NSString stringWithFormat:@"当前连接WiFi:%@",[Helper getWifiName]];
//        self.confirmWifiBtn.hidden = NO;
//    }else{
//        self.tipLabel.text = @"请连接包间WiFi后进行操作";
//        self.confirmWifiBtn.hidden = YES;
//    }
//}
//
//- (void)networkDidBecomeWifi
//{
//    self.tipLabel.text = [NSString stringWithFormat:@"当前连接WiFi:%@",[Helper getWifiName]];
//    self.confirmWifiBtn.hidden = NO;
//}
//
//- (void)stopSearchDevice{
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDStopSearchDeviceNotification object:nil];
//    [self dismissViewWithAnimationDuration:0.5f];
//    
//    RDAlertView *alertView = [[RDAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"连接失败，请重新连接"]];
//    RDAlertAction * action = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
//        
//    } bold:NO];
//    RDAlertAction * actionOne = [[RDAlertAction alloc] initWithTitle:@"重新连接" handler:^{
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSearchDevice) name:RDStopSearchDeviceNotification object:nil];
//        [[GCCDLNA defaultManager] startSearchPlatform];
//        [self creatMaskingView];
//    } bold:NO];
//    [alertView addActions:@[action,actionOne]];
//    [alertView show];
//}

//- (void)addNotifiCation
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundBoxSence) name:RDDidBindDeviceNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notFoundSence) name:RDDidNotFoundSenceNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDidBecomeWifi) name:RDNetWorkStatusDidBecomeReachableViaWiFi object:nil];
//}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidBindDeviceNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDNetWorkStatusDidBecomeReachableViaWiFi object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
