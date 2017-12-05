//
//  RecoDishesCollectionViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2017/11/29.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoDishesModel.h"

@protocol RecoDishesDelegate<NSObject>

- (void)toScreen:(RecoDishesModel *)currentModel;

@end

@interface RecoDishesCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <RecoDishesDelegate> delegate;

- (void)configModelData:(RecoDishesModel *)model andIsFoodDish:(BOOL)isFoodDish;

@end
