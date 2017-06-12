//
//  DesUtil.h
//  newProjcet
//
//  Created by lijiawei on 16/6/8.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DesUtil : NSObject

/**DES加密*/
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
/**DES解密*/
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key;

/**DES加密*/
+(NSData *) encryptUseDESWithData:(NSData *)textData key:(NSString *)key;
/**DES解密*/
+(NSData *) decryptUseDESWithData:(NSData *)hexData key:(NSString *)key;

@end
