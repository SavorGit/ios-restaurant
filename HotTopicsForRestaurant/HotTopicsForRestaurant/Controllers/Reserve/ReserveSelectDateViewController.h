//
//  ReserveSelectDateViewController.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"

typedef  void (^backBlock) (NSString *backStr);
@interface ReserveSelectDateViewController : ResBaseViewController

@property(nonatomic, copy) backBlock backB;
- (instancetype)initWithDate:(NSString *)dateStr;

@end
