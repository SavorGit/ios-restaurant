//
//  ResKeyWordBGCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResKeyWordBGCell.h"

@interface ResKeyWordBGCell ()

@property (nonatomic, strong) UIImageView * BGImageview;
@property (nonatomic, strong) UILabel * keyWordLabel;

@end

@implementation ResKeyWordBGCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createKeyWordCell];
    }
    return self;
}

- (void)createKeyWordCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.BGImageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.BGImageview];
    [self.BGImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.keyWordLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(17 * scale) alignment:NSTextAlignmentCenter];
    self.keyWordLabel.numberOfLines = 0;
    [self.contentView addSubview:self.keyWordLabel];
    [self.keyWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(30 * scale);
        make.right.mas_equalTo(-30 * scale);
    }];
    self.keyWordLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.keyWordLabel.layer.shadowOpacity = .3f;
    self.keyWordLabel.layer.shadowOffset = CGSizeMake(1, 1);
}

- (void)configWithImageName:(NSString *)imageName title:(NSString *)title
{
    [self.BGImageview setImage:[UIImage imageNamed:imageName]];
    self.keyWordLabel.text = title;
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
