//
//  AddressBookTableViewCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddressBookTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface AddressBookTableViewCell ()

@property (nonatomic, strong) UILabel * existLabel;

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * telLabel;
@property (nonatomic, strong) UILabel * logoLabel;

@end

@implementation AddressBookTableViewCell

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
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    CGFloat logoWidth = 50 * scale;
    [self.contentView addSubview:self.logoImageView];
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
    [self.contentView addSubview:self.logoLabel];
    [self.logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(logoWidth);
        make.height.mas_equalTo(logoWidth);
    }];
    self.logoLabel.layer.cornerRadius = logoWidth / 2;
    self.logoLabel.layer.masksToBounds = YES;
    
    self.nameLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(17 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.height.mas_equalTo(19 * scale);
        make.left.mas_equalTo(30 * scale + logoWidth);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.telLabel = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.telLabel];
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(16 * scale);
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
    self.model = model;
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

- (void)existCustomer:(BOOL)hasExist
{
    if (hasExist) {
        self.existLabel.hidden = NO;
    }else{
        self.existLabel.hidden = YES;
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
