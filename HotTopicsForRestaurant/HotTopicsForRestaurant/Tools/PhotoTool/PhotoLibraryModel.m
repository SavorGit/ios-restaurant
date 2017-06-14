//
//  PhotoLibraryModel.m
//  SavorX
//
//  Created by 郭春城 on 16/10/25.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "PhotoLibraryModel.h"

@implementation PhotoLibraryModel

- (instancetype)init
{
    if (self = [super init]) {
        self.assetSource = [NSMutableArray new];
    }
    return self;
}

@end
