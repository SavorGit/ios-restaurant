//
//  ResSliderSettingView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResSliderSettingView.h"

@interface ResSliderSettingView ()

@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, weak) UIButton * selectButton;
@property (nonatomic, weak) UIButton * qualitySeButton;
@property (nonatomic, strong) UIView * sliderView;
@property (nonatomic, strong) UISlider * slider;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIButton * loopButton;
@property (nonatomic, strong) UILabel * qContentLabel;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, copy) void(^block)(NSInteger time,NSInteger quality, NSInteger totalTime);

@end

@implementation ResSliderSettingView

- (instancetype)initWithFrame:(CGRect)frame andType:(BOOL)isVideo block:(void (^)(NSInteger,NSInteger,NSInteger))block
{
    if (self = [super initWithFrame:frame]) {
        
        self.block = block;
        self.isVideo = isVideo;
        [self createUI];
        
    }
    return self;
}

- (void)createUI
{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    self.baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((kMainBoundsHeight - 290) / 2);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(250 + 85);
    }];
    self.baseView.layer.cornerRadius = 5.f;
    self.baseView.layer.masksToBounds = YES;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = [NSString stringWithFormat:@"正在投屏的包间 - %@", [Helper getWifiName]];
    titleLabel.backgroundColor = FontColor;
    titleLabel.textColor = UIColorFromRGB(0xffffff);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.baseView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    
    
    UILabel * qualityAlertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    qualityAlertLabel.textColor = UIColorFromRGB(0x4e4541);
    qualityAlertLabel.font = [UIFont systemFontOfSize:14];
    qualityAlertLabel.text = @"投屏质量";
    [self.baseView addSubview:qualityAlertLabel];
    [qualityAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(15);
    }];
    
    self.qContentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.qContentLabel.textColor = UIColorFromRGB(0x4e4541);
    self.qContentLabel.font = [UIFont systemFontOfSize:14];
    self.qContentLabel.text = @"(高质量投屏，速度较慢)";
    [self.baseView addSubview:self.qContentLabel];
    [self.qContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(qualityAlertLabel.mas_right).offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
    NSArray * qualityArray = @[[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:0]];
    NSArray * qualityTArray = @[@"高清",@"普通"];
    for (NSInteger i = 0; i < qualityArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = FontColor.CGColor;
        button.layer.borderWidth = .7f;
        NSInteger time = [[qualityArray objectAtIndex:i] integerValue];
        [button setTitle:qualityTArray[i] forState:UIControlStateNormal];
        [button setTitleColor:FontColor forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
        button.tag = time;
        [self.baseView addSubview:button];
        CGFloat distance = (kMainBoundsWidth - 50 - 60 * 2) / 3;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qualityAlertLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(60, 28));
            make.left.mas_equalTo(distance * (i + 1) + 60 * i);
        }];
        [button addTarget:self action:@selector(qualityButtonDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (time == 1) {
            self.qualitySeButton = button;
            [button setBackgroundColor:FontColor];
            button.selected = YES;
        }
    }
    
    UIView * lineViewZero = [[UIView alloc] initWithFrame:CGRectZero];
    [lineViewZero setBackgroundColor:UIColorFromRGB(0xd7d7d7)];
    [self.baseView addSubview:lineViewZero];
    [lineViewZero mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(qualityAlertLabel.mas_bottom).offset(55);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];

    UILabel * loopLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    loopLabel.textColor = UIColorFromRGB(0x4e4541);
    loopLabel.font = [UIFont systemFontOfSize:14];
    loopLabel.text = @"循环播放";
    [self.baseView addSubview:loopLabel];
    
    if (self.isVideo == NO) {
        UILabel * timeAlertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeAlertLabel.textColor = UIColorFromRGB(0x4e4541);
        timeAlertLabel.font = [UIFont systemFontOfSize:14];
        timeAlertLabel.text = @"单张图片停留时间";
        [self.baseView addSubview:timeAlertLabel];
        [timeAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineViewZero.mas_bottom).offset(15);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(15);
        }];
        
        NSArray * timeArray = @[[NSNumber numberWithInteger:3], [NSNumber numberWithInteger:5], [NSNumber numberWithInteger:8]];
        for (NSInteger i = 0; i < timeArray.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = FontColor.CGColor;
            button.layer.borderWidth = .7f;
            NSInteger time = [[timeArray objectAtIndex:i] integerValue];
            [button setTitle:[NSString stringWithFormat:@"%lds", time] forState:UIControlStateNormal];
            [button setTitleColor:FontColor forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
            button.tag = time;
            [self.baseView addSubview:button];
            CGFloat distance = (kMainBoundsWidth - 50 - 48 * 3) / 4;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(timeAlertLabel.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(48, 28));
                make.left.mas_equalTo(distance * (i + 1) + 48 * i);
            }];
            [button addTarget:self action:@selector(timeButtonDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if (time == 5) {
                self.selectButton = button;
                [button setBackgroundColor:FontColor];
                button.selected = YES;
            }
        }
        
        UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        [lineView1 setBackgroundColor:UIColorFromRGB(0xd7d7d7)];
        [self.baseView addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeAlertLabel.mas_bottom).offset(55);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(.5f);
        }];
        
        [loopLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView1.mas_bottom).offset(15);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(20);
        }];
    }else{
        
        [loopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineViewZero.mas_bottom).offset(15);
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(20);
        }];
        
        [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo((kMainBoundsHeight - 290) / 2);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(250);
        }];
    }
    
    self.loopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loopButton setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [self.loopButton setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
    [self.baseView addSubview:self.loopButton];
    [self.loopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loopLabel.mas_top);
        make.left.equalTo(loopLabel.mas_right).offset(10);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(20);
    }];
    [self.loopButton addTarget:self action:@selector(loopButtonDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.textColor = FontColor;
    self.timeLabel.font = [UIFont boldSystemFontOfSize:17];
    self.timeLabel.text = @"30分钟";
    [self.baseView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loopLabel.mas_top);
        make.left.equalTo(self.loopButton.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.hidden = YES;
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    [lineView2 setBackgroundColor:UIColorFromRGB(0xd7d7d7)];
    [self.baseView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:UIColorFromRGB(0x444444) forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((kMainBoundsWidth - 50) / 2);
        make.height.mas_equalTo(50);
    }];
    [cancleButton addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
    [lineView3 setBackgroundColor:UIColorFromRGB(0xd7d7d7)];
    [self.baseView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-3);
        make.left.equalTo(cancleButton.mas_right).offset(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(.5f);
    }];
    
    UIButton * okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:FontColor forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.baseView addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo((kMainBoundsWidth - 50) / 2);
        make.height.mas_equalTo(50);
    }];
    [okButton addTarget:self action:@selector(okButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseView.frame.size.width, 40)];
    UILabel * leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    leftTimeLabel.font = [UIFont systemFontOfSize:14];
    leftTimeLabel.text = @"1";
    leftTimeLabel.textAlignment = NSTextAlignmentCenter;
    leftTimeLabel.textColor = UIColorFromRGB(0x4e4541);
    [self.sliderView addSubview:leftTimeLabel];
    [leftTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(10, 40));
    }];
    
    UILabel * rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    rightTimeLabel.font = [UIFont systemFontOfSize:14];
    rightTimeLabel.text = @"120分钟";
    rightTimeLabel.textAlignment = NSTextAlignmentCenter;
    rightTimeLabel.textColor = UIColorFromRGB(0x4e4541);
    [self.sliderView addSubview:rightTimeLabel];
    [rightTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(55, 40));
    }];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.sliderView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(leftTimeLabel.mas_right).offset(5);
        make.bottom.mas_equalTo(0);
        make.right.equalTo(rightTimeLabel.mas_left).offset(-5);
    }];
    [self.slider setThumbImage:[UIImage imageNamed:@"thumImage"] forState:UIControlStateNormal];
    self.slider.minimumValue = 1;
    self.slider.maximumValue = 120;
    [self.slider setMinimumTrackTintColor:FontColor];
    [self.slider setValue:30];
    [self.slider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
}

- (void)okButtonDidBeClicked
{
    [self removeFromSuperview];
    NSInteger time = (NSInteger)self.slider.value;
    NSInteger totalTime = time * 60;
    if (self.loopButton.selected == NO) {
        totalTime = 0;
    }
    self.block(self.selectButton.tag,self.qualitySeButton.tag, totalTime);
}

- (void)sliderValueChange
{
    self.timeLabel.text = [NSString stringWithFormat:@"%ld分钟", (NSInteger)self.slider.value];
}

- (void)loopButtonDidBeClicked:(UIButton *)button
{
    button.selected = !button.isSelected;
    self.timeLabel.hidden = !button.isSelected;
    if (button.isSelected) {
        [self.slider setValue:30];
        self.timeLabel.text = @"30分钟";
        if (self.isVideo == NO){
            [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(290 + 85);
            }];
        }else{
            [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250 + 40);
            }];
        }
        
        [self.baseView addSubview:self.sliderView];
        [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(-70);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
    }else{
        [self.sliderView removeFromSuperview];
        if (self.isVideo == NO){
            [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250 + 85);
            }];
        }else{
            [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(250);
            }];
        }
        
    }
}

- (void)qualityButtonDidBeClicked:(UIButton *)button
{
    if (button.tag == 1) {
        self.qContentLabel.text = @"(高质量投屏，速度较慢)";
    }else if (button.tag == 0){
        self.qContentLabel.text = @"(投屏质量一般，速度较快)";
    }
    
    self.qualitySeButton.selected = NO;
    [self.qualitySeButton setBackgroundColor:[UIColor whiteColor]];
    
    [button setBackgroundColor:FontColor];
    button.selected = YES;
    self.qualitySeButton = button;
}

- (void)timeButtonDidBeClicked:(UIButton *)button
{
    self.selectButton.selected = NO;
    [self.selectButton setBackgroundColor:[UIColor whiteColor]];
    
    [button setBackgroundColor:FontColor];
    button.selected = YES;
    self.selectButton = button;
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end
