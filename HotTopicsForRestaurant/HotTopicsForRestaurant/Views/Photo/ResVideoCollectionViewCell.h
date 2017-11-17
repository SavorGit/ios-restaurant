//
//  ResVideoCollectionViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/16.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^VideoCollectionViewCellClickedBlock)(PHAsset * asset, BOOL isSelect);
@interface ResVideoCollectionViewCell : UICollectionViewCell

- (void)configWithPHAsset:(PHAsset *)asset completionHandle:(VideoCollectionViewCellClickedBlock)block;

- (void)configSelectStatus:(BOOL)isSelect;

- (void)changeChooseStatus:(BOOL)isChoose;

- (void)photoDidBeDelete;

@end
