//
//  SingleAddressCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleAddressCell.h"

@interface SingleAddressCell ()

@property (nonatomic, strong) UIButton * addButton;

@end

@implementation SingleAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSingleCell];
    }
    return self;
}

- (void)createSingleCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.addButton = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) backgroundColor:[UIColor clearColor] title:@"添加" cornerRadius:5.f];
    self.addButton.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    self.addButton.layer.borderWidth = .5f;
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20 * scale);
        make.width.mas_equalTo(50 * scale);
        make.height.mas_equalTo(25 * scale);
    }];
    [self.addButton addTarget:self action:@selector(addButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addButtonDidClicked
{
    self.addButtonHandle(self.model);
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
