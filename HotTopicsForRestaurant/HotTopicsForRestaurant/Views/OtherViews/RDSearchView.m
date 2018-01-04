//
//  RDSearchView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/20.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDSearchView.h"

@implementation RDSearchView

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder cornerRadius:(CGFloat)cornerRadius font:(UIFont *)font
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = UIColorFromRGB(0xe1dbd4).CGColor;
        self.layer.borderWidth = .5f;
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setImage:[UIImage imageNamed:@"sousuo"]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10 * scale);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(17 * scale);
        }];
        
        UILabel * searchTitleLabel = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:font alignment:NSTextAlignmentLeft];
        searchTitleLabel.text = placeholder;
        [self addSubview:searchTitleLabel];
        [searchTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            make.left.mas_equalTo(imageView.mas_right).offset(5 * scale);
        }];
    }
    return self;
}

@end
