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
    }
    
    return self;
}

@end
