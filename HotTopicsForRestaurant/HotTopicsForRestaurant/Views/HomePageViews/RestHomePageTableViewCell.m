//
//  RestHomePageTableViewCell.m
//  小热点餐厅端Demo
//
//  Created by 王海朋 on 2017/6/9.
//  Copyright © 2017年 wanghaipeng. All rights reserved.
//

#import "RestHomePageTableViewCell.h"
#import "Masonry.h"

@implementation RestHomePageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 30,([UIScreen mainScreen].bounds.size.height - 124)/4 - 10));
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(15);
    }];
    
    _classImageView = [[UIImageView alloc]init];
    [_bgImageView addSubview:_classImageView];
    [_classImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40,39));
        make.center.mas_equalTo(self);
    }];
    
    _classTitleLabel = [[UILabel alloc] init];
    _classTitleLabel.text = @"标题";
    _classTitleLabel.textAlignment = NSTextAlignmentCenter;
    _classTitleLabel.font = [UIFont systemFontOfSize:16];
    _classTitleLabel.textColor = UIColorFromRGB(0xacacac);
    [_bgImageView addSubview:_classTitleLabel];
    [_classTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 30));
        make.top.mas_equalTo(_classImageView.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self);
    }];
    
    _unavaiTitleLabel = [[UILabel alloc] init];
    _unavaiTitleLabel.text = @"隐藏标题";
    [_bgImageView addSubview:_unavaiTitleLabel];
    [_unavaiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 30));
        make.center.mas_equalTo(self);
    }];

}

- (void)configDatas:(NSArray *)dataArr withIndex:(NSIndexPath *)index{
    
    if (index.row == 0) {
        _unavaiTitleLabel.hidden = YES;
        _classTitleLabel.text = dataArr[index.row];
        [_classImageView setImage:[UIImage imageNamed:@"huandengpian"]];
    }else{
        _classTitleLabel.hidden = YES;
        _classImageView.hidden = YES;
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
