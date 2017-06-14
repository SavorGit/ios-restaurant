//
//  ResSliderSettingView.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/13.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResSliderSettingView : UIView

- (instancetype)initWithFrame:(CGRect)frame block:(void(^)(NSInteger time, NSInteger totalTime))block;

- (void)show;

@end
