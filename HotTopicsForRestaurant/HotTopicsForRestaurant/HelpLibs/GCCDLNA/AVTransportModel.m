//
//  AVTransportModel.m
//  DLNATest
//
//  Created by 郭春城 on 16/10/11.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import "AVTransportModel.h"
#import "GDataXMLNode.h"

@implementation AVTransportModel

- (void)setInfoWithArray:(NSArray *)array
{
    for (GDataXMLElement * needEle in array) {
        if ([[needEle.name lowercaseString] isEqualToString:@"servicetype"]) {
            self.serviceType = [needEle stringValue];
        }
        if ([[needEle.name lowercaseString] isEqualToString:@"serviceid"]) {
            self.serviceId = [needEle stringValue];
        }
        if ([[needEle.name lowercaseString] isEqualToString:@"controlurl"]) {
            self.controlURL = [needEle stringValue];
        }
        if ([[needEle.name lowercaseString] isEqualToString:@"eventsuburl"]) {
            self.eventSubURL = [needEle stringValue];
        }
        if ([[needEle.name lowercaseString] isEqualToString:@"scpdurl"]) {
            self.SCPDURL = [needEle stringValue];
        }
    }
}

@end
