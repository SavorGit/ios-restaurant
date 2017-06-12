//
//  AnimationImageView.m
//  SavorX
//
//  Created by 郭春城 on 16/9/2.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "AnimationImageView.h"

@implementation AnimationImageView

- (void)setAnimationImages:(NSArray<UIImage *> *)animationImages
{
    [super setAnimationImages:animationImages];
    //检测应用进入活跃状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationRestart) name:UIApplicationDidBecomeActiveNotification object:nil];
}

//为保证动画正常进行，在应用进入活跃状态的时候重新开启动画
- (void)animationRestart
{
    [self startAnimating];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

@end
