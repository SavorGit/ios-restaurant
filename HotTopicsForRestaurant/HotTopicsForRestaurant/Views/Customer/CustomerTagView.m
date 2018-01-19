//
//  CustomerTagView.m
//  HotTopicsForRestaurant
//
//  Created by 郭春城 on 2017/12/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CustomerTagView.h"
#import "LightLabelRequest.h"

@interface CustomerTagView()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) NSMutableArray <UIButton *> * buttonArray;
@property (nonatomic, strong) NSMutableArray * lightButtonArray;
@property (nonatomic, strong) UIButton *button;

@end

@implementation CustomerTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        
        self.titleLabel = [Helper labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
        self.titleLabel.text = @"选择或输入客人信息后，可以进行标签管理";
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10 * scale);
            make.left.mas_equalTo(15 * scale);
            make.bottom.mas_equalTo(-10 * scale);
        }];
    }
    return self;
}

- (void)reloadTagSource:(NSArray *)dataSource
{
    self.dataSource = [[NSMutableArray alloc] initWithArray:dataSource];
    [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    CGRect rect = self.frame;
    if (nil == self.dataSource || self.dataSource.count == 0) {
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
        
        NSString * tagName = [info objectForKey:@"label_name"];
        if (isEmptyString(tagName)) {
            tagName = @"";
        }
        UIButton * button = [Helper buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:tagName cornerRadius:5.f];
        [self.titleArray addObject:tagName];
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
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = UIColorFromRGB(0xcecdcb).CGColor;
        button.tag = 100 + i;
        if (self.lightEnbale) {
            [button addTarget:self action:@selector(tagButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSInteger light = [[info objectForKey:@"light"] integerValue];
            if (light == 1) {
                [self giveLabelLight:button];
            }else{
                if ([self.lightIDArray containsObject:[info objectForKey:@"label_id"]]) {
                    [button setBackgroundColor:kAPPMainColor];
                    [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                    [self.lightButtonArray addObject:button];
                }
            }
        }
        [self addSubview:button];
        [self.buttonArray addObject:button];
        startX = startX + size.width + distanceX;
    }
}

- (void)giveLabelLight:(UIButton *)button
{
    self.button = button;
    
    BOOL lighted = [self.lightButtonArray containsObject:button];
    NSInteger index = button.tag - 100;
    NSDictionary * info = [self.dataSource objectAtIndex:index];
    NSString * tagName = [info objectForKey:@"label_name"];
    NSString * tagID = [info objectForKey:@"label_id"];
    if (isEmptyString(tagName)) {
        tagName = @"";
    }
    if (lighted) {
        if ([self.lightIDArray containsObject:tagID]) {
            [self.lightIDArray removeObject:tagID];
        }
        [self.lightButtonArray removeObject:button];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        
    }else{
        [self.lightIDArray addObject:tagID];
        [self.lightButtonArray addObject:button];
        [button setBackgroundColor:kAPPMainColor];
        [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }
}

- (void)tagButtonDidClicked:(UIButton *)button
{
    self.button = button;
    
    BOOL lighted = [self.lightButtonArray containsObject:button];
    NSInteger index = button.tag - 100;
    NSDictionary * info = [self.dataSource objectAtIndex:index];
    NSString * tagName = [info objectForKey:@"label_name"];
    NSString * tagID = [info objectForKey:@"label_id"];
    if (isEmptyString(tagName)) {
        tagName = @"";
    }
    if (lighted) {
        if (self.isCustomer == YES) {
            [self lightLabelRequest:tagID andType:@"3"];
        }else{
            if ([self.lightIDArray containsObject:tagID]) {
                [self.lightIDArray removeObject:tagID];
            }
            [self.lightButtonArray removeObject:button];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        }
        
    }else{
        if (self.isCustomer == YES) {
            [self lightLabelRequest:tagID andType:@"2"];
        }else{
            [self.lightIDArray addObject:tagID];
            [self.lightButtonArray addObject:button];
            [button setBackgroundColor:kAPPMainColor];
            [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }
    }
}

- (void)lightLabelRequest:(NSString *)labelId andType:(NSString *)type{
    
    NSMutableDictionary *parmsDic = [NSMutableDictionary new];
    if (!isEmptyString(labelId)) {
        [parmsDic setObject:labelId forKey:@"label_id"];
    }
    [parmsDic setObject:type forKey:@"type"];
    [parmsDic setObject:self.addressModel.customer_id forKey:@"customer_id"];
    
    LightLabelRequest * request = [[LightLabelRequest alloc] initWithCustomerInfo:parmsDic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        if ([[response objectForKey:@"code"] integerValue] ==10000) {
            if ([type isEqualToString:@"3"]) {
                if ([self.lightIDArray containsObject:labelId]) {
                    [self.lightIDArray removeObject:labelId];
                }
                [self.lightButtonArray removeObject:self.button];
                [self.button setBackgroundColor:[UIColor clearColor]];
                [self.button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            }else{
                [self.lightIDArray addObject:labelId];
                [self.lightButtonArray addObject:self.button];
                [self.button setBackgroundColor:kAPPMainColor];
                [self.button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            }
        }else{
            [MBProgressHUD showTextHUDwithTitle:response[@"msg"]];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [MBProgressHUD showTextHUDwithTitle:response[@"msg"]];
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
    
}

- (NSArray *)getLightTagSource
{
    NSMutableArray * source = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.lightButtonArray.count; i++) {
        
        UIButton * button = [self.lightButtonArray objectAtIndex:i];
        [source addObject:[self.dataSource objectAtIndex:button.tag - 100]];
        
    }
    return [NSArray arrayWithArray:source];
}

- (NSMutableArray<UIButton *> *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

- (NSMutableArray *)lightButtonArray
{
    if (!_lightButtonArray) {
        _lightButtonArray = [[NSMutableArray alloc] init];
    }
    return _lightButtonArray;
}

- (NSMutableArray *)lightIDArray
{
    if (!_lightIDArray) {
        _lightIDArray = [[NSMutableArray alloc] init];
    }
    return _lightIDArray;
}

@end
