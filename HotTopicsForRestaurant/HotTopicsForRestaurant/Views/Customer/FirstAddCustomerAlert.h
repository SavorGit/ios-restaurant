//
//  FirstAddCustomerAlert.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/3.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstAddCustomerAlert : UIView

@property (nonatomic, copy) void (^block)();

- (void)show;

@end
