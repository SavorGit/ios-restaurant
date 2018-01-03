//
//  FirstAddCustomerAlert.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FirstAddCustomerAlert.h"

@implementation FirstAddCustomerAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createFirstAddCustomerAlert];
        
    }
    return self;
}

- (void)createFirstAddCustomerAlert
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    UIView * contenView = [[UIView alloc] initWithFrame:CGRectZero];
    contenView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self addSubview:contenView];
    [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(305 * scale);
        make.height.mas_equalTo(355 * scale);
    }];
    
    UIImageView * uploadImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [uploadImage setImage:[UIImage imageNamed:@"shch"]];
    [contenView addSubview:uploadImage];
    [uploadImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50 * scale);
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(59 * scale);
    }];
    
    UILabel * titleLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"建议同步您的通讯录,\n生成您的客户管理私有云空间";
    [contenView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(uploadImage.mas_bottom).offset(25 * scale);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    UIButton * addButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xf6f2ed) font:kPingFangRegular(16 * scale) backgroundColor:kAPPMainColor title:@"立即导入" cornerRadius:18 * scale];
    [contenView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(40 * scale);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(210 * scale);
        make.height.mas_equalTo(32 * scale);
    }];
    
    UIButton * ignoreButton = [Helper buttonWithTitleColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"暂不使用"];
    [contenView addSubview:ignoreButton];
    [ignoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addButton.mas_bottom).offset(25 * scale);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(100 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = ignoreButton.titleLabel.textColor;
    [ignoreButton addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(60 * scale);
        make.height.mas_equalTo(1 * scale);
    }];
    
    UILabel * copyRightLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentCenter];
    copyRightLabel.text = @"小热点为您的数据提供安全保障";
    copyRightLabel.numberOfLines = 0;
    [contenView addSubview:copyRightLabel];
    [copyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.bottom.mas_equalTo(-25 * scale);
    }];
    
    self.layer.cornerRadius = 7 * scale;
    self.layer.masksToBounds = YES;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)addRightNow
{
    if (self.block) {
        self.block();
    }
    [self hasAlert];
}

- (void)hasAlert
{
    [self removeFromSuperview];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithBool:YES] forKey:kHasAlertUploadCustomer];
    [userDefaults synchronize];
}

@end
