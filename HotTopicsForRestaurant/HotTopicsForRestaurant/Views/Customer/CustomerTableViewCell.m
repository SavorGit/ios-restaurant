//
//  CustomerTableViewCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "CustomerTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CustomerTableViewCell ()

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * telLabel;
@property (nonatomic, strong) UILabel * logoLabel;

@end

@implementation CustomerTableViewCell

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
    
    self.backgroundColor = UIColorFromRGB(0xf6f2ed);
    self.contentView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    CGFloat logoWidth = 42 * scale;
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
    
    self.nameLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(16 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12 * scale);
        make.height.mas_equalTo(17 * scale);
        make.left.mas_equalTo(30 * scale + logoWidth);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.telLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.telLabel];
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12 * scale);
        make.height.mas_equalTo(15 * scale);
        make.left.mas_equalTo(30 * scale + logoWidth);
        make.right.mas_equalTo(-15 * scale);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
