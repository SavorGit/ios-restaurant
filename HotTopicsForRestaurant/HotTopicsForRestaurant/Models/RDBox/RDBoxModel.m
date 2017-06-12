//
//  RDBoxModel.m
//  SavorX
//
//  Created by 郭春城 on 16/12/13.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "RDBoxModel.h"

@implementation RDBoxModel

- (instancetype)init
{
    if (self = [super init]) {
        self.BoxID = @"";
        self.BoxIP = @"";
        self.roomID = 0;
        self.hotelID = 0;
        self.sid = @"";
    }
    return self;
}

@end
