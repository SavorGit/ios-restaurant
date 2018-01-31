//
//  RestaurantServiceCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/30.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RestaurantServiceCell.h"
#import "Helper.h"

@interface RestaurantServiceCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * defaultWordLabel;
@property (nonatomic, strong) UIButton * defaultWordButton;
@property (nonatomic, strong) UIButton * RecomDishButton;

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
    self.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.contentView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.layer.borderColor = UIColorFromRGB(0xdfd9d2).CGColor;
    self.layer.borderWidth = .5f;
    
    self.nameLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangMedium(20 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(17 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(22 * scale);
    }];
    
    UIView * wordView = [[UIView alloc] initWithFrame:CGRectZero];
    wordView.backgroundColor = UIColorFromRGB(0xfdfcfa);
}

@end
