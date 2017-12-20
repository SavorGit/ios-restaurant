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

@end
