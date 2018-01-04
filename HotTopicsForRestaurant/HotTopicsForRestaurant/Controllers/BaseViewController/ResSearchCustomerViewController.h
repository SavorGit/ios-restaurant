//
//  ResSearchCustomerViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "RDAddressModel.h"

@protocol ResSearchCustomerDelegate<NSObject>

- (void)searchCustomerDidSelect:(RDAddressModel *)model;

@end

@interface ResSearchCustomerViewController : ResBaseViewController

@property (nonatomic, weak) UINavigationController * superNavigationController;
@property (nonatomic, assign) id<ResSearchCustomerDelegate> delegate;

@end
