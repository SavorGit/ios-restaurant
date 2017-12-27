//
//  AddNewReserveViewController.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "ReserveModel.h"

typedef  void (^backBlock) (NSString *backStr);
@interface AddNewReserveViewController : ResBaseViewController

@property(nonatomic, copy) backBlock backB;
- (instancetype)initWithDataModel:(ReserveModel *)model andType:(BOOL)isAddType;

@end
