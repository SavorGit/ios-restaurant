//
//  RDFrequentlyUsed.h
//  SavorX
//
//  Created by 王海朋 on 2017/7/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDFrequentlyUsed : NSObject

// 计算行高（传入宽度，文字内容，字号）
+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

// 计算特定富文本的行高（传入宽度，文字内容，字号）
+ (CGFloat)getAttrHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

// 计算特定富文本的行高,默认字符间距（传入宽度，文字内容，字号）
+ (CGFloat)getAttrHeightByWidthNoSpacing:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

@end
