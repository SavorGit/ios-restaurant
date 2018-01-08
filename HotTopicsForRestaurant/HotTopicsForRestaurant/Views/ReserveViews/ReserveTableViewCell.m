//
//  ReserveTableViewCell.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ReserveTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ReserveTableViewCell ()

@property (nonatomic, strong) UIImageView * bgView;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *rNameLabel; // 餐厅名字

@property (nonatomic, strong) UILabel *peopleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *markLabel;

@property (nonatomic, strong) UIButton *welcomBtn;

@property (nonatomic, strong) UIButton *dishBtn;

@property (nonatomic, strong) UIButton *recordBtn;

@end

@implementation ReserveTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView{
    
    CGFloat scale = kMainBoundsWidth/375.0;
    
    _bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self addSubview:_bgView];
    CGFloat bgViewHeight = 105;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(bgViewHeight);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    _rNameLabel = [[UILabel alloc] init];
    _rNameLabel.backgroundColor = [UIColor lightGrayColor];
    _rNameLabel.layer.cornerRadius = 5.0f;
    _rNameLabel.layer.masksToBounds = YES;
    _rNameLabel.font = kPingFangMedium(17);
    _rNameLabel.textColor = UIColorFromRGB(0xffffff);
    _rNameLabel.textAlignment = NSTextAlignmentCenter;
    _rNameLabel.numberOfLines = 3;
    _rNameLabel.text = @"餐厅\n名字";
    [_bgView addSubview:_rNameLabel];
    [_rNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(75);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"13:00";
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = kPingFangMedium(18);
    _timeLabel.textColor = UIColorFromRGB(0x434343);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 *scale, 20));
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(_rNameLabel.mas_right).offset(15);
    }];
    
    _peopleLabel = [[UILabel alloc]init];
    _peopleLabel.text = @"5 人";
    _peopleLabel.backgroundColor = [UIColor clearColor];
    _peopleLabel.font = kPingFangMedium(18);
    _peopleLabel.textColor = UIColorFromRGB(0x434343);
    _peopleLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_peopleLabel];
    [_peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80 *scale, 20));
        make.top.mas_equalTo(19);
        make.left.mas_equalTo(_timeLabel.mas_right).offset(25);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"名字";
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = kPingFangLight(14);
    _nameLabel.textColor = UIColorFromRGB(0x84827f);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80 *scale, 20));
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_rNameLabel.mas_right).offset(15);
    }];
    
    _phoneLabel = [[UILabel alloc]init];
    _phoneLabel.text = @"电话";
    _phoneLabel.font = kPingFangRegular(14);
    _phoneLabel.textColor = UIColorFromRGB(0x666666);
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100 *scale, 20));
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(5);
        make.left.mas_lessThanOrEqualTo(_nameLabel.mas_right).offset(10);
    }];

    _welcomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_welcomBtn setImage:[UIImage imageNamed:@"sy_hyc2"] forState:UIControlStateNormal];
    [_welcomBtn setImage:[UIImage imageNamed:@"sy_hyc"] forState:UIControlStateSelected];
    [_bgView addSubview:_welcomBtn];
    [_welcomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 18));
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(- 17);
        make.left.mas_equalTo(_rNameLabel.mas_right).offset(15);
    }];
    
    _dishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dishBtn setImage:[UIImage imageNamed:@"sy_tjc2"] forState:UIControlStateNormal];
    [_dishBtn setImage:[UIImage imageNamed:@"sy_tjc"] forState:UIControlStateSelected];
    [_bgView addSubview:_dishBtn];
    [_dishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(52, 18));
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(- 17);
        make.left.mas_equalTo(_welcomBtn.mas_right).offset(19);
    }];
    
    _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordBtn setImage:[UIImage imageNamed:@"sy_xfjl2"] forState:UIControlStateNormal];
    [_recordBtn setImage:[UIImage imageNamed:@"sy_xfjl"] forState:UIControlStateSelected];
    [_bgView addSubview:_recordBtn];
    [_recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 18));
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(- 17);
        make.left.mas_equalTo(_dishBtn.mas_right).offset(19);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xe1dbd4);
    [_bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 15, 1));
        make.top.mas_equalTo(self.mas_bottom).offset(- 1);
        make.left.mas_equalTo(15);
    }];
}

- (void)configWithModel:(ReserveModel *)model andIndex:(NSIndexPath *)index
{
    NSMutableString *rNameStr = [[NSMutableString alloc] initWithString: model.room_name];
    if (rNameStr.length == 4 || rNameStr.length == 5) {
        [rNameStr insertString:@"\n" atIndex:2];
        
    }else if (rNameStr.length == 6){
        [rNameStr insertString:@"\n" atIndex:3];
    }
    else if (rNameStr.length == 7 || rNameStr.length == 8 || rNameStr.length == 9 ){
        [rNameStr insertString:@"\n" atIndex:3];
        [rNameStr insertString:@"\n" atIndex:7];
    }
    
    if (model.is_welcome == 1) {
        _welcomBtn.selected = YES;
    }else{
        _welcomBtn.selected = NO;
    }
    
    if (model.is_recfood == 1) {
        _dishBtn.selected = YES;
    }else{
        _dishBtn.selected = NO;
    }
    
    if (model.is_expense == 1) {
        _recordBtn.selected = YES;
    }else{
        _recordBtn.selected = NO;
    }
    
    _rNameLabel.text = rNameStr;
    _timeLabel.text = model.moment_str;
    if (!isEmptyString(model.person_nums)) {
        _peopleLabel.text = [NSString stringWithFormat:@"%@人",model.person_nums];
    }else{
        _peopleLabel.text = @"";
    }
    
    CGSize orderSize = [model.order_name sizeWithAttributes:@{NSFontAttributeName:_nameLabel.font}];
    if (model.order_name.length < 9) {
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(orderSize.width);
        }];
    }else{
        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(132);
        }];
    }
    
    _nameLabel.text = model.order_name;
    _phoneLabel.text = model.order_mobile;
    
    int value = index.row % (4);
    // 除4取余
    // 0余0 1余1 2余2 3余3 4余0
    if (0 == value) {
        _rNameLabel.backgroundColor = UIColorFromRGB(0xd19d83);
    } else if (1 == value) {
        _rNameLabel.backgroundColor = UIColorFromRGB(0x9c9c83);
    } else if (2 == value) {
        _rNameLabel.backgroundColor = UIColorFromRGB(0x7b9ec2);
    } else {
        _rNameLabel.backgroundColor = UIColorFromRGB(0x83859c);
    }
}

@end
