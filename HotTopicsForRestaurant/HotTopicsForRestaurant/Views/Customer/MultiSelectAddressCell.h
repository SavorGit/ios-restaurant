//
//  MultiSelectAddressCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAddressModel.h"

@interface MultiSelectAddressCell : UITableViewCell

@property (nonatomic, assign) BOOL hasExist;

- (void)configWithAddressModel:(RDAddressModel *)model;

- (void)mulitiSelected:(BOOL)isSelected;

- (void)existCustomer:(BOOL)hasExist;

@end
