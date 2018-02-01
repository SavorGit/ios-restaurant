//
//  RestaurantServiceStatusView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceStatusView.h"

@interface RestaurantServiceStatusView ()

@property (nonatomic, strong) UIImageView * topTipImageView;
@property (nonatomic, strong) UILabel * topTipLabel;

@end

@implementation RestaurantServiceStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createViews];
        [self addNotification];
        
    }
    return self;
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.topTipLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xe43018) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
    self.topTipLabel.text = @"欢迎词投屏时长为5分钟，结束后将轮播推荐菜";
    self.topTipLabel.textColor = UIColorFromRGB(0x922c3e);
    [self addSubview:self.topTipLabel];
    [self.topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36 * scale);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    self.topTipImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.topTipImageView setImage:[UIImage imageNamed:@"tsjg"]];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFindHotelID) name:RDDidFoundHotelIdNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoseHotelID) name:RDDidNotFoundSenceNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidFoundHotelIdNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDDidNotFoundSenceNotification object:nil];
}

- (void)didFindHotelID
{
    [self checkHotelID];
}

- (void)didLoseHotelID
{
    [self checkHotelID];
}

- (void)checkHotelID
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if ([GlobalData shared].hotelId == [GlobalData shared].userModel.hotelID) {
        self.topTipLabel.text = @"欢迎词投屏时长为5分钟，结束后将轮播推荐菜";
        self.topTipLabel.textColor = UIColorFromRGB(0x922c3e);
        if (self.topTipImageView.superview) {
            [self.topTipImageView removeFromSuperview];
        }
    }else{
        self.topTipLabel.text = [NSString stringWithFormat:@"    请连接“%@”的wifi后操作", [GlobalData shared].userModel.hotelName];
        self.topTipLabel.textColor = UIColorFromRGB(0xe43018);
        
        if (!self.topTipImageView.superview) {
            [self.topTipLabel addSubview:self.topTipImageView];
            [self.topTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(15 * scale);
                make.height.mas_equalTo(15 * scale);
            }];
        }
    }
}

@end
