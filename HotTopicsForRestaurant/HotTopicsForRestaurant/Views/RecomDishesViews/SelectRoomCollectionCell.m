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
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = kPingFangRegular(16);
    self.titleLabel.textColor = UIColorFromRGB(0x922c3e);
    self.titleLabel.text = @"这是标题";
    self.titleLabel.layer.cornerRadius = 5.f;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.borderColor = UIColorFromRGB(0x922c3e).CGColor;
    self.titleLabel.layer.borderWidth = 1.f;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(36 *scale);
        make.top.mas_equalTo(0);
    }];

}

- (void)configModelData:(RDBoxModel *)model{
    
    self.titleLabel.text = model.sid;
    
}

@end
