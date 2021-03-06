//
//  AddNewCustomerController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "RDAddressModel.h"

@interface AddNewCustomerController : ResBaseViewController

@property (nonatomic, strong) NSMutableArray * customerList;

- (instancetype)initWithDataModel:(RDAddressModel *)model;

@end
