//
//  ConnectMaskingView.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/6/14.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ConnectMaskingView.h"
#import "UIView+Additional.h"

@interface ConnectMaskingView()

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation ConnectMaskingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{

    self.tag = 10000;
    self.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.92f];
    
    UIImageView *conImageView = [[UIImageView alloc] init];
    conImageView.image = [UIImage imageNamed:@"lianjie"];
    [self addSubview:conImageView];
    [conImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(61, 41));
        make.centerY.equalTo(self).offset(-40);
        make.centerX.equalTo(self);
    }];
    
    UILabel *conLabel = [[UILabel alloc] init];
    conLabel.font = [UIFont systemFontOfSize:17];
    conLabel.textColor = [UIColor whiteColor];
    conLabel.backgroundColor = [UIColor clearColor];
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.text = @"正在连接包间...";
    [self addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 30));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(conImageView.mas_bottom).offset(10);
    }];
}

@end
