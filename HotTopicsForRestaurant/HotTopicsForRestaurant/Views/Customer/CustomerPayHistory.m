//
//  CustomerPayHistory.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomerPayHistory.h"
#import "UIImageView+WebCache.h"

@interface CustomerPayHistory ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * bigScrollView;
@property (nonatomic, strong) UIImageView * bigImageView;
@property (nonatomic, assign) BOOL isBigPhoto;

@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation CustomerPayHistory

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        self.titleLabel = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
        self.titleLabel.text = @"请上传就餐小票，更好了解客户喜好~";
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10 * scale);
            make.left.mas_equalTo(15 * scale);
            make.right.mas_equalTo(-15 * scale);
            make.bottom.mas_equalTo(-10 * scale);
        }];
    }
    return self;
}

- (void)addImageWithImage:(UIImage *)image
{
    if (image) {
        self.titleLabel.hidden = YES;
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        CGFloat distanceX = 10 * scale;
        CGFloat edgeInsetX = 25 * scale;
        CGFloat distanceY = 10 * scale;
        NSInteger hang = self.imageArray.count / 2;
        NSInteger lie = self.imageArray.count % 2;
        CGFloat width = (kMainBoundsWidth - edgeInsetX * 2 - distanceX) / 2.f;
        CGFloat height = 120 * scale;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(edgeInsetX + (width + distanceX) * lie, distanceY + (height + distanceY) * hang, width, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        [imageView setImage:image];
        
        CGRect frame = self.frame;
        frame.size.height = imageView.frame.origin.y + imageView.frame.size.height + 10 * scale;
        self.frame = frame;
        [self.imageArray addObject:image];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView == self.bigScrollView) {
        CGSize superSize = self.bigScrollView.frame.size;
        CGPoint center = CGPointMake(superSize.width / 2, superSize.height / 2);
        CGSize size = self.bigImageView.frame.size;
        if (size.width > superSize.width) {
            center.x = size.width / 2;
        }
        if (size.height > superSize.height) {
            center.y = size.height / 2;
        }
        self.bigImageView.center = center;
    }
}

- (void)showWindowImage:(UIImage *)image
{
    self.isBigPhoto = YES;
    self.bigScrollView.zoomScale = 1.f;
    if (image) {
        CGFloat scale = self.bigScrollView.frame.size.width / self.bigScrollView.frame.size.height;
        CGFloat imageScale = image.size.width / image.size.height;
        
        CGRect frame;
        if (imageScale > scale) {
            CGFloat width = self.bigScrollView.frame.size.width;
            CGFloat height = self.bigScrollView.frame.size.width / image.size.width * image.size.height;
            frame = CGRectMake(0, 0, width, height);
        }else{
            CGFloat height = self.bigScrollView.frame.size.height;
            CGFloat width = self.bigScrollView.frame.size.height / image.size.height * image.size.width;
            frame = CGRectMake(0, 0, width, height);
        }
        self.bigImageView.frame = frame;
        self.bigImageView.center = self.bigScrollView.center;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigScrollView];
}

- (NSMutableArray<UIImage *> *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

@end
