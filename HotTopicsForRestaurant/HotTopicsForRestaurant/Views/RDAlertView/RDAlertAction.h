//
//  RDAlertAction.h
//  Test - 2.1
//
//  Created by 郭春城 on 17/3/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDAlertAction : UIButton

@property (nonatomic, copy) void (^block)();

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)())handler bold:(BOOL)bold;

- (instancetype)initVersionWithTitle:(NSString *)title handler:(void (^)())handler bold:(BOOL)bold;

@end
