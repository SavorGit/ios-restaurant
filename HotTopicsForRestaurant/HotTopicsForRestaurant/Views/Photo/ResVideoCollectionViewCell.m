//
//  ResVideoCollectionViewCell.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/11/16.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ResVideoCollectionViewCell.h"
#import "SAVORXAPI.h"

@interface ResVideoCollectionViewCell ()

@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIImageView * bgImageView; //背景图

@property (nonatomic, strong) PHAsset * asset;
@property (nonatomic, copy) VideoCollectionViewCellClickedBlock block;

@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation ResVideoCollectionViewCell

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
        [self.selectButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"yixuanzhong"] forState:UIControlStateSelected];
        [self.selectButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        self.selectButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        self.selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 5)];
        [self.selectButton.imageView setContentMode:UIViewContentModeCenter];
        [self.contentView addSubview:self.selectButton];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.timeLabel = [Helper labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangLight(12) alignment:NSTextAlignmentCenter];
        self.timeLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(20);
            make.width.mas_greaterThanOrEqualTo(45);
        }];
        self.timeLabel.layer.cornerRadius = 10.f;
        self.timeLabel.layer.masksToBounds = YES;
        
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)selectButtonDidClicked:(UIButton *)button
{
    
    [UIView animateWithDuration:.1f animations:^{
        button.imageView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1f animations:^{
            button.imageView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
    
    button.selected = !button.isSelected;
    self.block(self.asset, button.isSelected);
}

- (void)configSelectStatus:(BOOL)isSelect
{
    self.selectButton.selected = isSelect;
}

- (void)changeChooseStatus:(BOOL)isChoose
{
    if (isChoose) {
        self.selectButton.alpha = 1.0;
    }else{
        self.selectButton.alpha = 0.f;
    }
}

- (void)configWithPHAsset:(PHAsset *)asset completionHandle:(VideoCollectionViewCellClickedBlock)block
{
    self.asset = asset;
    self.block = block;
    
    if (asset) {
        long long minute = 0, second = 0;
        second = asset.duration;
        minute = second / 60;
        second = second % 60;
        self.timeLabel.text = [NSString stringWithFormat:@"%.2lld'%.2lld\"", minute, second];
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
