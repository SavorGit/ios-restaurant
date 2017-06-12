//
//  AVTransportModel.h
//  DLNATest
//
//  Created by 郭春城 on 16/10/11.
//  Copyright © 2016年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVTransportModel : NSObject

@property (nonatomic, strong) NSString * serviceType;
@property (nonatomic, strong) NSString * serviceId;
@property (nonatomic, strong) NSString * controlURL;
@property (nonatomic, strong) NSString * eventSubURL;
@property (nonatomic, strong) NSString * SCPDURL;

- (void)setInfoWithArray:(NSArray *)array;

@end
