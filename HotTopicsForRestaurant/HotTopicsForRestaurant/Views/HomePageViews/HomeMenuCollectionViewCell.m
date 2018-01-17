//
//  HomeMenuCollectionViewCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeMenuCollectionViewCell.h"

@interface HomeMenuCollectionViewCell ()

@property (nonatomic, strong) UIImageView * menuImageView;
@property (nonatomic, strong) UILabel * menuNameLabel;

@end

@implementation HomeMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.layer.cornerRadius = 5 * scale;
    self.layer.masksToBounds = YES;
    
    self.menuImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.menuImageView];
    [self.menuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(95 * scale);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(13 * scale);
    }];
    
    self.menuNameLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x444444) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.menuNameLabel];
    [self.menuNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(15 * scale + 1);
    }];
}

- (void)configWithModel:(ResHomeListModel *)model
{
    [self.menuImageView setImage:[UIImage imageNamed:model.imageName]];
    [self.menuNameLabel setText:model.title];
}

@end
