//
//  RecoDishesCollectionViewCell.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RecoDishesCollectionViewCell.h"
#import "SAVORXAPI.h"

@interface RecoDishesCollectionViewCell()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RecoDishesCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.layer.masksToBounds = YES;
    _bgImageView.userInteractionEnabled = YES;
    _bgImageView.backgroundColor = [UIColor  cyanColor];
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(167.5f *scale, 120.f *scale));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = kPingFangMedium(15);
    _titleLabel.textColor = UIColorFromRGB(0xffffff);
    _titleLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    _titleLabel.text = @"这是标题";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(36 *scale);
        make.top.equalTo(_bgImageView.mas_bottom).offset(- 36 *scale);
    }];
    
    UIButton * selectButton = [SAVORXAPI buttonWithTitleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16] backgroundColor:[UIColor clearColor] title:nil cornerRadius:0.f];
    [selectButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"yixuanzhong"] forState:UIControlStateSelected];
    [_bgImageView addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.mas_equalTo(_bgImageView.mas_right).offset(- 10);
        make.top.mas_equalTo(_bgImageView.mas_top).offset(8);
    }];
    [selectButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *toScreenBtn = [SAVORXAPI buttonWithTitleColor:[UIColor whiteColor] font:kPingFangMedium(15) backgroundColor:[UIColor clearColor] title:@"投屏" cornerRadius:5.f];
    [toScreenBtn setTitleColor:UIColorFromRGB(0xff783d) forState:UIControlStateNormal];
    [self addSubview:toScreenBtn];
    [toScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(57.5f *scale, 28.f *scale));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_bgImageView.mas_bottom).offset(7 *scale);
    }];
    toScreenBtn.layer.borderColor = UIColorFromRGB(0xff783d).CGColor;
    toScreenBtn.layer.borderWidth = 1.f;
    [toScreenBtn addTarget:self action:@selector(toScreenBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (void)configModelData:(RecoDishesModel *)model andIsPortrait:(BOOL)isPortrait{
   
    self.titleLabel.text = model.chinese_name;
    
    [self.bgImageView setImage:[UIImage imageNamed:@"zanwu"]];
    
}

- (void)selectButtonDidClicked:(UIButton *)Button{
    Button.selected = !Button.selected;
}

- (void)toScreenBtnDidClicked:(UIButton *)Button{
}

@end
