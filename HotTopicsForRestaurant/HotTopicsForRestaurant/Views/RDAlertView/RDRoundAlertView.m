//
//  RDRoundAlertView.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RDRoundAlertView.h"
#import "IQKeyboardManager.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RDRoundAlertView ()

@property (nonatomic, strong) UIView * showView;

@end

@implementation RDRoundAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self createAlertWithTitle:title message:message];
        self.tag = 333;
    }
    return self;
}

- (void)createAlertWithTitle:(NSString *)title message:(NSString *)message
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.7f];
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300 * scale, 200 * scale)];
    self.showView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [self addSubview:self.showView];
    self.showView.layer.cornerRadius = 8.f * scale;
    self.showView.layer.masksToBounds = YES;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * scale, 20 * scale, self.showView.frame.size.width - 20 * scale, 20 * scale)];
    titleLabel.textColor = UIColorFromRGB(0x922c3e);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:18 * scale];
    [self.showView addSubview:titleLabel];
    
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * scale, 40 * scale, self.showView.frame.size.width - 20 * scale, 110 * scale)];
    messageLabel.textColor = UIColorFromRGB(0x333333);
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont systemFontOfSize:17 * scale];
    [self.showView addSubview:messageLabel];
}

- (void)show
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    UIView * view = [[UIApplication sharedApplication].keyWindow viewWithTag:333];
    if (view) {
        [view removeFromSuperview];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300 * scale, 200 * scale));
        if ([IQKeyboardManager sharedManager].isKeyboardShowing) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-self.frame.size.width / 4);
        }else{
            make.center.mas_equalTo(0);
        }
    }];
}

- (void)addActions:(NSArray<RDRoundAlertAction *> *)actions
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (actions.count == 1) {
        RDRoundAlertAction * action = [actions firstObject];
        [action addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:action];
        [action mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(160 * scale, 36 * scale));
            make.bottom.mas_equalTo(-15 * scale);
            make.centerX.mas_equalTo(0);
        }];
        action.layer.cornerRadius = 18 * scale;
        action.layer.masksToBounds = YES;
    }else if (actions.count == 2) {
        RDRoundAlertAction * leftAction = [actions firstObject];
        [leftAction addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:leftAction];
        CGFloat width = (self.showView.frame.size.width - 40 * scale - 15 * scale) / 2;
        [leftAction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20 * scale);
            make.bottom.mas_equalTo(-15 * scale);
            make.height.mas_equalTo(36 * scale);
            make.width.mas_equalTo(width);
        }];
        leftAction.layer.cornerRadius = 18 * scale;
        leftAction.layer.masksToBounds = YES;
        
        RDRoundAlertAction * rightAction = [actions lastObject];
        [rightAction addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:rightAction];
        [rightAction mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20 * scale);
            make.bottom.mas_equalTo(-15 * scale);
            make.height.mas_equalTo(36 * scale);
            make.width.mas_equalTo(width);
        }];
        rightAction.layer.cornerRadius = 18 * scale;
        rightAction.layer.masksToBounds = YES;
    }
}

- (void)actionDidBeClicked:(RDRoundAlertAction *)action
{
    if (action.block) {
        action.block();
    }
    [self removeFromSuperview];
}

@end
