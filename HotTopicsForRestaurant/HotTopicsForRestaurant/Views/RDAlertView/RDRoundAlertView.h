//
//  RDRoundAlertView.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDRoundAlertAction.h"

@interface RDRoundAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)show;

- (void)addActions:(NSArray<RDRoundAlertAction *> *)actions;

@end
