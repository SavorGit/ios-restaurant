//
//  NewDishesCollectionViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoDishesModel.h"

@protocol RecoDishesDelegate<NSObject>

- (void)clickSelectManyImage;
- (void)toScreen:(RecoDishesModel *)currentModel;

@end


@interface NewDishesCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <RecoDishesDelegate> delegate;

- (void)configModelData:(RecoDishesModel *)model andIsFoodDish:(BOOL)isFoodDish;

@end
