//
//  ColorMacro.h
//  newProjcet
//
//  Created by lijiawei on 16/6/6.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#ifndef ColorMacro_h
#define ColorMacro_h

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB(r, g, b) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** 默认背景颜色 */
#define kDefaultBackgroundColor     RGB(239, 239, 244)
/** 导航栏背景颜色 */
//#define kNavBackGround RGB(242, 242, 242)
#define kNavBackGround UIColorFromRGB(0x202020)
/** 标题黑色字样颜色 */
#define kTitleBlackTextColor RGB(30,30,30)
/** 内容灰色字样颜色 */
#define kContentGrayTextColor RGB(150,150,150)
/** 全局绿色按钮颜色 */
#define KButtonGreenBackGroundColor RGB(50,146,27)
/** 全局蓝色颜色 */
#define KBlueBackGroundColor RGB(21,126,251)
/** 全局白色  **/
#define kWhiteBackGroundColor UIColorFromRGB(0xffffff)

#endif /* ColorMacro_h */
