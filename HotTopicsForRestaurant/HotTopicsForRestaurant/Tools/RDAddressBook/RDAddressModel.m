//
//  RDAddressModel.m
//  通讯录
//
//  Created by 郭春城 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDAddressModel.h"

@implementation RDAddressModel

- (instancetype)initWithNetDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.name = [dict objectForKey:@"name"];
        self.searchKey = [dict objectForKey:@"name"];
        
        self.logoImageURL = [dict objectForKey:@"face_url"];
        
        NSString * mobile = [dict objectForKey:@"mobile"];
        NSString * mobile1 = [dict objectForKey:@"mobile1"];
        if (!isEmptyString(mobile)) {
            [self.mobileArray addObject:mobile];
            self.searchKey = [self.searchKey stringByAppendingString:mobile];
        }
        if (!isEmptyString(mobile1)) {
            [self.mobileArray addObject:mobile1];
            self.searchKey = [self.searchKey stringByAppendingString:mobile1];
        }
        self.customer_id = [dict objectForKey:@"customer_id"];
        
    }
    return self;
}

- (NSMutableArray *)mobileArray
{
    if (!_mobileArray) {
        _mobileArray = [[NSMutableArray alloc] init];
    }
    return _mobileArray;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.searchKey forKey:@"searchKey"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.pinYin forKey:@"pinYin"];
    [aCoder encodeObject:self.mobileArray forKey:@"mobileArray"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.logoImageURL forKey:@"logoImageURL"];
    [aCoder encodeObject:self.customer_id forKey:@"customer_id"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.birthplace forKey:@"birthplace"];
    [aCoder encodeObject:self.consumptionLevel forKey:@"consumptionLevel"];
    [aCoder encodeObject:self.invoiceTitle forKey:@"invoiceTitle"];
    [aCoder encodeObject:self.firstLetter forKey:@"firstLetter"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.searchKey = [aDecoder decodeObjectForKey:@"searchKey"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.pinYin = [aDecoder decodeObjectForKey:@"pinYin"];
        self.mobileArray = [aDecoder decodeObjectForKey:@"mobileArray"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.logoImageURL = [aDecoder decodeObjectForKey:@"logoImageURL"];
        self.customer_id = [aDecoder decodeObjectForKey:@"customer_id"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.birthplace = [aDecoder decodeObjectForKey:@"birthplace"];
        self.consumptionLevel = [aDecoder decodeObjectForKey:@"consumptionLevel"];
        self.invoiceTitle = [aDecoder decodeObjectForKey:@"invoiceTitle"];
        self.firstLetter = [aDecoder decodeObjectForKey:@"firstLetter"];
    }
    
    return self;
}

- (void)setName:(NSString *)name
{
    if (!isEmptyString(name)) {
        _name = name;
        _pinYin = [self getLetterFromString:name];
        
        NSString *firstString = [_pinYin substringToIndex:1];
        NSString * regexA = @"^[A-Z]$";
        NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
        // 获取并返回首字母
        _firstLetter =[predA evaluateWithObject:firstString] ? firstString : @"#";
    }
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)getLetterFromString:(NSString *)aString
{
    /**
     * **************************************** START ***************************************
     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音转换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    return strPinYin;
    
}

/**
 多音字处理
 */
- (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}

@end
