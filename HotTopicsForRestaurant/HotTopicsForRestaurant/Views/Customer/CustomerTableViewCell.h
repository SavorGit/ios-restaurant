//
//  CustomerTableViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDAddressModel.h"

@interface CustomerTableViewCell : UITableViewCell

@property (nonatomic, strong) RDAddressModel * model;

- (void)configWithAddressModel:(RDAddressModel *)model;

@end
