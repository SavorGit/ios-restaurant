//
//  MultiSelectAddressCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MultiSelectAddressCell.h"
#import "UIImageView+WebCache.h"

@interface MultiSelectAddressCell ()

@property (nonatomic, strong) UILabel * existLabel;

@property (nonatomic, strong) UIView * baseView;

@property (nonatomic, strong) UIImageView * selectImage;

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * telLabel;
@property (nonatomic, strong) UILabel * logoLabel;

@end

@implementation MultiSelectAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createAddressBookCell];
    }
    return self;
}

- (void)createAddressBookCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.selectImage];
    [self.selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.width.height.mas_equalTo(20 * scale);
    }];
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(self.selectImage.mas_right).offset((5 * scale));
    }];
    
    self.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.contentView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    CGFloat logoWidth = 42 * scale;
    [self.baseView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(logoWidth);
        make.height.mas_equalTo(logoWidth);
    }];
    self.logoImageView.layer.cornerRadius = logoWidth / 2;
    self.logoImageView.layer.masksToBounds = YES;
    
    self.logoLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(logoWidth - 20 * scale) alignment:NSTextAlignmentCenter];
    self.logoLabel.backgroundColor = [UIColor grayColor];
    [self.baseView addSubview:self.logoLabel];
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(logoWidth);
        make.height.mas_equalTo(logoWidth);
    }];
    self.logoLabel.layer.cornerRadius = logoWidth / 2;
    self.logoLabel.layer.masksToBounds = YES;
    
    self.nameLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    [self.baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12 * scale);
        make.height.mas_equalTo(17 * scale);
        make.left.mas_equalTo(30 * scale + logoWidth);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.telLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    [self.baseView addSubview:self.telLabel];
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12 * scale);
        make.height.mas_equalTo(15 * scale);
        make.left.mas_equalTo(30 * scale + logoWidth);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.existLabel = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentCenter];
    self.existLabel.text = @"已添加";
    [self.contentView addSubview:self.existLabel];
    [self.existLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10 * scale);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
}

- (void)configWithAddressModel:(RDAddressModel *)model
{
    if (isEmptyString(model.logoImageURL)) {
        self.logoLabel.text = [model.name substringToIndex:1];
        self.logoLabel.hidden = NO;
        self.logoImageView.hidden = YES;
    }else{
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:model.logoImageURL]];
        self.logoLabel.hidden = YES;
        self.logoImageView.hidden = NO;
    }
    
    self.nameLabel.text = model.name;
    
    if (model.mobileArray && model.mobileArray.count > 0) {
        
        NSString * tel;
        for (NSInteger i = 0; i < model.mobileArray.count; i++) {
            if (isEmptyString(tel)) {
                tel = [model.mobileArray objectAtIndex:i];
            }else{
                tel = [NSString stringWithFormat:@"%@/%@", tel, [model.mobileArray objectAtIndex:i]];
            }
        }
        self.telLabel.text = tel;
        
    }else{
        self.telLabel.text = @"";
    }
}

- (void)mulitiSelected:(BOOL)isSelected
{
    if (!self.hasExist) {
        if (isSelected) {
            [self.selectImage setImage:[UIImage imageNamed:@"dx_xzh"]];
        }else{
            [self.selectImage setImage:[UIImage imageNamed:@"dx_weix"]];
        }
    }
}

- (void)existCustomer:(BOOL)hasExist
{
    self.hasExist = hasExist;
    if (hasExist) {
        self.existLabel.hidden = NO;
        [self.selectImage setImage:[UIImage imageNamed:@"dx_ytj"]];
    }else{
        self.existLabel.hidden = YES;
        [self.selectImage setImage:[UIImage imageNamed:@"dx_weix"]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
