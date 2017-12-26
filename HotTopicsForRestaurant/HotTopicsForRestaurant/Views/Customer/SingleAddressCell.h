//
//  SingleAddressCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAddressModel.h"

@interface SingleAddressCell : UITableViewCell

@property (nonatomic, strong) RDAddressModel * model;

@property (nonatomic, copy) void (^addButtonHandle)(RDAddressModel * model);

- (void)configWithAddressModel:(RDAddressModel *)model;

- (void)existCustomer:(BOOL)hasExist;

@end
