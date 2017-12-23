//
//  SingleAddressCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AddressBookTableViewCell.h"

@interface SingleAddressCell : AddressBookTableViewCell

@property (nonatomic, copy) void (^addButtonHandle)(RDAddressModel * model);

@end
