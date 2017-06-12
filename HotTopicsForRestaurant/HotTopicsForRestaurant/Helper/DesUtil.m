//
//  DesUtil.m
//  newProjcet
//
//  Created by lijiawei on 16/6/8.
//  Copyright © 2016年 SanShiChuangXiang. All rights reserved.
//

#import "DesUtil.h"
#import "ConverUtil.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation DesUtil

/*DES加密*/
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [clearText length];
    unsigned int bufferPtrSize = ([textData length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char buffer[bufferPtrSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes],dataLength,
                                          buffer, bufferPtrSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        ciphertext = [ConverUtil parseByteArray2HexString:bb length:numBytesEncrypted];
        
    }
    return ciphertext;
}

/**DES解密*/
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString *)key {
    NSString *cleartext = nil;
    NSData *textData = [ConverUtil parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    unsigned int bufferPtrSize = ([textData length] + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char buffer[bufferPtrSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes] ,dataLength,
                                          buffer, bufferPtrSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess){
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        cleartext = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }else{
    }
    return cleartext;
}


+(NSData *) encryptUseDESWithData:(NSData *)textData key:(NSString *)key {
    NSData *cipherData = nil;
    NSUInteger dataLength = [textData length];
    unsigned int bufferPtrSize = ((int)dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char buffer[bufferPtrSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes],dataLength,
                                          buffer, bufferPtrSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        Byte* bb = (Byte*)[data bytes];
        NSString* dataString = [ConverUtil parseByteArray2HexString:bb length:numBytesEncrypted];
        cipherData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    }
    return cipherData;
}

/**DES解密*/
+(NSData *) decryptUseDESWithData:(NSData *)hexData key:(NSString *)key {
    NSData *clearData = nil;
    NSString* plainText = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    NSData *textData = [ConverUtil parseHexToByteArray:plainText];
    NSUInteger dataLength = [textData length];
    unsigned int bufferPtrSize = ((int)dataLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    unsigned char buffer[bufferPtrSize];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          NULL,
                                          [textData bytes] ,dataLength,
                                          buffer, bufferPtrSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess){
        clearData = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
    }
    return clearData;
}


@end
