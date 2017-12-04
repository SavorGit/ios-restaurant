//
//  RecoDishesCollectionViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoDishesModel.h"

@interface RecoDishesCollectionViewCell : UICollectionViewCell

- (void)configModelData:(RecoDishesModel *)model andIsPortrait:(BOOL)isPortrait;

@end