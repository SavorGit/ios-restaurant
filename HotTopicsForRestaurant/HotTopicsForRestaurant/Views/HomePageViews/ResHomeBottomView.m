//
//  ResHomeBottomView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResHomeBottomView.h"

@interface ResHomeBottomView ()

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *confirmWifiBtn;

@end

@implementation ResHomeBottomView

- (instancetype)init
{
    if (self = [super init]) {
        [self createStatusView];
    }
    return self;
}

- (void)createStatusView
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:16];
    self.tipLabel.textColor = UIColorFromRGB(0x333333);
    self.tipLabel.text = @"请连接包间WiFi后进行操作";
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 95, 30));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        
    }];
    
    self.confirmWifiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmWifiBtn setBackgroundColor:RGBCOLOR(253,120,70)];
    self.confirmWifiBtn.layer.cornerRadius = 5.0;
    [self.confirmWifiBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.confirmWifiBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.confirmWifiBtn];
    self.confirmWifiBtn.hidden = YES;
    [self.confirmWifiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 34));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    [self addNotification];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notFoundSence) name:RDDidNotFoundSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundBoxSence) name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindBox) name:RDDidBindDeviceNotification object:nil];
}

- (void)notFoundSence
{
    if ([GlobalData shared].networkStatus == RDNetworkStatusReachableViaWiFi) {
        [self changeStatusTo:ResHomeStatus_WiFiNoSence];
    }else{
        [self changeStatusTo:ResHomeStatus_NoWiFi];
    }
}

- (void)foundBoxSence
{
    [self changeStatusTo:ResHomeStatus_WiFiHaveSence];
}

- (void)bindBox
{
    [self changeStatusTo:ResHomeStatus_Connect];
}

- (void)confirmWifiBtnDidClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ResHomeBottomViewDidClickedWithStatus:)]) {
        [self.delegate ResHomeBottomViewDidClickedWithStatus:self.status];
    }
}

- (void)changeStatusTo:(ResHomeStatus)status
{
    self.status = status;
    switch (status) {
        case ResHomeStatus_NoWiFi:
        {
            self.tipLabel.text = @"请连接包间WiFi, 即可连接电视";
            self.confirmWifiBtn.hidden = YES;
        }
            break;
            
        case ResHomeStatus_WiFiNoSence:
        {
            self.tipLabel.text = @"请连接包间WiFi, 即可连接电视";
            self.confirmWifiBtn.hidden = YES;
        }
            break;
            
        case ResHomeStatus_WiFiHaveSence:
        {
            self.tipLabel.text = @"发现可连接电视，请连接";
            self.confirmWifiBtn.hidden = NO;
            [self.confirmWifiBtn setTitle:@"连接电视" forState:UIControlStateNormal];
            [self.confirmWifiBtn addTarget:self action:@selector(confirmWifiBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
            
        case ResHomeStatus_Connect:
        {
            self.tipLabel.text = [NSString stringWithFormat:@"已连接%@, 点击断开连接>>", [Helper getWifiName]];
            self.confirmWifiBtn.hidden = NO;
            [self.confirmWifiBtn setTitle:@"退出投屏" forState:UIControlStateNormal];
            [self.confirmWifiBtn addTarget:self action:@selector(confirmWifiBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidFoundBoxSenceNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidBindDeviceNotification object:nil];
}

@end
