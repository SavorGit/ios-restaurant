//
//  UIImage+Additional.h
//  newProjcet
//
//  Created by shanWu on 16/6/6.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additional)

//通过色值生成图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//通过url获取图片
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

//按照指定的大小缩放图片
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)originImageScaleToSize:(CGSize)size;
@end
