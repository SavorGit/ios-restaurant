//
//  CustomerListViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "RDAddressModel.h"

@protocol CustomerListDelegate<NSObject>

- (void)customerListDidSelect:(RDAddressModel *)model;

@end

@interface CustomerListViewController : ResBaseViewController

@property (nonatomic, assign) id<CustomerListDelegate> delegate;

@end
