//
//  ResPhotoCollectionViewCell.h
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^PhotoCollectionViewCellClickedBlock)(PHAsset * asset, BOOL isSelect);
@interface ResPhotoCollectionViewCell : UICollectionViewCell

- (void)configWithPHAsset:(PHAsset *)asset completionHandle:(PhotoCollectionViewCellClickedBlock)block;

- (void)configSelectStatus:(BOOL)isSelect;

- (void)changeChooseStatus:(BOOL)isChoose;

@end
