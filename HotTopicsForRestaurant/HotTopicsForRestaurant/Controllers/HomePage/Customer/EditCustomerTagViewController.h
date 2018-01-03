//
//  EditCustomerTagViewController.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/28.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResBaseViewController.h"
#import "RDAddressModel.h"

@protocol EditCustomerTagDelegate<NSObject>

- (void)customerTagDidUpdateWithLightData:(NSArray *)dataSource lightID:(NSArray *)idArray;

@end

@interface EditCustomerTagViewController : ResBaseViewController

@property (nonatomic, assign) id<EditCustomerTagDelegate> delegate;

- (instancetype)initWithModel:(RDAddressModel *)model andIsCustomer:(BOOL)isCustomer;

@end
