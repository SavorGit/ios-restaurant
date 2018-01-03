//
//  AddNewRemarkViewController.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/2.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"

typedef  void (^backBlock) (NSString *backStr);
@interface AddNewRemarkViewController : ResBaseViewController

@property(nonatomic, copy) backBlock backB;
- (instancetype)initWithCustomerId:(NSString *)customerId;

@end
