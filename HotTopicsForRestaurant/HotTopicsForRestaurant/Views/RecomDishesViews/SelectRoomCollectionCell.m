//
//  SelectRoomCollectionCell.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SelectRoomCollectionCell.h"
#import "SAVORXAPI.h"

@interface SelectRoomCollectionCell()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SelectRoomCollectionCell

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
        make.top.mas_equalTo(0);
    }];

}

- (void)configModelData:(RecoDishesModel *)model andIsPortrait:(BOOL)isPortrait{
    
    self.titleLabel.text = model.title;
    
    [self.bgImageView setImage:[UIImage imageNamed:@"zanwu"]];
    
}

@end
