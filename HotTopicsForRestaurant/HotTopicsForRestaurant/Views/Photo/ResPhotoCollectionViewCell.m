//
//  ResPhotoCollectionViewCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/6/12.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResPhotoCollectionViewCell.h"
#import "Masonry.h"

@interface ResPhotoCollectionViewCell ()

@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIImageView * bgImageView; //背景图
@property (nonatomic, strong) UIImageView * selectImageView;

@property (nonatomic, strong) PHAsset * asset;
@property (nonatomic, copy) PhotoCollectionViewCellClickedBlock block;

@end

@implementation ResPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.selectButton];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.selectImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.selectButton addSubview:self.selectImageView];
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        [self.selectImageView setImage:[UIImage imageNamed:@"xuanzhong"]];
        
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)selectButtonDidClicked:(UIButton *)button
{
    [UIView animateWithDuration:2.f animations:^{
        self.selectImageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.f animations:^{
            self.selectImageView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
    
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [self.selectImageView setImage:[UIImage imageNamed:@"yixuanzhong"]];
    }else{
        [self.selectImageView setImage:[UIImage imageNamed:@"xuanzhong"]];
    }
    
    self.block(self.asset, button.isSelected);
}

- (void)configSelectStatus:(BOOL)isSelect
{
    self.selectButton.selected = isSelect;
    if (isSelect) {
        [self.selectImageView setImage:[UIImage imageNamed:@"yixuanzhong"]];
    }else{
        [self.selectImageView setImage:[UIImage imageNamed:@"xuanzhong"]];
    }
}

- (void)changeChooseStatus:(BOOL)isChoose
{
    if (isChoose) {
        self.selectButton.alpha = 1.0;
    }else{
        self.selectButton.alpha = 0.f;
    }
}

- (void)configWithPHAsset:(PHAsset *)asset completionHandle:(PhotoCollectionViewCellClickedBlock)block
{
    self.asset = asset;
    self.block = block;
    if (asset) {
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CollectionViewCellSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                [self.bgImageView setImage:result];
            }else{
                [self photoDidBeDelete];
            }
        }];
    }else{
        [self photoDidBeDelete];
    }
}

- (void)photoDidBeDelete
{
    [self.bgImageView setImage:[UIImage imageNamed:@"tpysc"]];
}

@end
