//
//  ResConnectViewController.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResConnectViewController.h"
#import "RDKeyBoard.h"
#import "ResWebViewController.h"
#import "UIView+Additional.h"
#import "SAVORXAPI.h"
#import "HTTPServerManager.h"
#import "GCCKeyChain.h"

@interface ResConnectViewController ()<RDKeyBoradDelegate>

@property (nonatomic, strong) NSMutableArray * labelSource;
@property (nonatomic, copy) NSString *numSring;
@property (nonatomic, strong) NSMutableString *keyMuSring;
@property (nonatomic, strong) UILabel * textLabel;
@property (nonatomic, strong) UILabel * failConectLabel;
@property (nonatomic, strong) UIButton *reConnectBtn;
@property (nonatomic, strong) UIView *maskingView;
@property (nonatomic, strong) UIImageView *animationImageView;

@end

@implementation ResConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelSource = [NSMutableArray new];
    self.numSring = [[NSString alloc] init];
    self.keyMuSring = [[NSMutableString alloc] initWithCapacity:100];
    [self setupViews];
    
    //监听程序进入活跃状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)setupViews
{
    self.title = @"连接电视";
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    [bgView setImage:[UIImage imageNamed:@"ljtvsanweishu_bg"]];
    bgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bgView];
    float bgViewWidth = kMainBoundsWidth - 10;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kMainBoundsHeight == 568) {
            make.size.mas_equalTo(CGSizeMake(bgViewWidth , [Helper autoHeightWith:320]));
        }else{
            make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:bgViewWidth] , [Helper autoHeightWith:370]));
        }
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
    }];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    if (kMainBoundsHeight == 568) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.textLabel.font = [UIFont systemFontOfSize:17];
    }
    self.textLabel.text = @"请输入电视中的三位数连接电视";
    self.textLabel.textColor = UIColorFromRGB(0x333333);
    self.textLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:kMainBoundsWidth - 40] ,[Helper autoHeightWith:30] ));
        if (kMainBoundsHeight == 568) {
            make.bottom.mas_equalTo(bgView).offset(-18);
        }else{
            make.bottom.mas_equalTo(bgView).offset(-32);
        }
        
        make.centerX.mas_equalTo(bgView);
    }];
    
    self.failConectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.failConectLabel.textAlignment = NSTextAlignmentRight;
    if (kMainBoundsHeight == 568) {
        self.failConectLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.failConectLabel.font = [UIFont systemFontOfSize:17];
    }
    self.failConectLabel.backgroundColor = [UIColor clearColor];
    self.failConectLabel.text = @"连接失败，";
    self.failConectLabel.textColor = UIColorFromRGB(0x333333);
    [bgView addSubview:self.failConectLabel];
    self.failConectLabel.hidden = YES;
    [self.failConectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kMainBoundsHeight == 568) {
            make.centerX.mas_equalTo(-40);
            make.bottom.mas_equalTo(bgView).offset(-18);
            make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:90], [Helper autoHeightWith:30]));
        }else{
            make.centerX.mas_equalTo(-50);
            make.bottom.mas_equalTo(bgView).offset(-32);
            make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:100], [Helper autoHeightWith:30]));
        }
    }];
    
    self.reConnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reConnectBtn.backgroundColor = [UIColor clearColor];
    self.reConnectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.reConnectBtn setTitleColor:UIColorFromRGB(0xff2a00) forState:UIControlStateNormal];
    if (kMainBoundsHeight == 568) {
        self.reConnectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }else{
        self.reConnectBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    [self.reConnectBtn setTitle:@"重新连接？" forState:UIControlStateNormal];;
    [self.reConnectBtn addTarget:self action:@selector(reClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.reConnectBtn];
    self.reConnectBtn.hidden = YES;
    [self.reConnectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kMainBoundsHeight == 568) {
            make.centerX.mas_equalTo(40);
            make.bottom.mas_equalTo(bgView).offset(-18);
            make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:90], [Helper autoHeightWith:30]));
        }else{
            make.centerX.mas_equalTo(50);
            make.bottom.mas_equalTo(bgView).offset(-32);
            make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:100], [Helper autoHeightWith:30]));
        }
    }];
    
    for (NSInteger i = 0; i < 3; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.layer.cornerRadius = 0;
        label.layer.borderColor = UIColorFromRGB(0xffd237).CGColor;
        label.layer.borderWidth = 1.5f;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont boldSystemFontOfSize:30];
        [bgView addSubview:label];
        float distance = [Helper autoHeightWith:99];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (kMainBoundsHeight == 568) {
                make.bottom.mas_equalTo (self.textLabel.mas_top).offset(-10);
            }else{
                make.bottom.mas_equalTo (self.textLabel.mas_top).offset(-18);
            }
            make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:70],[Helper autoHeightWith:50]));
            if (i == 0) {
                make.centerX.mas_equalTo(-distance);
            }else if (i == 1) {
                make.centerX.mas_equalTo(0);
            }else{
                make.centerX.mas_equalTo(distance);
            }
        }];
        [self.labelSource addObject:label];
    }
    
    RDKeyBoard *keyBoard;
    if (kMainBoundsHeight == 736) {
        keyBoard = [[RDKeyBoard alloc] initWithHeight:226.0 inView:self.view];
    }else{
        keyBoard = [[RDKeyBoard alloc] initWithHeight:216.0 inView:self.view];
    }
    keyBoard.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bangzhu"] style:UIBarButtonItemStyleDone target:self action:@selector(shouldPushHelp)];
    
}

- (void)shouldPushHelp
{
    ResWebViewController * help = [[ResWebViewController alloc] initWithURL:@"http://h5.littlehotspot.com/Public/html/help/helptwo.html"];
    help.title = @"连接步骤";
    [self.navigationController  pushViewController:help  animated:YES];
}

// 重新连接
- (void)reClick{
    [self getBoxInfo];
    [self creatMaskingLoadingView];
}

- (void)creatMaskingLoadingView{
    
    self.maskingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.maskingView.backgroundColor = [UIColor blackColor];
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] lastObject];
    self.maskingView.frame = keyWindow.bounds;
    self.maskingView.bottom = keyWindow.top;
    [keyWindow addSubview:self.maskingView];
    [self showViewWithAnimationDuration:0.0];
    
    UIImageView *smallWindowView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [smallWindowView setImage:[UIImage imageNamed:@"lianjie_bg"]];
    [self.maskingView addSubview:smallWindowView];
    [smallWindowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:190],[Helper autoHeightWith:160]));
        make.centerX.mas_equalTo(self.maskingView);
        make.centerY.mas_equalTo(self.maskingView);
    }];
    
    self.animationImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.animationImageView.backgroundColor = [UIColor clearColor];
    [smallWindowView addSubview:self.animationImageView];
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Helper autoWidthWith:80],[Helper autoHeightWith:20]));
        make.bottom.mas_equalTo(smallWindowView.mas_bottom).offset(- 20);
        make.centerX.mas_equalTo(self.maskingView);
    }];
    
    // 播放一组图片，设置一共有多少张图片生成的动画
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"connecting%d.png", i]];
        [imageArray addObject:image];
    }
    self.animationImageView.animationImages = imageArray;
    self.animationImageView.animationDuration = 0.5;
    self.animationImageView.animationRepeatCount = 10000;
    [self.animationImageView startAnimating];
    
    
}

//程序进入活跃状态
- (void)applicationWillActive
{
    if (self.animationImageView) {
        [self.animationImageView startAnimating];
    }
}

- (void)hidenMaskingLoadingView{
    
    [self.maskingView removeFromSuperview];
    [self.animationImageView stopAnimating];
    
}
#pragma mark - show view
-(void)showViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        self.maskingView.backgroundColor = RGBA(0, 0, 0, 0.7);
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.maskingView.bottom = keyWindow.bottom;
    } completion:^(BOOL finished) {
    }];
}

- (void)RDKeyBoradViewDidClickedWith:(NSString *)str isDelete:(BOOL)isDelete{
    
    if (isDelete == YES ) {
        if (self.keyMuSring.length >= 1) {
            [self.keyMuSring deleteCharactersInRange:NSMakeRange(self.keyMuSring.length - 1,1)];
        }else{
            return;
        }
    }else{
        [self.keyMuSring appendString:str];
    }
    
    NSString * number = self.keyMuSring;
    
    if (number.length == self.labelSource.count) {
        self.numSring = number;
        [self getBoxInfo];
        [self creatMaskingLoadingView];
    }
    if (number.length > self.labelSource.count) {
        [self.keyMuSring deleteCharactersInRange:NSMakeRange(3, number.length - 3)];
    }
    for (NSUInteger i = 0; i < self.labelSource.count; i++) {
        if (i < number.length) {
            UILabel * label = [self.labelSource objectAtIndex:i];
            label.text = [number substringWithRange:NSMakeRange(i, 1)];
        }else{
            UILabel * label = [self.labelSource objectAtIndex:i];
            label.text = @"";
        }
        if (self.numSring.length == 3 && number.length == 2) {
            self.failConectLabel.hidden = YES;
            self.reConnectBtn.hidden = YES;
            self.textLabel.hidden = NO;
            self.numSring = @"";
            self.textLabel.text = @"请输入电视中的三位数连接电视";
        }
    }
}

- (void)getBoxInfo
{
    __block BOOL hasSuccess = NO; //记录是否绑定成功过
    __block NSInteger hasFailure = 0; //记录失败的次数
    
    NSString *platformUrl = [NSString stringWithFormat:@"%@/command/box-info/%@", [GlobalData shared].callQRCodeURL, self.numSring];
    
    [SAVORXAPI getWithURL:platformUrl parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        if (code == 10000) {
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            
            [self getBoxInfoWithResult:result];
        }else{
            
            hasFailure += 1;
            if (hasFailure < 4) {
                return;
            }
            
            [MBProgressHUD showTextHUDwithTitle:[result objectForKey:@"msg"] delay:1.5f];
            self.textLabel.text = [result objectForKey:@"msg"];
        }
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = YES;
        self.reConnectBtn.hidden = YES;
        self.textLabel.hidden = NO;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        hasFailure += 1;
        if (hasFailure < 4) {
            return;
        }
        
        [MBProgressHUD showTextHUDwithTitle:@"绑定失败" delay:1.5f];
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = NO;
        self.reConnectBtn.hidden = NO;
        self.textLabel.hidden = YES;
        
    }];
    
    NSString *hosturl = [NSString stringWithFormat:@"%@/command/box-info/%@", [GlobalData shared].secondCallCodeURL, self.numSring];
    
    [SAVORXAPI getWithURL:hosturl parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        if (code == 10000) {
            
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            
            [self getBoxInfoWithResult:result];
        }else{
            
            hasFailure += 1;
            if (hasFailure < 4) {
                return;
            }
            
            [MBProgressHUD showTextHUDwithTitle:[result objectForKey:@"msg"] delay:1.5f];
            self.textLabel.text = [result objectForKey:@"msg"];
        }
        
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = YES;
        self.reConnectBtn.hidden = YES;
        self.textLabel.hidden = NO;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        hasFailure += 1;
        if (hasFailure < 4) {
            return;
        }
        
        [MBProgressHUD showTextHUDwithTitle:@"绑定失败" delay:1.5f];
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = NO;
        self.reConnectBtn.hidden = NO;
        self.textLabel.hidden = YES;
    }];
    
    NSString *boxPlatformURL = [NSString stringWithFormat:@"%@/command/box-info/%@", [GlobalData shared].thirdCallCodeURL, self.numSring];
    
    [SAVORXAPI getWithURL:boxPlatformURL parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        if (code == 10000) {
            
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            
            [self getBoxInfoWithResult:result];
        }else{
            
            hasFailure += 1;
            if (hasFailure < 4) {
                return;
            }
            
            [MBProgressHUD showTextHUDwithTitle:[result objectForKey:@"msg"] delay:1.5f];
            self.textLabel.text = [result objectForKey:@"msg"];
        }
        
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = YES;
        self.reConnectBtn.hidden = YES;
        self.textLabel.hidden = NO;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        hasFailure += 1;
        if (hasFailure < 4) {
            return;
        }
        
        [MBProgressHUD showTextHUDwithTitle:@"绑定失败" delay:1.5f];
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = NO;
        self.reConnectBtn.hidden = NO;
        self.textLabel.hidden = YES;
        
    }];
    
    NSString *boxURL = [NSString stringWithFormat:@"%@/verify?code=%@&deviceId=%@", [GlobalData shared].boxCodeURL, self.numSring, [GlobalData shared].deviceID];
    
    [SAVORXAPI getWithURL:boxURL parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary *result) {
        
        NSInteger code = [[result objectForKey:@"code"] integerValue];
        if (code == 10000) {
            
            if (hasSuccess) {
                return;
            }
            hasSuccess = YES;
            
            [self getBoxInfoWithResult:result];
        }else{
            
            hasFailure += 1;
            if (hasFailure < 4) {
                return;
            }
            
            [MBProgressHUD showTextHUDwithTitle:[result objectForKey:@"msg"] delay:1.5f];
            self.textLabel.text = [result objectForKey:@"msg"];
        }
        
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = YES;
        self.reConnectBtn.hidden = YES;
        self.textLabel.hidden = NO;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        hasFailure += 1;
        if (hasFailure < 4) {
            return;
        }
        
        [MBProgressHUD showTextHUDwithTitle:@"绑定失败" delay:1.5f];
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = NO;
        self.reConnectBtn.hidden = NO;
        self.textLabel.hidden = YES;
        
    }];
}

- (void)navBackButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showAlertWithWifiName:(NSString *)name
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

- (void)getBoxInfoWithResult:(NSDictionary *)result
{
    result = [result objectForKey:@"result"];
    RDBoxModel * model = [[RDBoxModel alloc] init];
    
    if ([HTTPServerManager checkHttpServerWithBoxIP:[result objectForKey:@"box_ip"]]) {
        model.BoxIP = [[result objectForKey:@"box_ip"] stringByAppendingString:@":8080"];
        model.BoxID = [result objectForKey:@"box_mac"];
        model.hotelID = [[result objectForKey:@"hotel_id"] integerValue];
        model.roomID = [[result objectForKey:@"room_id"] integerValue];
        model.sid = [result objectForKey:@"ssid"];
        if (![[result objectForKey:@"ssid"] isEqualToString:[Helper getWifiName]]){
            [GlobalData shared].cacheModel = model;
            [self showAlertWithWifiName:[result objectForKey:@"ssid"]];
        }else{
            [[GlobalData shared] bindToRDBoxDevice:model];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (![[result objectForKey:@"ssid"] isEqualToString:[Helper getWifiName]]) {
        model.BoxIP = [[result objectForKey:@"box_ip"] stringByAppendingString:@":8080"];
        model.BoxID = [result objectForKey:@"box_mac"];
        model.hotelID = [[result objectForKey:@"hotel_id"] integerValue];
        model.roomID = [[result objectForKey:@"room_id"] integerValue];
        model.sid = [result objectForKey:@"ssid"];
        [GlobalData shared].cacheModel = model;
        [self showAlertWithWifiName:[result objectForKey:@"ssid"]];
    }else{
        [MBProgressHUD showTextHUDwithTitle:@"绑定失败" delay:1.5f];
        [self hidenMaskingLoadingView];
        self.failConectLabel.hidden = NO;
        self.reConnectBtn.hidden = NO;
        self.textLabel.hidden = YES;
        [SAVORXAPI upLoadLogs:@"0"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    UIView * view = [[UIApplication sharedApplication].keyWindow viewWithTag:422];
    if (view) {
        [view removeFromSuperview];
    }
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
