//
//  CustomerTagView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomerTagView.h"

@interface CustomerTagView()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) NSMutableArray <UIButton *> * buttonArray;

@end

@implementation CustomerTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        self.titleLabel = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
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

- (void)reloadTagSource:(NSArray *)dataSource
{
    self.dataSource = dataSource;
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGRect rect = self.frame;
    if (nil == self.dataSource) {
        self.titleLabel.hidden = NO;
        [self.buttonArray removeAllObjects];
        rect.size.height = 40 * scale;
    }else{
        self.titleLabel.hidden = YES;
        [self createTagButton];
        if (self.buttonArray.count > 0) {
            
            UIButton * button = [self.buttonArray lastObject];
            rect.size.height = button.frame.origin.y + button.frame.size.height + 10 * scale;
            
        }else{
            rect.size.height = 40 * scale;
        }
    }
    self.frame = rect;
}

- (void)createTagButton
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    CGFloat distanceX = 10 * scale;
    CGFloat edgeInsetX = 25 * scale;
    CGFloat distanceY = 10 * scale;
    CGFloat startX = edgeInsetX;
    CGFloat startY = 10 * scale;
    
    [self.buttonArray removeAllObjects];
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        
        NSDictionary * info = [self.dataSource objectAtIndex:i];
        UIButton * button = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:[info objectForKey:@"name"] cornerRadius:5.f];
        button.layer.borderColor = UIColorFromRGB(0xece6de).CGColor;
        button.layer.borderWidth = .5f;
        button.contentEdgeInsets = UIEdgeInsetsMake(3 * scale, 10 * scale, 3 * scale, 10 * scale);
        [button sizeToFit];
        
        CGSize size = button.frame.size;
        CGFloat endX = startX + size.width;
        if (endX > self.frame.size.width - edgeInsetX) {
            startY += distanceY + size.height;
            startX = edgeInsetX;
            endX = startX + size.width;
            if (endX > self.frame.size.width - edgeInsetX) {
                size.width = self.frame.size.width - edgeInsetX * 2;
            }
        }
        button.frame = CGRectMake(startX, startY, size.width, size.height);
        button.layer.cornerRadius = size.height / 2.f;
        [self addSubview:button];
        [self.buttonArray addObject:button];
        startX = startX + size.width + distanceX;
    }
}

- (NSMutableArray<UIButton *> *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

@end
