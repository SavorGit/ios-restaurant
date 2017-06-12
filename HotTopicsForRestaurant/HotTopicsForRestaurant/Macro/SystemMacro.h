//
//  SystemMacro.h
//  newProjcet
//
//  Created by lijiawei on 16/6/6.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#ifndef SystemMacro_h
#define SystemMacro_h

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define CURRENTSYSTEM  [[[UIDevice currentDevice] systemVersion] floatValue]

/** 获取APP的版本号 */
#define kSoftwareVersion    ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
/** 获取app内部的版本号 */
#define kBuildwareVersion    ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"])
/**获取app的名称**/
#define kBundleDisplayName   ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])

///**获取NSBundele中的资源图片**/
#define IMAGE_AT_APPDIR(name)       [Helper imageAtApplicationDirectoryWithName:name]

#define kEncryptOrDecryptKey  @"z&-etago0n!"

#define isNull(x)             (!x || [x isKindOfClass:[NSNull class]])
#define isEmptyString(x)      (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"])

//**渠道号**//
#define kChannelId     @"10000"

#define kSignKey       @"etago2016#*$%^*)##%(2026"

//-------------------字体大小-------------------------
#define FontSizeDefault 14.0f
#define FontSizeSmall 12.0f
#define FontSizeBig 16.0f


#endif /* SystemMacro_h */
