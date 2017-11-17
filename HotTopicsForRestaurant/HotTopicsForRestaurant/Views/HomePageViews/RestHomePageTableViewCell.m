//
//  RestHomePageTableViewCell.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/6/9.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "RestHomePageTableViewCell.h"

@implementation RestHomePageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView.backgroundColor = UIColorFromRGB(0xffffff);
    _bgImageView.layer.cornerRadius = 3.0;
    _bgImageView.layer.shadowColor = UIColorFromRGB(0xebebeb).CGColor;//shadowColor阴影颜色
    _bgImageView.layer.shadowOffset = CGSizeMake(0,0);
    _bgImageView.layer.shadowOpacity = 0.30;//阴影透明度，默认0
    _bgImageView.layer.shadowRadius = 2;//阴影半径，默认3
    [self.contentView addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
    }];
    
    _classImageView = [[UIImageView alloc]init];
    [_bgImageView addSubview:_classImageView];
    [_classImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(38,38));
        make.centerY.mas_equalTo(-15);
        make.centerX.mas_equalTo(self);
    }];
    
    _classTitleLabel = [[UILabel alloc] init];
    _classTitleLabel.text = @"标题";
    _classTitleLabel.textAlignment = NSTextAlignmentCenter;
    _classTitleLabel.font = [UIFont systemFontOfSize:16];
    _classTitleLabel.textColor = UIColorFromRGB(0x333333);
    [_bgImageView addSubview:_classTitleLabel];
    [_classTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(_classImageView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self);
    }];
    
    _unavaiTitleLabel = [[UILabel alloc] init];
    _unavaiTitleLabel.text = @"不可用标题";
    _unavaiTitleLabel.textAlignment = NSTextAlignmentCenter;
    _unavaiTitleLabel.font = [UIFont systemFontOfSize:16];
    _unavaiTitleLabel.textColor = UIColorFromRGB(0xacacac);
    [_bgImageView addSubview:_unavaiTitleLabel];
    [_unavaiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(55, 30));
        make.center.mas_equalTo(self);
    }];

}

- (void)configDatas:(NSArray *)dataArr withIndex:(NSIndexPath *)index{
    
    if (index.row == 0) {
        _unavaiTitleLabel.hidden = YES;
        _classTitleLabel.text = dataArr[index.row];
        [_classImageView setImage:[UIImage imageNamed:@"tp"]];
    }else if (index.row == 1) {
        _unavaiTitleLabel.hidden = YES;
        _classTitleLabel.text = dataArr[index.row];
        [_classImageView setImage:[UIImage imageNamed:@"sp"]];
    }else {
        _classTitleLabel.hidden = YES;
        _classImageView.hidden = YES;
        _bgImageView.backgroundColor = UIColorFromRGB(0xe7e7e7);
        _unavaiTitleLabel.text = dataArr[index.row];
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
