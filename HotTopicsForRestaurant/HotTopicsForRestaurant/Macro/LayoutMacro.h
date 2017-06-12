//
//  LayoutMacro.h
//  newProjcet
//
//  Created by lijiawei on 16/6/6.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#ifndef LayoutMacro_h
#define LayoutMacro_h

#define kMainScreenWidth    ([UIScreen mainScreen].applicationFrame).size.width //应用程序的宽度
#define kMainScreenHeight   ([UIScreen mainScreen].applicationFrame).size.height //应用程序的高度
#define kMainBoundsHeight   ([UIScreen mainScreen].bounds).size.height //屏幕的高度
#define kMainBoundsWidth    ([UIScreen mainScreen].bounds).size.width //屏幕的宽度

#define kTabBarHeight                        49.0f
#define kNaviBarHeight                       44.0f
#define kHeightFor4InchScreen                568.0f
#define kHeightFor3p5InchScreen              480.0f
#define kStatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define kRect(x, y, w, h)    CGRectMake(x, y, w, h)
#define kSize(w, h)                          CGSizeMake(w, h)
#define kPoint(x, y)                         CGPointMake(x, y)

#endif /* LayoutMacro_h */
