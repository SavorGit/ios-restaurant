//
//  RDAlertView.h
//  Test - 2.1
//
//  Created by 郭春城 on 17/3/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAlertAction.h"

@interface RDAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)show;

- (void)addActions:(NSArray<RDAlertAction *> *)actions;

@end
