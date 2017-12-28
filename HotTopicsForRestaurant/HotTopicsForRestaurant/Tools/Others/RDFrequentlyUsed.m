//
//  RDFrequentlyUsed.m
//  SavorX
//
//  Created by 王海朋 on 2017/7/22.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDFrequentlyUsed.h"

@implementation RDFrequentlyUsed

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

+ (CGFloat)getAttrHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger length = [title length];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    
    label.attributedText = attrString;
    CGFloat height = [label sizeThatFits:label.bounds.size].height;
    
    return height;
}

+ (CGFloat)getAttrHeightByWidthNoSpacing:(CGFloat)width title:(NSString *)title font:(UIFont *)font{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:title];
    NSUInteger length = [title length];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, length)];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = 5;//行间距
    style.headIndent = 0;//头部缩进，相当于左padding
    style.tailIndent = 0;//相当于右padding
    style.lineHeightMultiple = 1;//行间距是多少倍
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 0;//首行头缩进
    style.paragraphSpacing = 30;//段落后面的间距
    style.paragraphSpacingBefore = 0;//段落之前的间距
    style.lineBreakMode = NSLineBreakByWordWrapping;// 分割模式
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    
    label.attributedText = attrString;
    CGFloat height = [label sizeThatFits:label.bounds.size].height;
    
    return height;
}

@end
