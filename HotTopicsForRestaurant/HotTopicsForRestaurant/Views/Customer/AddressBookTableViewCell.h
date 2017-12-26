//
//  AddressBookTableViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/21.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAddressModel.h"

@interface AddressBookTableViewCell : UITableViewCell

@property (nonatomic, strong) RDAddressModel * model;

- (void)configWithAddressModel:(RDAddressModel *)model;

- (void)existCustomer:(BOOL)hasExist;

@end
