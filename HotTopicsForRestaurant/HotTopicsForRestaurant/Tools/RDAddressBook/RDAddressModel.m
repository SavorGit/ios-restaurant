//
//  RDAddressModel.m
//  通讯录
//
//  Created by 郭春城 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDAddressModel.h"

@implementation RDAddressModel

- (NSMutableArray *)mobileArray
{
    if (!_mobileArray) {
        _mobileArray = [[NSMutableArray alloc] init];
    }
    return _mobileArray;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.searchKey forKey:@"searchKey"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.pinYin forKey:@"pinYin"];
    [aCoder encodeObject:self.mobileArray forKey:@"mobileArray"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.logoImageURL forKey:@"logoImageURL"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.searchKey = [aDecoder decodeObjectForKey:@"searchKey"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.pinYin = [aDecoder decodeObjectForKey:@"pinYin"];
        self.mobileArray = [aDecoder decodeObjectForKey:@"mobileArray"];
        self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
        self.logoImageURL = [aDecoder decodeObjectForKey:@"logoImageURL"];
        
    }
    
    return self;
}

@end
