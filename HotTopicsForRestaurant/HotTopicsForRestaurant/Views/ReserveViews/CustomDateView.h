//
//  CustomDateView.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserveModel.h"

@interface CustomDateView : UIView

@property (nonatomic, copy) void (^block)(NSString *selectDate);

- (instancetype)initWithData:(NSArray *)data handler:(void (^)())handler;

- (void)configSelectWithTag:(NSInteger )tag;

- (void)refreshDayNum:(NSArray *)numArray;

@end
