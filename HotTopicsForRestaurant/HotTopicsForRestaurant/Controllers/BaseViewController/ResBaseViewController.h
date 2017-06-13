//
//  ResBaseViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface ResBaseViewController : UIViewController

@property(nonatomic, strong) UIImageView *navBarHairlineImageView;

//设置返回按钮
- (void)setNavBackArrow;

//返回按钮点击事件
- (void)navBackButtonClicked:(UIButton *)sender;

@end
