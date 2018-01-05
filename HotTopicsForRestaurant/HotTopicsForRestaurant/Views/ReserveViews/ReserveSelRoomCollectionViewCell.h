//
//  ReserveSelRoomCollectionViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReserveModel.h"

@interface ReserveSelRoomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void)configModelData:(ReserveModel *)model;

@end
