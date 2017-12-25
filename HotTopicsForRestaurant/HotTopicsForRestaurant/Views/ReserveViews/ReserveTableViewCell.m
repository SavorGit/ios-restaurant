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

@property (nonatomic, strong) UILabel *timeSolt;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *rNameLabel; // 餐厅名字

@property (nonatomic, strong) UILabel *peopleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UILabel *markLabel;

@property (nonatomic, strong) UILabel *welcomLabel;

@property (nonatomic, strong) UILabel *dishLabel;

@property (nonatomic, strong) UILabel *recordLabel;

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
    _bgView.backgroundColor = UIColorFromRGB(0xeee8e0);
    [self addSubview:_bgView];
    CGFloat bgViewHeight = 100 *scale;
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(bgViewHeight);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    _rNameLabel = [[UILabel alloc] init];
    _rNameLabel.backgroundColor = [UIColor lightGrayColor];
    _rNameLabel.layer.borderWidth = 0.5f;
    _rNameLabel.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    _rNameLabel.layer.cornerRadius = 3.0f;
    _rNameLabel.layer.masksToBounds = YES;
    _rNameLabel.font = kPingFangMedium(15);
    _rNameLabel.textColor = [UIColor whiteColor];
    _rNameLabel.textAlignment = NSTextAlignmentCenter;
    _rNameLabel.numberOfLines = 3;
    _rNameLabel.text = @"餐厅\n名字";
    [_bgView addSubview:_rNameLabel];
    [_rNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80 *scale);
        make.height.mas_equalTo(75);
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
//    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
//    _bgImageView.layer.masksToBounds = YES;
//    _bgImageView.backgroundColor = [UIColor lightGrayColor];
//    [_bgView addSubview:_bgImageView];
//    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(80 *scale);
//        make.height.mas_equalTo(75);
//        make.top.mas_equalTo(15);
//        make.left.mas_equalTo(15);
//    }];
    
    _timeSolt = [[UILabel alloc] init];
    _timeSolt.font = kPingFangMedium(15);
    _timeSolt.textColor = UIColorFromRGB(0x84827f);
    _timeSolt.textAlignment = NSTextAlignmentLeft;
    _timeSolt.text = @"标题";
    [_bgView addSubview:_timeSolt];
    [_timeSolt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(30 *scale);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(_rNameLabel.mas_right).offset(10);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = @"13:00";
    _timeLabel.font = kPingFangMedium(15);
    _timeLabel.textColor = UIColorFromRGB(0x84827f);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 *scale, 20));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(_timeSolt.mas_right).offset(15);
    }];
    
    _peopleLabel = [[UILabel alloc]init];
    _peopleLabel.text = @"5 人";
    _peopleLabel.font = kPingFangMedium(15);
    _peopleLabel.textColor = UIColorFromRGB(0x84827f);
    _peopleLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_peopleLabel];
    [_peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100 *scale, 20));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(_timeLabel.mas_right).offset(15);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"名字";
    _nameLabel.font = kPingFangLight(14);
    _nameLabel.textColor = UIColorFromRGB(0x84827f);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 *scale, 20));
        make.top.mas_equalTo(_timeSolt.mas_bottom).offset(10);
        make.left.mas_equalTo(_rNameLabel.mas_right).offset(10);
    }];
    
    _phoneLabel = [[UILabel alloc]init];
    _phoneLabel.text = @"电话";
    _phoneLabel.font = kPingFangLight(14);
    _phoneLabel.textColor = UIColorFromRGB(0x84827f);
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    [_bgView addSubview:_phoneLabel];
    [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100 *scale, 20));
        make.top.mas_equalTo(_timeSolt.mas_bottom).offset(10);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [_bgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 15, 1));
        make.bottom.mas_equalTo(self.mas_bottom).offset(- 1);
        make.left.mas_equalTo(15);
    }];
    
    _welcomLabel = [[UILabel alloc]init];
    _welcomLabel.text = @"欢迎词";
    _welcomLabel.font = kPingFangLight(14);
    _welcomLabel.textColor = UIColorFromRGB(0x84827f);
    _welcomLabel.textAlignment = NSTextAlignmentCenter;
    _welcomLabel.layer.cornerRadius = 3.0f;
    _welcomLabel.layer.borderWidth = 1.0f;
    _welcomLabel.layer.masksToBounds = YES;
    _welcomLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_bgView addSubview:_welcomLabel];
    [_welcomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50 *scale, 20));
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_rNameLabel.mas_right).offset(10);
    }];
    
    _dishLabel = [[UILabel alloc]init];
    _dishLabel.text = @"推荐菜";
    _dishLabel.font = kPingFangLight(14);
    _dishLabel.textColor = UIColorFromRGB(0x84827f);
    _dishLabel.textAlignment = NSTextAlignmentCenter;
    _dishLabel.layer.cornerRadius = 3.0f;
    _dishLabel.layer.borderWidth = 1.0f;
    _dishLabel.layer.masksToBounds = YES;
    _dishLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_bgView addSubview:_dishLabel];
    [_dishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50 *scale, 20));
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_welcomLabel.mas_right).offset(10);
    }];
    
    _recordLabel = [[UILabel alloc]init];
    _recordLabel.text = @"消费记录";
    _recordLabel.font = kPingFangLight(14);
    _recordLabel.textColor = UIColorFromRGB(0x84827f);
    _recordLabel.textAlignment = NSTextAlignmentCenter;
    _recordLabel.layer.cornerRadius = 3.0f;
    _recordLabel.layer.borderWidth = 1.0f;
    _recordLabel.layer.masksToBounds = YES;
    _recordLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_bgView addSubview:_recordLabel];
    [_recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 *scale, 20));
        make.top.mas_equalTo(_nameLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(_dishLabel.mas_right).offset(10);
    }];
}

- (void)configWithModel:(ReserveModel *)model
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
        _welcomLabel.textColor = [UIColor blueColor];
        _welcomLabel.layer.borderColor = [UIColor blueColor].CGColor;
    }else{
        _welcomLabel.textColor = UIColorFromRGB(0x84827f);
        _welcomLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (model.is_recfood == 1) {
        _dishLabel.textColor = [UIColor blueColor];
        _dishLabel.layer.borderColor = [UIColor blueColor].CGColor;
    }else{
        _dishLabel.textColor = UIColorFromRGB(0x84827f);
        _dishLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (model.is_expense == 1) {
        _recordLabel.textColor = [UIColor blueColor];
        _recordLabel.layer.borderColor = [UIColor blueColor].CGColor;
    }else{
        _recordLabel.textColor = UIColorFromRGB(0x84827f);
        _recordLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    _rNameLabel.text = rNameStr;
    _timeSolt.text = model.time_str;
    _timeLabel.text = model.moment_str;
    _peopleLabel.text = model.person_nums;
    _nameLabel.text = model.order_name;
    _phoneLabel.text = model.order_mobile;
    
    
}

@end
