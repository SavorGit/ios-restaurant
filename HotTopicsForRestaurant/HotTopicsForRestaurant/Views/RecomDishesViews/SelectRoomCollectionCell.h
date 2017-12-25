//
//  SelectRoomCollectionCell.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/12/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserveModel.h"

@interface SelectRoomCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)configModelData:(ReserveModel *)model;

@end
