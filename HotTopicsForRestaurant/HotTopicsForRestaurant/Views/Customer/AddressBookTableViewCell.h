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

- (void)configWithAddressModel:(RDAddressModel *)model;

@end
