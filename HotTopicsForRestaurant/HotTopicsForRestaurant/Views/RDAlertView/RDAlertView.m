//
//  RDAlertView.m
//  Test - 2.1
//
//  Created by 郭春城 on 17/3/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDAlertView.h"

@interface RDAlertView ()

@property (nonatomic, strong) UIView * showView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * messageLabel;

@end

@implementation RDAlertView

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
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 60, 182)];
    self.showView.backgroundColor = [UIColor whiteColor];
    self.showView.center = CGPointMake((self.frame.origin.x + self.frame.size.width) / 2, (self.frame.origin.y + self.frame.size.height) / 2);
    [self addSubview:self.showView];
    self.showView.layer.cornerRadius = 8.f;
    self.showView.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.showView.frame.size.width - 20, 20)];
    self.titleLabel.textColor = UIColorFromRGB(0x222222);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.showView addSubview:self.titleLabel];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.showView.frame.size.width - 20, 92)];
    self.messageLabel.textColor = UIColorFromRGB(0x333333);
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.text = message;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize:17];
    [self.showView addSubview:self.messageLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 132, self.showView.frame.size.width, .5f)];
    lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
    [self.showView addSubview:lineView];
}

- (void)show
{
    UIView * view = [[UIApplication sharedApplication].keyWindow viewWithTag:333];
    if (view) {
        [view removeFromSuperview];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60, 182));
        make.center.mas_equalTo(0);
    }];
}

- (void)addActions:(NSArray<RDAlertAction *> *)actions
{
    CGFloat width = self.showView.frame.size.width;
    if (actions.count == 1) {
        RDAlertAction * action = [actions firstObject];
        [action setFrame:CGRectMake(0, 132, width, 50)];
        [action addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:action];
    }else if (actions.count == 2) {
        RDAlertAction * leftAction = [actions firstObject];
        [leftAction setFrame:CGRectMake(0, 132, width / 2, 50)];
        [leftAction addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:leftAction];
        
        RDAlertAction * rightAction = [actions lastObject];
        [rightAction setFrame:CGRectMake(width / 2, 132, width / 2, 50)];
        [rightAction addTarget:self action:@selector(actionDidBeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:rightAction];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(width / 2, 137, .5f, 40)];
        lineView.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self.showView addSubview:lineView];
    }
}

- (void)actionDidBeClicked:(RDAlertAction *)action
{
    if (action.block) {
        action.block();
    }
    [self removeFromSuperview];
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)setMessageFont:(UIFont *)font
{
    self.messageLabel.font = font;
}

@end
