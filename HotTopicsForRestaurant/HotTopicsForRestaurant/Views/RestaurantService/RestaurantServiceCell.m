//
//  RestaurantServiceCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceCell.h"

@interface RestaurantServiceCell ()

@property (nonatomic, strong) RestaurantServiceModel * model;

@property (nonatomic, strong) UIView * baseView;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * defaultWordLabel;
@property (nonatomic, strong) UIButton * defaultWordButton;
@property (nonatomic, strong) UIButton * stopWordButton;
@property (nonatomic, strong) UIButton * RecomDishButton;
@property (nonatomic, strong) UIButton * stopDishButton;
@property (nonatomic, strong) UILabel * playWordLabel;
@property (nonatomic, strong) UILabel * playDishLabel;

@end

@implementation RestaurantServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createRestaurantServiceCell];
    }
    return self;
}

- (void)createRestaurantServiceCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xece6de);
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    self.baseView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10 * scale);
    }];
    self.baseView.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    self.baseView.layer.borderWidth = .5f;
    
    self.nameLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangMedium(20 * scale) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"";
    [self.baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(22 * scale);
    }];
    
    UIView * wordView = [[UIView alloc] initWithFrame:CGRectZero];
    wordView.backgroundColor = UIColorFromRGB(0xfdfcfa);
    wordView.layer.cornerRadius = 2.f;
    wordView.layer.shadowColor = UIColorFromRGB(0xd7d2ca).CGColor;
    wordView.layer.shadowRadius = 5.f;
    wordView.layer.shadowOpacity = .35f;
    wordView.layer.shadowOffset = CGSizeMake(0, 1);
    [self.baseView addSubview:wordView];
    [wordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(17 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(270 * scale);
        make.height.mas_equalTo(70 * scale);
    }];
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wordViewDidTap)];
    tap1.numberOfTapsRequired = 1;
    [wordView addGestureRecognizer:tap1];
    
    UILabel * wordLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    wordLabel.text = @"欢迎词";
    [wordView addSubview:wordLabel];
    [wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16 * scale);
        make.left.mas_equalTo(10 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    self.playWordLabel = [Helper labelWithFrame:CGRectZero TextColor:kAPPMainColor font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentLeft];
    self.playWordLabel.text = @"投屏中";
    [wordView addSubview:self.playWordLabel];
    [self.playWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wordLabel);
        make.left.mas_equalTo(wordLabel.mas_right).offset(7 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    self.playWordLabel.hidden = YES;
    
    self.defaultWordLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentLeft];
    [wordView addSubview:self.defaultWordLabel];
    [self.defaultWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wordLabel.mas_bottom).offset(9 * scale);
        make.left.mas_equalTo(10 * scale);
        make.height.mas_equalTo(15 * scale);
        make.width.mas_lessThanOrEqualTo(185 * scale);
    }];
    
    UILabel * tapToEditLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentLeft];
    tapToEditLabel.text = @"(点击编辑)";
    [wordView addSubview:tapToEditLabel];
    [tapToEditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wordLabel.mas_bottom).offset(9 * scale);
        make.left.mas_equalTo(self.defaultWordLabel.mas_right).offset(5 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.defaultWordButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangMedium(16 * scale) backgroundColor:[UIColor clearColor] title:@"投屏" cornerRadius:2.f];
    self.defaultWordButton.layer.cornerRadius = 2.f;
    self.defaultWordButton.layer.masksToBounds = YES;
    self.defaultWordButton.layer.borderColor = kAPPMainColor.CGColor;
    self.defaultWordButton.layer.borderWidth = 1.f;
    [self.defaultWordButton addTarget:self action:@selector(PlayWord) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.defaultWordButton];
    [self.defaultWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wordView);
        make.width.mas_equalTo(65 * scale);
        make.height.mas_equalTo(50 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.stopWordButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16 * scale) backgroundColor:kAPPMainColor title:@"退出" cornerRadius:2.f];
    self.stopWordButton.layer.cornerRadius = 2.f;
    self.stopWordButton.layer.masksToBounds = YES;
    [self.stopWordButton addTarget:self action:@selector(stopPlayWord) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.stopWordButton];
    [self.stopWordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wordView);
        make.width.mas_equalTo(65 * scale);
        make.height.mas_equalTo(50 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    UIView * recomDishView = [[UIView alloc] initWithFrame:CGRectZero];
    recomDishView.backgroundColor = UIColorFromRGB(0xfdfcfa);
    recomDishView.layer.cornerRadius = 2.f;
    recomDishView.layer.masksToBounds = YES;
    recomDishView.layer.shadowColor = UIColorFromRGB(0xd7d2ca).CGColor;
    recomDishView.layer.shadowRadius = 2.f;
    recomDishView.layer.shadowOpacity = .35f;
    [self.baseView addSubview:recomDishView];
    [recomDishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wordView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(270 * scale);
        make.height.mas_equalTo(70 * scale);
    }];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dishViewDidTap)];
    tap2.numberOfTapsRequired = 1;
    [recomDishView addGestureRecognizer:tap2];
    
    UILabel * recomDishLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    recomDishLabel.text = @"推荐菜";
    [recomDishView addSubview:recomDishLabel];
    [recomDishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16 * scale);
        make.left.mas_equalTo(10 * scale);
        make.height.mas_equalTo(18 * scale);
    }];
    
    self.playDishLabel = [Helper labelWithFrame:CGRectZero TextColor:kAPPMainColor font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentLeft];
    self.playDishLabel.text = @"投屏中";
    [recomDishView addSubview:self.playDishLabel];
    [self.playDishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(recomDishLabel);
        make.left.mas_equalTo(recomDishLabel.mas_right).offset(7 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    self.playDishLabel.hidden = YES;
    
    UILabel * tapToSelectLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentLeft];
    tapToSelectLabel.text = @"默认播全部推荐菜(点击可选)";
    [recomDishView addSubview:tapToSelectLabel];
    [tapToSelectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(recomDishLabel.mas_bottom).offset(9 * scale);
        make.left.mas_equalTo(10 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.RecomDishButton = [Helper buttonWithTitleColor:kAPPMainColor font:kPingFangMedium(16 * scale) backgroundColor:[UIColor clearColor] title:@"投屏" cornerRadius:2.f];
    self.RecomDishButton.layer.cornerRadius = 2.f;
    self.RecomDishButton.layer.masksToBounds = YES;
    self.RecomDishButton.layer.borderColor = kAPPMainColor.CGColor;
    self.RecomDishButton.layer.borderWidth = 1.f;
    [self.baseView addSubview:self.RecomDishButton];
    [self.RecomDishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(recomDishView);
        make.width.mas_equalTo(65 * scale);
        make.height.mas_equalTo(50 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.stopDishButton = [Helper buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16 * scale) backgroundColor:kAPPMainColor title:@"退出" cornerRadius:2.f];
    self.stopDishButton.layer.cornerRadius = 2.f;
    self.stopDishButton.layer.masksToBounds = YES;
    [self.stopDishButton addTarget:self action:@selector(stopPlayDish) forControlEvents:UIControlEventTouchUpInside];
    [self.RecomDishButton addTarget:self action:@selector(PlayDish) forControlEvents:UIControlEventTouchUpInside];
    [self.baseView addSubview:self.stopDishButton];
    [self.stopDishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(recomDishView);
        make.width.mas_equalTo(65 * scale);
        make.height.mas_equalTo(50 * scale);
        make.right.mas_equalTo(-15 * scale);
    }];
}

- (void)wordViewDidTap
{
    if (_delegate && [_delegate respondsToSelector:@selector(RestaurantServiceDidHandle:model:)]) {
        [_delegate RestaurantServiceDidHandle:RestaurantServiceHandle_Word model:self.model];
    }
}

- (void)dishViewDidTap
{
    if (_delegate && [_delegate respondsToSelector:@selector(RestaurantServiceDidHandle:model:)]) {
        [_delegate RestaurantServiceDidHandle:RestaurantServiceHandle_Dish model:self.model];
    }
}

- (void)PlayWord
{
    if (_delegate && [_delegate respondsToSelector:@selector(RestaurantServiceDidHandle:model:)]) {
        [_delegate RestaurantServiceDidHandle:RestaurantServiceHandle_WordPlay model:self.model];
    }
}

- (void)stopPlayWord
{
    if (_delegate && [_delegate respondsToSelector:@selector(RestaurantServiceDidHandle:model:)]) {
        [_delegate RestaurantServiceDidHandle:RestaurantServiceHandle_WordStop model:self.model];
    }
}

- (void)PlayDish
{
    if (_delegate && [_delegate respondsToSelector:@selector(RestaurantServiceDidHandle:model:)]) {
        [_delegate RestaurantServiceDidHandle:RestaurantServiceHandle_DishPlay model:self.model];
    }
}

- (void)stopPlayDish
{
    if (_delegate && [_delegate respondsToSelector:@selector(RestaurantServiceDidHandle:model:)]) {
        [_delegate RestaurantServiceDidHandle:RestaurantServiceHandle_DishStop model:self.model];
    }
}


- (void)configWithModel:(RestaurantServiceModel *)model
{
    self.model = model;
    self.nameLabel.text = model.boxName;
    
    if (model.isPlayWord) {
        self.defaultWordButton.hidden = YES;
        self.stopWordButton.hidden = NO;
    }else{
        self.defaultWordButton.hidden = NO;
        self.stopWordButton.hidden = YES;
    }
    
    if (model.isPlayDish) {
        self.RecomDishButton.hidden = YES;
        self.stopDishButton.hidden = NO;
    }else{
        self.RecomDishButton.hidden = NO;
        self.stopDishButton.hidden = YES;
    }
    
    self.defaultWordLabel.text = model.DefaultWord;
    
    self.playWordLabel.hidden = !model.isPlayWord;
    self.playDishLabel.hidden = !model.isPlayDish;
}

@end
