//
//  RDRoundAlertAction.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDRoundAlertAction : UIButton

@property (nonatomic, copy) void (^block)();

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)())handler bold:(BOOL)bold;

- (instancetype)initVersionWithTitle:(NSString *)title handler:(void (^)())handler bold:(BOOL)bold;

@end
