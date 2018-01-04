//
//  RDRoundAlertAction.m
//  HotTopicsForRestaurant
//
//  Created by 王海朋 on 2018/1/4.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RDRoundAlertAction.h"

@implementation RDRoundAlertAction

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)())handler bold:(BOOL)bold
{
    if (self = [super init]) {
        
        [self setTitle:title forState:UIControlStateNormal];
        self.block = handler;
        if (bold) {
            [self setBackgroundColor:UIColorFromRGB(0x922c3e)];
            self.titleLabel.font = kPingFangLight(16);
            [self setTitleColor:UIColorFromRGB(0xf6f2ed) forState:UIControlStateNormal];
        }else{
            self.layer.borderColor = UIColorFromRGB(0x922c3e).CGColor;
            self.layer.borderWidth = 1;
            self.titleLabel.font = kPingFangRegular(16);
            [self setTitleColor:UIColorFromRGB(0x922c3e) forState:UIControlStateNormal];
        }
        
    }
    return self;
}

- (instancetype)initVersionWithTitle:(NSString *)title handler:(void (^)())handler bold:(BOOL)bold
{
    if (self = [super init]) {
        
        [self setTitle:title forState:UIControlStateNormal];
        self.block = handler;
        [self setTitleColor:UIColorFromRGB(0x444444) forState:UIControlStateNormal];
        if (bold) {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }else{
            self.titleLabel.font = [UIFont systemFontOfSize:17];
        }
        [self addTarget:self action:@selector(didBeCicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)didBeCicked
{
    self.block();
}

@end
